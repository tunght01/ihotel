import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/base/base_error.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';
import 'package:ihostel/app/data/models/ez_user/ez_user.dart';
import 'package:ihostel/app/data/repository/ez_group_room/ez_group_room_repository.dart';
import 'package:ihostel/app/data/usecase/member_group_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'add_member_cubit.freezed.dart';

@freezed
class AddMemberState extends BaseCubitState with _$AddMemberState {
  const factory AddMemberState({
    EzGroupRoom? ezRoom,
    EzUser? ezUser,
    @Default([]) List<EzGroupRoom> allRoom,
    @Default([]) List<EzGroupRoomUser> roomUser,
  }) = _AddMemberState;
}

@injectable
class AddMemberCubit extends BaseCubit<AddMemberState> {
  AddMemberCubit(
    this._memberGroupUseCase,
    this._ezGroupRoomRepository,
  ) : super(const AddMemberState());
  final MemberGroupUseCase _memberGroupUseCase;
  final EzGroupRoomRepository _ezGroupRoomRepository;
  late StreamSubscription<List<List<dynamic>>> _roomStreamSubscription;

  Future<void> load(EzGroup group) async {
    _roomStreamSubscription = CombineLatestStream<List<dynamic>, List<List<dynamic>>>(
      [
        _ezGroupRoomRepository.getRoomsByGroupIdStream(group.id),
      ],
      (values) => values,
    ).listen((values) {
      final rooms = values[0].map((e) => e as EzGroupRoom).toList();
      emit(state.copyWith(allRoom: rooms));
    });
  }

  void onUserRoomChange(EzUser? value) {
    emit(state.copyWith(ezUser: value));
  }

  void onEzGroupRoomChange(EzGroupRoom? value) {
    emit(state.copyWith(ezRoom: value));
  }

  void onItemRoomChange(String id, {String? name, String? phone, EzUser? user, EzGroupRoom? room}) {
    final updatedRooms = state.roomUser.map((roomUser) {
      if (roomUser.id == id) {
        return roomUser.copyWith(
          firstName: user?.firstName ?? name,
          phone: user?.phone ?? phone,
          linkedUserId: user?.id,
          groupRoomId: room?.id ?? state.allRoom.firstOrNull?.id,
        );
      } else {
        return roomUser;
      }
    }).toList(growable: true);
    emit(state.copyWith(roomUser: []));
    emit(state.copyWith(roomUser: updatedRooms));
  }

  void addRoomUser({EzUser? user}) {
    final updatedRooms = state.roomUser.toList(growable: true);
    final roomUser = EzGroupRoomUser(
      firstName: user?.firstName ?? '',
      lastName: user?.lastName ?? '',
      phone: user?.phone ?? '',
      linkedUserId: user?.id ?? '',
      groupRoomId: state.allRoom.firstOrNull?.id ?? '',
    );
    emit(state.copyWith(roomUser: updatedRooms..add(roomUser)));
  }

  void removeRoomUser(String id) {
    final updatedRooms = state.roomUser.toList(growable: true)..removeWhere((e) => e.id == id);
    emit(state.copyWith(roomUser: updatedRooms));
  }

  FutureOr<void> save(EzGroup ezGroup, {VoidCallback? onDone}) async {
    await runCubitCatching(
      action: () async {
        final isValidate = state.roomUser.every(
          (e) =>
              e.firstName.isNotEmpty && //
              e.phone.isNotEmpty && //
              e.groupRoomId.isNotEmpty,
        );

        if (state.roomUser.isNotEmpty && isValidate) {
          await _memberGroupUseCase.createMemberRoomCall(ezGroup: ezGroup, roomUsers: state.roomUser);
        } else {
          throw const BaseError(ExceptionType.error, 'Vui lòng nhập đầy đủ thông tin');
        }
        onDone?.call();
      },
      success: 'Tạo thành viên thành công',
    );
  }

  @override
  Future<void> close() {
    _roomStreamSubscription.cancel();
    return super.close();
  }
}

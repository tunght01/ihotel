import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/repository/ez_group_room/ez_group_room_repository.dart';
import 'package:ihostel/app/data/repository/ez_group_room_user/ez_group_room_user_repository.dart';
import 'package:ihostel/feature/room/room_manager/data/combine_room.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'room_manager_cubit.freezed.dart';

@freezed
class RoomManagerState extends BaseCubitState with _$RoomManagerState {
  const factory RoomManagerState({
    @Default([]) List<CombineRoom> roomsStaying,
    @Default([]) List<CombineRoom> roomsEmpty,
    @Default([]) List<CombineRoom> allRoom,
  }) = _RoomManagerState;
}

@injectable
class RoomManagerCubit extends BaseCubit<RoomManagerState> {
  RoomManagerCubit(
    this._ezGroupRoomRepository,
    this._ezGroupRoomUserRepository,
  ) : super(const RoomManagerState());
  final EzGroupRoomRepository _ezGroupRoomRepository;
  final EzGroupRoomUserRepository _ezGroupRoomUserRepository;

  late StreamSubscription<List<List<dynamic>>> _roomStreamSubscription;

  Future<void> load(EzGroup group) async {
    _roomStreamSubscription = CombineLatestStream<List<dynamic>, List<List<dynamic>>>(
      [
        _ezGroupRoomRepository.getRoomsByGroupIdStream(group.id),
        _ezGroupRoomUserRepository.getUsersByGroupIdStream(group.id),
      ],
      (values) => values,
    ).listen((values) {
      final rooms = values[0].map((e) => e as EzGroupRoom).toList();
      final hostels = rooms.map((e) {
        final users = _ezGroupRoomUserRepository.getUsersByRoomId(e.id);
        return CombineRoom(room: e, members: users);
      }).toList(growable: true);
      emit(state.copyWith(allRoom: hostels));
      final roomsStaying = hostels.where((e) => e.members.isNotEmpty).toList(growable: true);
      final roomsEmpty = hostels.where((e) => e.members.isEmpty).toList(growable: true);
      emit(state.copyWith(roomsStaying: roomsStaying, roomsEmpty: roomsEmpty));
    });
  }

  @override
  Future<void> close() {
    _roomStreamSubscription.cancel();
    return super.close();
  }
}

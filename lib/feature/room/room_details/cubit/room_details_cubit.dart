import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';
import 'package:ihostel/app/data/repository/ez_group/ez_group_repository.dart';
import 'package:ihostel/app/data/repository/ez_group_room_user/ez_group_room_user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'room_details_cubit.freezed.dart';

@freezed
class RoomDetailsState extends BaseCubitState with _$RoomDetailsState {
  const factory RoomDetailsState({
    @Default([]) List<EzGroupRoomUser> members,
    @Default(null) EzGroup? group,
  }) = _RoomDetailsState;
}

@injectable
class RoomDetailsCubit extends BaseCubit<RoomDetailsState> {
  RoomDetailsCubit(
    this._ezGroupRoomUserRepository,
    this._ezGroupRepository,
  ) : super(const RoomDetailsState());
  final EzGroupRoomUserRepository _ezGroupRoomUserRepository;
  final EzGroupRepository _ezGroupRepository;
  late StreamSubscription<List<List<dynamic>>> _roomStreamSubscription;

  Future<void> load(EzGroupRoom room) async {
    final group = _ezGroupRepository.getById(room.groupId);
    emit(state.copyWith(group: group));
    _roomStreamSubscription = CombineLatestStream<List<dynamic>, List<List<dynamic>>>(
      [
        _ezGroupRoomUserRepository.getUsersByRoomIdStream(room.id),
      ],
      (values) => values,
    ).listen(
      (value) {
        final members = value[0].map((e) => e as EzGroupRoomUser).toList(growable: true);
        emit(state.copyWith(members: members));
      },
    );
  }

  @override
  Future<void> close() {
    _roomStreamSubscription.cancel();
    return super.close();
  }
}

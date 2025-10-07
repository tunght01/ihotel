import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';
import 'package:ihostel/app/data/repository/ez_group_room/ez_group_room_repository.dart';
import 'package:ihostel/app/data/repository/ez_group_room_user/ez_group_room_user_repository.dart';
import 'package:ihostel/feature/member/list_member/data/combine_user_room.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'list_member_cubit.freezed.dart';

@freezed
class ListMemberState extends BaseCubitState with _$ListMemberState {
  const factory ListMemberState({
    @Default([]) List<CombineUserRoom> usersUsing,
    @Default([]) List<CombineUserRoom> usersDiscontinued,
  }) = _ListMemberState;
}

@injectable
class ListMemberCubit extends BaseCubit<ListMemberState> {
  ListMemberCubit(
    this._ezGroupRoomRepository,
    this._ezGroupRoomUserRepository,
  ) : super(const ListMemberState());
  final EzGroupRoomRepository _ezGroupRoomRepository;
  final EzGroupRoomUserRepository _ezGroupRoomUserRepository;
  late StreamSubscription<List<List<dynamic>>> _groupStreamSubscription;

  Future<void> load(String groupId) async {
    _groupStreamSubscription = CombineLatestStream<List<dynamic>, List<List<dynamic>>>(
      [
        _ezGroupRoomUserRepository.getUsersByGroupIdStream(groupId),
        _ezGroupRoomRepository.getListStream(),
      ],
      (values) => values,
    ).listen((values) {
      final roomUser = values[0].map((e) => e as EzGroupRoomUser).toList();
      final memberRoom = roomUser.map((e) {
        final rooms = _ezGroupRoomRepository.getById(e.groupRoomId);
        return CombineUserRoom(room: rooms, groupRoomUser: e);
      }).toList(growable: true);
      final userUsing = memberRoom.where((e) => e.groupRoomUser?.endDate == 0).toList(growable: true);
      final usersDiscontinued = memberRoom.where((e) => e.groupRoomUser?.endDate == 1).toList(growable: true);
      emit(state.copyWith(usersUsing: userUsing, usersDiscontinued: usersDiscontinued));
    });
  }

  @override
  Future<void> close() {
    _groupStreamSubscription.cancel();
    return super.close();
  }
}

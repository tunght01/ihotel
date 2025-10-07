import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/repository/ez_group/ez_group_repository.dart';
import 'package:ihostel/app/data/repository/ez_group_room/ez_group_room_repository.dart';
import 'package:ihostel/app/data/repository/ez_group_room_user/ez_group_room_user_repository.dart';
import 'package:ihostel/feature/home/shell/data/combine_hostel.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'home_cubit.freezed.dart';

@freezed
class HomeState extends BaseCubitState with _$HomeState {
  const factory HomeState({
    @Default([]) List<CombineHostel> groupsWorking,
    @Default([]) List<CombineHostel> groupsCompleted,
  }) = _HomeState;
}

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  HomeCubit(
    this._ezGroupRepository,
    this._ezGroupRoomRepository,
    this._ezGroupRoomUserRepository,
  ) : super(const HomeState());
  final EzGroupRepository _ezGroupRepository;
  final EzGroupRoomRepository _ezGroupRoomRepository;
  final EzGroupRoomUserRepository _ezGroupRoomUserRepository;
  late StreamSubscription<List<List<dynamic>>> _groupStreamSubscription;

  Future<void> load() async {
    _groupStreamSubscription = CombineLatestStream<List<dynamic>, List<List<dynamic>>>(
      [
        _ezGroupRepository.getListStream(),
        _ezGroupRoomRepository.getListStream(),
        _ezGroupRoomUserRepository.getListStream(),
      ],
      (values) => values,
    ).listen((values) {
      final groups = values[0].map((e) => e as EzGroup).toList();
      final hostels = groups.map((e) {
        final rooms = _ezGroupRoomRepository.getRoomsByGroupId(e.id);
        final users = _ezGroupRoomUserRepository.getUsersByGroupId(e.id);
        return CombineHostel(group: e, rooms: rooms, members: users);
      }).toList(growable: true);

      emit(state.copyWith(groupsWorking: hostels));
    });
  }

  @override
  Future<void> close() {
    _groupStreamSubscription.cancel();
    return super.close();
  }
}

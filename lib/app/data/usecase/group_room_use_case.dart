import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/repository/ez_group/ez_group_repository.dart';
import 'package:ihostel/app/data/repository/ez_group_room/ez_group_room_repository.dart';
import 'package:ihostel/feature/home/create_hostel/data/fast_room.dart';
import 'package:injectable/injectable.dart';

@injectable
class GroupRoomUseCase {
  const GroupRoomUseCase(
    this._ezGroupRoomRepository,
    this._ezGroupRepository,
    this._localStorageDataSource,
  );

  final EzGroupRoomRepository _ezGroupRoomRepository;
  final EzGroupRepository _ezGroupRepository;
  final LocalStorageDataSource _localStorageDataSource;

  Future<void> createGroupCall({
    required EzGroup group,
    List<FastRoom> rooms = const [],
    int startDate = 1,
  }) async {
    final list = rooms
        .map(
          (e) => EzGroupRoom(
            groupId: group.id,
            name: e.name,
            price: e.price,
            startDate: startDate,
            creatorId: _localStorageDataSource.userId,
          ),
        )
        .toList(growable: true);
    _ezGroupRepository.insert(group);
    _ezGroupRoomRepository.insertList(list);
  }
}

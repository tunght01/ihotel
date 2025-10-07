import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';

abstract class EzGroupRoomRepository extends BaseRepository<EzGroupRoom> {
  EzGroupRoomRepository(super.isar, super.isarCollection, super.database);

  Stream<EzGroupRoom> streamRoomById(String id);

  List<EzGroupRoom> getRoomsByGroupId(String groupId);

  Stream<List<EzGroupRoom>> getRoomsByGroupIdStream(String groupId);
}

import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';

abstract class EzGroupRoomUserRepository extends BaseRepository<EzGroupRoomUser> {
  EzGroupRoomUserRepository(super.isar, super.isarCollection, super.database);

  Stream<EzGroupRoomUser> streamUserById(String id);

  List<EzGroupRoomUser> getUsersByRoomId(String roomId);

  Stream<List<EzGroupRoomUser>> getUsersByRoomIdStream(String roomId);

  List<EzGroupRoomUser> getUsersByGroupId(String groupId);

  Stream<List<EzGroupRoomUser>> getUsersByGroupIdStream(String groupId);

  List<EzGroupRoomUser> getAllRoomUseByLinkUserId(String userId);
}

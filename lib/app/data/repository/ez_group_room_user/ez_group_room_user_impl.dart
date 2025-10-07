import 'package:firebase_database/firebase_database.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';
import 'package:ihostel/app/data/repository/ez_group_room_user/ez_group_room_user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

@LazySingleton(as: EzGroupRoomUserRepository)
class EzUserImpl extends EzGroupRoomUserRepository {
  EzUserImpl(Isar isar, FirebaseDatabase database) : super(isar, isar.ezGroupRoomUsers, database);

  @override
  Stream<EzGroupRoomUser> streamUserById(String id) {
    return isarCollection.filter().idEqualTo(id).watch(fireImmediately: true).map((event) => event.first);
  }

  @override
  EzGroupRoomUser? getById(String id) => isarCollection.where().isarIdEqualTo(id.fastHash()).findFirstSync();

  @override
  List<EzGroupRoomUser> get listLocal => isarCollection.where().findAllSync();

  @override
  EzGroupRoomUser fromJson(Map<String, dynamic> json) => EzGroupRoomUser.fromJson(json);

  @override
  List<EzGroupRoomUser> getUsersByRoomId(String roomId) => isarCollection.filter().groupRoomIdEqualTo(roomId).findAllSync();

  @override
  Stream<List<EzGroupRoomUser>> getUsersByRoomIdStream(String roomId) => isarCollection.filter().groupRoomIdEqualTo(roomId).watch(fireImmediately: true);

  @override
  List<EzGroupRoomUser> getUsersByGroupId(String groupId) => isarCollection.filter().groupIdEqualTo(groupId).findAllSync();

  @override
  Stream<List<EzGroupRoomUser>> getUsersByGroupIdStream(String groupId) => isarCollection.filter().groupIdEqualTo(groupId).watch(fireImmediately: true);

  @override
  List<EzGroupRoomUser> getAllRoomUseByLinkUserId(String userId) => isarCollection.filter().linkedUserIdEqualTo(userId).isDeletedEqualTo(false).roleIsEmpty().findAllSync();
}

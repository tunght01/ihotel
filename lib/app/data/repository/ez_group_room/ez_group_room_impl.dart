import 'package:firebase_database/firebase_database.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/repository/ez_group_room/ez_group_room_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

@LazySingleton(as: EzGroupRoomRepository)
class EzGroupRoomImpl extends EzGroupRoomRepository {
  EzGroupRoomImpl(Isar isar, FirebaseDatabase database) : super(isar, isar.ezGroupRooms, database);

  @override
  Stream<EzGroupRoom> streamRoomById(String id) {
    return isarCollection.filter().idEqualTo(id).watch(fireImmediately: true).map((event) => event.first);
  }

  @override
  EzGroupRoom? getById(String id) => isarCollection.where().isarIdEqualTo(id.fastHash()).findFirstSync();

  @override
  List<EzGroupRoom> get listLocal => isarCollection.where().findAllSync();

  @override
  EzGroupRoom fromJson(Map<String, dynamic> json) => EzGroupRoom.fromJson(json);

  @override
  List<EzGroupRoom> getRoomsByGroupId(String groupId) => isarCollection.filter().groupIdEqualTo(groupId).findAllSync();

  @override
  Stream<List<EzGroupRoom>> getRoomsByGroupIdStream(String groupId) => isarCollection.filter().groupIdEqualTo(groupId).watch(fireImmediately: true);
}

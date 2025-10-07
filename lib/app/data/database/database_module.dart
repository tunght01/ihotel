import 'package:firebase_database/firebase_database.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';
import 'package:ihostel/app/data/models/ez_user/ez_user.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CollectionSchema<dynamic>> schemas = [
  EzUserSchema,
  EzGroupSchema,
  EzGroupRoomSchema,
  EzGroupRoomUserSchema,
];

@module
abstract class DatabaseModule {
  @preResolve
  Future<SharedPreferences> provideSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  @LazySingleton()
  FirebaseDatabase get database => FirebaseDatabase.instance;

  @preResolve
  Future<Isar> provideIsarDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    await Isar.initializeIsarCore(download: true);
    return Isar.open(
      schemas,
      name: DatabaseConstants.databaseName,
      directory: directory.path,
    );
  }
}

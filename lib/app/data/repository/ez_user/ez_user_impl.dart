import 'package:firebase_database/firebase_database.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_user/ez_user.dart';
import 'package:ihostel/app/data/repository/ez_user/ez_user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

@LazySingleton(as: EzUserRepository)
class EzUserImpl extends EzUserRepository {
  EzUserImpl(Isar isar, FirebaseDatabase database) : super(isar, isar.ezUsers, database);

  @override
  Stream<EzUser> streamUserById(String id) {
    return isarCollection.filter().idEqualTo(id).watch(fireImmediately: true).map((event) => event.first);
  }

  @override
  EzUser? getById(String id) => isarCollection.where().isarIdEqualTo(id.fastHash()).findFirstSync();

  @override
  List<EzUser> get listLocal => isarCollection.where().findAllSync();

  @override
  EzUser fromJson(Map<String, dynamic> json) => EzUser.fromJson(json);
}

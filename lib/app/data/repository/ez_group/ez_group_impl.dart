import 'package:firebase_database/firebase_database.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/repository/ez_group/ez_group_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

@LazySingleton(as: EzGroupRepository)
class EzGroupImpl extends EzGroupRepository {
  EzGroupImpl(Isar isar, FirebaseDatabase database) : super(isar, isar.ezGroups, database);

  @override
  Stream<EzGroup> streamUserById(String id) {
    return isarCollection.filter().idEqualTo(id).watch(fireImmediately: true).map((event) => event.first);
  }

  @override
  EzGroup? getById(String id) => isarCollection.where().isarIdEqualTo(id.fastHash()).findFirstSync();

  @override
  List<EzGroup> get listLocal => isarCollection.where().findAllSync();

  @override
  EzGroup fromJson(Map<String, dynamic> json) => EzGroup.fromJson(json);
}

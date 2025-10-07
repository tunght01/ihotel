import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';

abstract class EzGroupRepository extends BaseRepository<EzGroup> {
  EzGroupRepository(super.isar, super.isarCollection, super.database);

  Stream<EzGroup> streamUserById(String id);
}

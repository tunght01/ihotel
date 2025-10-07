import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_user/ez_user.dart';

abstract class EzUserRepository extends BaseRepository<EzUser> {
  EzUserRepository(super.isar, super.isarCollection, super.database);

  Stream<EzUser> streamUserById(String id);
}

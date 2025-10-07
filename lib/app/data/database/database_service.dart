import 'package:ihostel/app/app.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

@LazySingleton()
class DatabaseService {
  const DatabaseService(
    this.localStorageDataSource,
  );

  final LocalStorageDataSource localStorageDataSource;

  @PostConstruct(preResolve: true)
  Future<void> initialize() async {}

  @PostConstruct(preResolve: true)
  Future<void> runMigration() async {
    const databaseVersion = DatabaseConstants.databaseVersion;
    final currentVersion = localStorageDataSource.storageVersion;
    if (currentVersion > 0 && currentVersion < databaseVersion) {
      // Add migration logic here if needed
    }
    if (currentVersion == 0 || currentVersion < databaseVersion) {
      await localStorageDataSource.setStorageVersion(databaseVersion);
    }
  }

  Future<void> migrateFromVersion1ToVersion2(Isar isar) async {
    // Add migration logic from version 1 to version 2 here if needed
  }
}

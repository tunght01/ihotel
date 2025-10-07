import 'package:collection/collection.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/repository/dark_mode/dark_mode_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DarkModeRepository)
class DarkModeImpl extends DarkModeRepository {
  DarkModeImpl(this.localStorageDataSource);

  final LocalStorageDataSource localStorageDataSource;

  @override
  AppThemeType getDarkMode() {
    final data = localStorageDataSource.darkMode;
    if (data.isEmpty) return AppThemeType.system;
    return AppThemeType.values.firstWhereOrNull((e) => e.name == data) ?? AppThemeType.system;
  }

  @override
  Future<void> setDarkMode(AppThemeType darkMode) async => localStorageDataSource.setDarkMode(darkMode.name);
}

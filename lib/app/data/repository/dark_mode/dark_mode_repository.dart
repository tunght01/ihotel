import 'package:ihostel/app/app.dart';

abstract class DarkModeRepository {
  AppThemeType getDarkMode();

  Future<void> setDarkMode(AppThemeType darkMode);
}

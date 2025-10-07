import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/repository/dark_mode/dark_mode_repository.dart';
import 'package:ihostel/app/data/repository/language/language_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppSettingsUseCase {
  const AppSettingsUseCase(this._languageRepository, this._darkModeRepository);

  final LanguageRepository _languageRepository;
  final DarkModeRepository _darkModeRepository;

  Future<void> setCurrentLanguage(String languageCode) async => _languageRepository.setCurrentLanguage(languageCode);

  String getCurrentLanguage() => _languageRepository.getCurrentLanguage();

  AppThemeType getDarkMode() => _darkModeRepository.getDarkMode();

  Future<void> setDarkMode(AppThemeType darkMode) async => _darkModeRepository.setDarkMode(darkMode);
}

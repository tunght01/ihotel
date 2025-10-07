abstract class LanguageRepository {
  String getCurrentLanguage();

  Future<void> setCurrentLanguage(String languageCode);

  String getLanguageName(String languageCode);
}

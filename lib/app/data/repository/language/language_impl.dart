import 'package:collection/collection.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/repository/language/language_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LanguageRepository)
class LanguageImpl extends LanguageRepository {
  LanguageImpl(this.localStorageDataSource);

  final LocalStorageDataSource localStorageDataSource;

  Map<String, String> get _mapperLanguageName => {
        'vi': 'Tiếng Việt',
        'en': 'English',
      };

  @override
  String getCurrentLanguage() {
    final currentLanguage = localStorageDataSource.languageCode;
    return (S.delegate.supportedLocales.firstWhereOrNull((e) => currentLanguage.contains(e.languageCode)) ?? S.delegate.supportedLocales.first).languageCode;
  }

  @override
  Future<void> setCurrentLanguage(String languageCode) async => localStorageDataSource.setLanguageCode(languageCode);

  @override
  String getLanguageName(String languageCode) => _mapperLanguageName[languageCode] ?? '';
}

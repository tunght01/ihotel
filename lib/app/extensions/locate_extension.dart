import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

extension LocateExtension on Locale {
  Map<String, EzLocate> get _mapLanguage => {
        'vi': EzLocate(countryCode: 'VND', languageName: 'Tiếng Việt', flagName: 'VN'),
        'en': EzLocate(countryCode: 'USD', languageName: 'English', flagName: 'US'),
      };

  String get languageName => (_mapLanguage[toLanguageTag()] ?? (_mapLanguage.values.first)).languageName;

  String get flagName => (_mapLanguage[toLanguageTag()] ?? (_mapLanguage.values.first)).flagName;

  String get countryCode => (_mapLanguage[toLanguageTag()] ?? (_mapLanguage.values.first)).countryCode;

  String get flagEmoji {
    try {
      final flag = flagName.trim().toUpperCase().split('').slice(0, 2).map((c) => c.codeUnitAt(0) + 127397).map(String.fromCharCode).join();
      return flag;
    } catch (e) {
      return '';
    }
  }
}

class EzLocate {
  EzLocate({
    this.countryCode = '',
    this.countryName = '',
    this.languageName = '',
    this.flagName = '',
  });

  String countryName;
  String countryCode;
  String languageName;
  String flagName;
}

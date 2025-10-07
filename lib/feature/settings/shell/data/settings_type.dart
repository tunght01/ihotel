import 'package:ihostel/assets_gen/assets.gen.dart';

enum SettingsType {
  language,
  darkMode,
  notification,
  security,
  support,
  termsOfUse,
  refreshData,
  version,
}

extension SettingsTypeExt on SettingsType {
  String get title => switch (this) {
        SettingsType.language => 'Ngôn ngữ',
        SettingsType.darkMode => 'Dark mode',
        SettingsType.notification => 'Thông báo',
        SettingsType.security => 'Bảo mật',
        SettingsType.support => 'Hỗ trợ kĩ thuật',
        SettingsType.termsOfUse => 'Điều khoản sử dụng',
        SettingsType.refreshData => 'Xoá dữ liệu, làm mới ứng dụng',
        SettingsType.version => 'Phiên bản',
      };

  SvgGenImage get icon => switch (this) {
        SettingsType.language => Assets.images.window,
        SettingsType.darkMode => Assets.images.support,
        SettingsType.notification => Assets.images.notifications,
        SettingsType.security => Assets.images.lock,
        SettingsType.support => Assets.images.support,
        SettingsType.termsOfUse => Assets.images.security,
        SettingsType.refreshData => Assets.images.deleteData,
        SettingsType.version => Assets.images.version,
      };

  bool get isVersion => this == SettingsType.version;

  bool get isLanguage => this == SettingsType.language;

  bool get isDarkMode => this == SettingsType.darkMode;

  bool get isSupport => this == SettingsType.support;

  bool get isTermsOfUse => this == SettingsType.termsOfUse;

  bool get isRefreshData => this == SettingsType.refreshData;

  bool get isNotification => this == SettingsType.notification;

  bool get isSecurity => this == SettingsType.security;
}

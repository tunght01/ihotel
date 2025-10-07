import 'dart:async';

import 'package:ihostel/app/app.dart';

enum Flavor { develop, staging, production }

class AppConstants {
  const AppConstants._();

  static const int defaultRetryAttempts = 3;
  static const int apiLimitSize = 100;
  static const String mongoDBFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";

  static const notificationCategoryIdentifier = 'com.default_category_identifier';
  static const notificationChanelId = 'high_importance_channel'; //k dc doi ten cai nay
  static const notificationChanelName = 'High Importance Notifications';

  static const notificationChanelDescription = 'This channel is used for important notifications.';
  static const notificationChanelDefaultId = 'default_importance_channel'; //k dc doi ten cai nay
  static const notificationChanelDefaultName = 'Default Importance Notifications';
  static const notificationChanelDefaultDescription = 'This channel is used for default important notifications.';

  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);
  static const sendTimeout = Duration(seconds: 30);

  static const flavorKey = 'FLAVOR';

  static Flavor flavor = Flavor.values.byName(const String.fromEnvironment(flavorKey, defaultValue: 'develop'));

  static String get appApiBaseUrl {
    switch (flavor) {
      case Flavor.develop:
        return 'https://test.com/api';
      case Flavor.staging:
        return 'https://test.com/api';
      case Flavor.production:
        return 'https://test.com/api';
    }
  }

  static FutureOr<void> init() async {
    Log.d(flavor, name: flavorKey);
    await getIt<AppInfo>().init();
  }
}

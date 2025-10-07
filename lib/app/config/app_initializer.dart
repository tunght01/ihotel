import 'dart:async';

import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/config/config.dart';
import 'package:ihostel/app/di/di.dart' as di;
import 'package:ihostel/firebase/firebase_options_development.dart' as dev_firebase;
import 'package:ihostel/firebase/firebase_options_production.dart' as prod_firebase;
import 'package:ihostel/firebase/firebase_options_staging.dart' as stg_firebase;

class AppInitializer {
  AppInitializer(this._applicationConfig);

  final AsyncMemoizer<void> _asyncMemoizer = AsyncMemoizer<void>();
  final Config _applicationConfig;

  Future<void> init() async {
    unawaited(_configFirebase());
    await _asyncMemoizer.runOnce(() => di.configureInjection(di.getIt));
    await AppConstants.init();
    await _applicationConfig.init();
  }

  Future<void> _configFirebase() async {
    switch (AppConstants.flavor) {
      case Flavor.production:
        await Firebase.initializeApp(options: prod_firebase.DefaultFirebaseOptions.currentPlatform);
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      case Flavor.develop:
        await Firebase.initializeApp(options: dev_firebase.DefaultFirebaseOptions.currentPlatform);
      case Flavor.staging:
        await Firebase.initializeApp(options: stg_firebase.DefaultFirebaseOptions.currentPlatform);
    }
  }
}

import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/config/app_config.dart';

void main() => runZonedGuarded(
      _runMyApp,
      _reportError,
      zoneSpecification: zoneSpecification,
    );

Future<void> _runMyApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer(AppConfig.getInstance()).init();
  runApp(const App());
}

void _reportError(Object error, StackTrace stackTrace) {
  Log.e(error, stackTrace: stackTrace, name: 'Uncaught exception');
  if (AppConstants.flavor == Flavor.production) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}

ZoneSpecification get zoneSpecification => ZoneSpecification(
      print: (self, parent, zone, line) {
        if (kDebugMode) {
          parent.print(zone, line);
        }
      },
    );

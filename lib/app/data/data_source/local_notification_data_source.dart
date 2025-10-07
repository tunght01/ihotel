import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_notification/ez_local_push_notification.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@lazySingleton
class LocalNotificationDataSource {
  LocalNotificationDataSource();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final _notificationStream = BehaviorSubject<EzReceivedNotification>();

  Stream<EzReceivedNotification> get notificationStream => _notificationStream.stream.asBroadcastStream();

  Future<void> checkPendingNotificationRequests() async {
    final pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (final pendingNotificationRequest in pendingNotificationRequests) {
      Log.d("pending id : ${pendingNotificationRequest.id} ${pendingNotificationRequest.payload ?? ""}");
    }
  }

  Future<void> checkActiveNotification() async {
    final pendingNotificationRequests = await flutterLocalNotificationsPlugin.getActiveNotifications();

    for (final pendingNotificationRequest in pendingNotificationRequests) {
      Log.d("active id : ${pendingNotificationRequest.id} ${pendingNotificationRequest.payload ?? ""}");
    }
  }

  Future<List<PendingNotificationRequest>> getAllNotificationPending() {
    return flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> cancelAllNotificationPending() async {
    final pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (final pendingNotificationRequest in pendingNotificationRequests) {
      Log.d("id : ${pendingNotificationRequest.id} ${pendingNotificationRequest.payload ?? ""}");
      await flutterLocalNotificationsPlugin.cancel(pendingNotificationRequest.id);
    }
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @PostConstruct(preResolve: true)
  Future<void> initPushNotificationLocal() async {
    const kIsWeb = bool.fromEnvironment('dart.library.js_util');
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }
}

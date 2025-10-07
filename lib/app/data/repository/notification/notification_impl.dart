import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_notification/ez_local_push_notification.dart';
import 'package:ihostel/app/data/models/ez_notification/payload_model.dart';
import 'package:ihostel/app/data/repository/notification/notification_repository.dart';
import 'package:ihostel/feature/navigation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

@LazySingleton(as: NotificationRepository)
class NotificationImpl extends NotificationRepository {
  NotificationImpl(super.remoteNotificationDataSource, super.localNotificationDataSource) {
    remoteNotificationDataSource.notificationStream.listen(_notificationStream.add);
    localNotificationDataSource.notificationStream.listen(_notificationStream.add);
  }

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final _notificationTapEvent = BehaviorSubject<PayloadModel>();

  @override
  Stream<PayloadModel> get notificationTapEvent => _notificationTapEvent.stream.asBroadcastStream();

  final _notificationStream = BehaviorSubject<EzReceivedNotification>();

  @override
  Stream<EzReceivedNotification> get notificationStream => _notificationStream.stream.asBroadcastStream();

  int notificationId = 0;

  NotificationDetails get _notificationDetailsSlightly => const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChanelDefaultId, // id
          AppConstants.notificationChanelDefaultName, // id
          channelDescription: AppConstants.notificationChanelDefaultDescription,
          importance: Importance.max,
          priority: Priority.max,
          icon: 'ic_notification',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
        ),
      );

  NotificationDetails get _notificationDetailsSound => const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChanelId,
          AppConstants.notificationChanelName,
          channelDescription: AppConstants.notificationChanelDescription,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

  @PostConstruct(preResolve: true)
  Future<void> initNotification() async {
    await _createNotificationChanel();
    await _initSettingsNotification();
  }

  Future<void> _createNotificationChanel() async {
    const channel = AndroidNotificationChannel(
      AppConstants.notificationChanelId,
      AppConstants.notificationChanelName,
      description: AppConstants.notificationChanelDescription,
      importance: Importance.max,
    );

    //notification chanel no have sound
    const channelNonSound = AndroidNotificationChannel(
      AppConstants.notificationChanelDefaultId,
      AppConstants.notificationChanelDefaultName,
      description: AppConstants.notificationChanelDefaultDescription,
      playSound: false,
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channelNonSound);
  }

  Future<void> _initSettingsNotification() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');

    final initializationSettingsDarwin = DarwinInitializationSettings(
      notificationCategories: [
        const DarwinNotificationCategory(AppConstants.notificationCategoryIdentifier),
      ],
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        _notificationStream.add(
          EzReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
            type: null,
          ),
        );
      },
    );
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _notificationTapForeground,
      // onDidReceiveBackgroundNotificationResponse: ondDidReceiveLocalNotification,
    );
  }

  /// show notification slightly
  @override
  void showNotification(EzReceivedNotification notification) {
    try {
      final messageBody = notification.body ?? 'Thông báo';
      flutterLocalNotificationsPlugin.show(
        getRandomNotificationId(),
        notification.title,
        messageBody,
        _notificationDetailsSlightly,
        payload: notification.payload,
      );
    } catch (e) {
      flutterLocalNotificationsPlugin.show(
        getRandomNotificationId(),
        notification.title,
        notification.body,
        _notificationDetailsSlightly,
        payload: notification.payload,
      );
    }
  }

  @override
  int getRandomNotificationId() {
    return ++notificationId;
  }

  @override
  Future<void> notificationZonedSchedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    required String? payloadJson,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      _notificationDetailsSound,
      androidScheduleMode: Platform.isIOS ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payloadJson,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  @override
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final value = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;
      return value;
    } else if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.requestNotificationsPermission() ?? false;
    }
    return false;
  }

  @override
  Future<void> requestExactPermissions() async {
    final androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final canScheduleExact = await androidImplementation?.canScheduleExactNotifications() ?? false;
    if (canScheduleExact == true) {
      return Future.value();
    } else if (rootNavigatorKey.currentContext != null) {
      await showAlert(
        rootNavigatorKey.currentContext!,
        title: 'Exact alarm',
        content: 'exact alarm request warning',
        actions: ['Ok', 'Cancel'],
        onActionButtonTapped: (index) async {
          if (index == 0) {
            await androidImplementation?.requestExactAlarmsPermission();
          } else {
            return Future.value();
          }
        },
      );
    }
  }

  @override
  Future<void> cancelAllPushNotifications() async {
    await localNotificationDataSource.cancelAllNotificationPending();
    notificationId = 0;
  }

  @override
  Future<void> cancelFutureNotificationsPending() async {
    final pendingNotificationRequests = await localNotificationDataSource.getAllNotificationPending();

    for (final pendingNotificationRequest in pendingNotificationRequests) {
      final data = json.decode(pendingNotificationRequest.payload ?? '') as Map<String, dynamic>?;
      if (data != null) {
        try {
          final payload = PayloadModel.fromJson(data);
          if (!payload.getTimeLocal.isAfter(DateTime.now())) {
            continue;
          }
        } catch (_) {
          // Cancel all pending notification with non-valid payload
        }
      }
      await flutterLocalNotificationsPlugin.cancel(pendingNotificationRequest.id);
    }
  }

  /// init notification when open app
  @override
  Future<void> setupInteractedMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handlePayload(initialMessage.data);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((initialMessage) => _handlePayload(initialMessage.data));
  }

  void _notificationTapForeground(NotificationResponse notificationResponse) {
    try {
      final data = json.decode(notificationResponse.payload ?? '') as Map<String, dynamic>?;
      _handlePayload(data);
    } catch (e) {
      Log.d(e, name: 'NOTIFICATION_TAP');
    }
  }

  void _handlePayload(Map<String, dynamic>? data) {
    if (data == null) return;
    final payload = PayloadModel.fromJson(data);
    _notificationTapEvent.add(payload);
  }

// @pragma('vm:entry-point')
// static Future<void> ondDidReceiveLocalNotification(NotificationResponse notificationResponse) async {
//   try {
//     final data = json.decode(notificationResponse.payload ?? '') as Map<String, dynamic>?;
//     if (data == null) return;
//     final payload = PayloadModel.fromJson(data);
//     _notificationTapEvent.add(payload);
//   } catch (e) {
//     Log.d(e, name: 'NOTIFICATION_TAP');
//   }
// }
}

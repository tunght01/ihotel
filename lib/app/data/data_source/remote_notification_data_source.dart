import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_notification/ez_local_push_notification.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class RemoteNotificationDataSource {
  RemoteNotificationDataSource(this._localStorageDataSource);

  final LocalStorageDataSource _localStorageDataSource;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final _notificationStream = BehaviorSubject<EzReceivedNotification>();

  Stream<EzReceivedNotification> get notificationStream => _notificationStream.stream.asBroadcastStream();

  @PostConstruct(preResolve: true)
  Future<void> initFirebaseMessaging() async {
    try {
      await _initTokenFcm();
      FirebaseMessaging.onMessage.listen(_handleRemoteNotification);
      FirebaseMessaging.instance.onTokenRefresh.listen(_updateTokenFcm);
    } catch (e) {
      Log.d(e);
    }
  }

  Future<void> _initTokenFcm() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    Log.d(fcmToken, name: 'INIT_FCM_TOKEN');
    if ((fcmToken ?? '').isNotEmpty) {
      await _localStorageDataSource.setFcmToken(fcmToken ?? '');
    }
  }

  Future<void> _updateTokenFcm(String? token) async {
    final tokenNew = token ?? '';
    Log.d(tokenNew, name: 'UPDATE_FCM_TOKEN');
    if (tokenNew.isNotEmpty) {
      await _localStorageDataSource.setFcmToken(tokenNew);
    }
  }

  void _handleRemoteNotification(RemoteMessage remoteMessage) {
    final title = remoteMessage.notification?.title ?? '';
    final msg = remoteMessage.notification?.body ?? '';
    Log.d('title: $title msg:  $msg', name: 'CONTEXT_FCM');
    Log.d(remoteMessage.notification?.toMap(), name: 'NOTIFICATION');
    final notification = EzReceivedNotification(
      id: 0,
      title: remoteMessage.notification?.title,
      body: remoteMessage.notification?.body,
      payload: jsonEncode(remoteMessage.data),
      type: remoteMessage.data['type'] as String?,
      requestedUser: remoteMessage.data['requested_user'] as String?,
      groupId: remoteMessage.data['groupId'] as String?,
      roomId: remoteMessage.data['roomId'] as String?,
    );
    _notificationStream.add(notification);
  }
}

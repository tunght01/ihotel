import 'package:ihostel/app/data/data_source/local_notification_data_source.dart';
import 'package:ihostel/app/data/data_source/remote_notification_data_source.dart';
import 'package:ihostel/app/data/models/ez_notification/ez_local_push_notification.dart';
import 'package:ihostel/app/data/models/ez_notification/payload_model.dart';

abstract class NotificationRepository {
  NotificationRepository(
    this.remoteNotificationDataSource,
    this.localNotificationDataSource,
  );

  final RemoteNotificationDataSource remoteNotificationDataSource;
  final LocalNotificationDataSource localNotificationDataSource;

  Stream<EzReceivedNotification> get notificationStream;

  Stream<PayloadModel> get notificationTapEvent;

  Future<bool> requestPermissions();

  Future<void> requestExactPermissions();

  void showNotification(EzReceivedNotification notification);

  Future<void> setupInteractedMessage();

  Future<void> notificationZonedSchedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    required String? payloadJson,
  });

  int getRandomNotificationId();

  Future<void> cancelFutureNotificationsPending();

  Future<void> cancelAllPushNotifications();
}

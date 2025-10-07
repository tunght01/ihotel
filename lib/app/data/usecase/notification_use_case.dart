import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';
import 'package:ihostel/app/data/repository/ez_group_room/ez_group_room_repository.dart';
import 'package:ihostel/app/data/repository/ez_group_room_user/ez_group_room_user_repository.dart';
import 'package:ihostel/app/data/repository/notification/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationUseCase {
  NotificationUseCase(
    this._notificationRepository,
    this._ezGroupRoomRepository,
    this._localStorageDataSource,
    this._ezGroupRoomUserRepository,
  );

  final NotificationRepository _notificationRepository;
  final EzGroupRoomRepository _ezGroupRoomRepository;
  final EzGroupRoomUserRepository _ezGroupRoomUserRepository;
  final LocalStorageDataSource _localStorageDataSource;
  var _isUpdating = false;
  var _needToRunAgain = false;

  Future<void> schedulePaymentNotifications() async {
    if (!_isUpdating) {
      _isUpdating = true;
      await _notificationRepository.cancelFutureNotificationsPending();
      if (!_localStorageDataSource.notificationEnabled) {
        await _notificationRepository.cancelAllPushNotifications();
        return;
      }

      await _scheduleMonthlyNotification();
      _isUpdating = false;
      if (_needToRunAgain) {
        _needToRunAgain = false;
        await schedulePaymentNotifications();
      }
    } else {
      _needToRunAgain = true;
    }
  }

  Future<void> _scheduleMonthlyNotification() async {
    final rooms = await getAllDateExpire();
    rooms.sortBy((e) => e.getCreated);

    /// iOS limits to 64 schedule notifications only
    /// Samsung limit to 500 alarms
    /// Android
    final maxItems = Platform.isIOS ? 64 : 100;
    final numberMin = min(maxItems, rooms.length);

    for (var i = 0; i < numberMin; i++) {
      final item = rooms[i];
      final id = _notificationRepository.getRandomNotificationId();
      final date = item.startDate;
      final scheduledTime = schedulePushNotificationDay(date);
      await _notificationRepository.notificationZonedSchedule(
        id: id,
        body: '${item.name} đến hạn đóng tiền phòng rồi. Vui lòng thanh toán!',
        payloadJson: '{"type": "expired"}',
        time: scheduledTime,
        title: 'Đóng tiền trọ',
      );
      Log.d('Schedule notification "${item.name}" at $scheduledTime with id=$id');
    }
  }

  DateTime schedulePushNotificationDay(int day) {
    final now = DateTime.now();
    return now.copyWith(minute: now.minute + 1);
    final scheduledDate = now.copyWith(day: day, hour: 8);
    return scheduledDate.isBefore(now) ? scheduledDate.copyWith(month: now.month + 1) : scheduledDate;
  }

  Future<List<EzGroupRoomUser>> getAllRoomIdUseLinkUserId() async {
    final listRoomUser = _ezGroupRoomUserRepository.getAllRoomUseByLinkUserId(_localStorageDataSource.userId);
    return listRoomUser;
  }

  Future<List<EzGroupRoom>> getAllDateExpire() async {
    final roomUserIds = await getAllRoomIdUseLinkUserId();
    final list = roomUserIds.map((e) => _ezGroupRoomRepository.getById(e.groupRoomId)).whereNotNull().toList();
    return list;
  }
}

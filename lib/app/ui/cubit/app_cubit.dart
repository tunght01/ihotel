import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_notification/ez_local_push_notification.dart';
import 'package:ihostel/app/data/models/ez_notification/payload_model.dart';
import 'package:ihostel/app/data/repository/notification/notification_repository.dart';
import 'package:ihostel/app/data/usecase/app_settings_use_case.dart';
import 'package:ihostel/app/data/usecase/sync_use_case.dart';
import 'package:ihostel/feature/navigation.dart';
import 'package:injectable/injectable.dart';

part 'app_cubit.freezed.dart';

@freezed
sealed class AppState extends BaseCubitState with _$AppState {
  const factory AppState({
    @Default(AppThemeType.system) AppThemeType darkMode,
    @Default(Locale('vi')) Locale locate,
    @Default(AppColors.primaryCommon) Color appColor,
  }) = _AppState;
}

@LazySingleton()
class AppCubit extends BaseCubit<AppState> {
  AppCubit(
    this.localStorageDataSource,
    this._appSettingsUseCase,
    this._notificationRepository,
    this._syncUseCase,
  ) : super(const AppState()) {
    _init();
  }

  final LocalStorageDataSource localStorageDataSource;
  final AppSettingsUseCase _appSettingsUseCase;
  final NotificationRepository _notificationRepository;
  final SyncUseCase _syncUseCase;
  late final StreamSubscription<EzReceivedNotification> _notificationStreamSubscription;
  late final StreamSubscription<PayloadModel?> _notificationTapStreamSubscription;

  Future<void> _init() async {
    final darkMode = _appSettingsUseCase.getDarkMode();
    AppThemeSetting.currentAppThemeType = darkMode.isDarkMode ? AppThemeType.dark : AppThemeType.light;
    emit(state.copyWith(darkMode: darkMode));
    _updateAppLanguage(_appSettingsUseCase.getCurrentLanguage());
  }

  Future<void> setupInteractedMessage() async {
    await _notificationRepository.setupInteractedMessage();
    _notificationStreamSubscription = _notificationRepository.notificationStream.listen(_handleNotificationReceived);
    _notificationTapStreamSubscription = _notificationRepository.notificationTapEvent.listen(_handleNotificationTapEvent);
  }

  Future<void> _handleNotificationReceived(EzReceivedNotification notification) async {
    switch (notification.type) {
      case EzReceivedNotification.typeExpired:
        _notificationRepository.showNotification(notification);
      case EzReceivedNotification.typeSync:
        _syncUseCase.syncAll();
    }
    //
    // /// sẽ xóa đi này chỉ là demo
    // final eventDate = DateTime.now().add(const Duration(milliseconds: 5000));
    // await _notificationRepository.notificationZonedSchedule(
    //   id: 1,
    //   body: 'Đến hạn đóng tiền nhà rồi. Thanh toán ngay nào!',
    //   payloadJson: '{"type": "expired"}',
    //   time: eventDate,
    //   title: 'Đóng tiền trọ',
    // );
  }

  Future<void> _handleNotificationTapEvent(PayloadModel? payload) async {
    if (payload == null) return;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final context = rootNavigatorKey.currentContext;
      switch (payload.type) {
        case EzReceivedNotification.typeExpired:
          await MemberInfoRoute().pushOnLy<void>(context);
        default:
          break;
      }
    });
  }

  Future<void> setCurrentLanguage(String languageCode) async {
    await _appSettingsUseCase.setCurrentLanguage(languageCode);
    _updateAppLanguage(languageCode);
  }

  Future<void> setDarkMode(AppThemeType darkMode) async {
    await _appSettingsUseCase.setDarkMode(darkMode);
    AppThemeSetting.currentAppThemeType = darkMode.isDarkMode ? AppThemeType.dark : AppThemeType.light;
    emit(state.copyWith(darkMode: darkMode));
  }

  void _updateAppLanguage(String languageCode) {
    final locate = _parseLocale(languageCode);
    emit(state.copyWith(locate: locate));
  }

  Locale _parseLocale(String languageCode) {
    try {
      final parts = languageCode.split('-');
      if (parts.length >= 2) {
        return Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]);
      }
      return Locale(parts[0]);
    } catch (_) {
      return S.delegate.supportedLocales.first;
    }
  }

  @override
  Future<void> close() {
    _notificationStreamSubscription.cancel();
    _notificationTapStreamSubscription.cancel();
    return super.close();
  }
}

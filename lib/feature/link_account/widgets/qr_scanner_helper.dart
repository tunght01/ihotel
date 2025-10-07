import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

class QrScannerHelper {
  static final _player = AudioPlayer();

  static Future<void> notifyScanSuccess() async {
    await _player.play(AssetSource(Assets.audio.beepQr), volume: 0.5);
    final isVibration = await Vibration.hasVibrator();
    if (isVibration ?? false) {
      await Vibration.vibrate(amplitude: 255, duration: 150);
    }
  }

  static Future<bool> requestPermissionCamera([BuildContext? context, bool request = true]) async {
    final status = await Permission.camera.status;
    if (status.isDenied && request) {
      final statuses = await Permission.camera.request();
      return statuses.isGranted;
    } else if (status.isPermanentlyDenied) {
      if (context != null && context.mounted) {
        await showAlert(
          context,
          content: 'Bạn chưa cung cấp quyền để mở máy ảnh. Vui lòng đi đến cài đặt để thêm quyền.',
          title: 'Cảnh báo',
          actions: ['Đi tới cài đặt', 'Hủy'],
          onActionButtonTapped: (index) {
            if (index == 0) {
              openAppSettings();
            }
          },
        );
      }
      return false;
    }
    return status.isGranted;
  }
}

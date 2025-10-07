import 'package:flutter/material.dart';

enum HomeType {
  export,
  notification,
  cloud,
}

extension HomeTypeExtension on HomeType {
  IconData get icon {
    switch (this) {
      case HomeType.export:
        return Icons.file_upload_outlined;
      case HomeType.notification:
        return Icons.notifications_outlined;
      case HomeType.cloud:
        return Icons.cloud_outlined;
    }
  }

  bool get isExport => this == HomeType.export;

  bool get isNotification => this == HomeType.notification;

  bool get isCloud => this == HomeType.cloud;
}

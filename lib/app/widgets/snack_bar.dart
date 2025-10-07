import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:ihostel/app/app.dart';

class EzFlushbar {
  const EzFlushbar._();

  static Future<T?> show<T>(
    BuildContext context, {
    required String message,
    String? title,
    void Function(FlushbarStatus?)? onStatusChanged,
    bool isError = false,
    Duration duration = const Duration(milliseconds: 1000),
  }) async {
    return Flushbar<T>(
      backgroundColor: isError ? AppColors.current.error : AppColors.current.success,
      padding: const EdgeInsets.all(Dimens.d10),
      margin: const EdgeInsets.symmetric(horizontal: Dimens.d10),
      borderRadius: BorderRadius.circular(Dimens.d15),
      title: title ?? 'Thông báo',
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      onStatusChanged: onStatusChanged,

    ).show(context);
  }

  static Future<T?> showError<T>(
    BuildContext context, {
    required String message,
    String? title,
    void Function(FlushbarStatus?)? onStatusChanged,
    Duration duration = const Duration(milliseconds: 1000),
  }) async {
    return Flushbar<T>(
      backgroundColor: AppColors.current.error,
      padding: const EdgeInsets.all(Dimens.d10),
      margin: const EdgeInsets.symmetric(horizontal: Dimens.d10),
      borderRadius: BorderRadius.circular(Dimens.d15),
      title: title ?? 'Cảnh báo',
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      onStatusChanged: onStatusChanged,
    ).show(context);
  }

  static Future<T?> showWarning<T>(
    BuildContext context, {
    required String message,
    String? title,
    void Function(FlushbarStatus?)? onStatusChanged,
    Duration duration = const Duration(milliseconds: 1000),
  }) async {
    return Flushbar<T>(
      backgroundColor: AppColors.current.warning,
      padding: const EdgeInsets.all(Dimens.d10),
      margin: const EdgeInsets.symmetric(horizontal: Dimens.d10),
      borderRadius: BorderRadius.circular(Dimens.d15),
      title: title ?? 'Lưu ý',
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      onStatusChanged: onStatusChanged,
    ).show(context);
  }
}

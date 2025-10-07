import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';

enum _PillType { error, warning, success, disabled, information }

class EzPill extends StatelessWidget {
  const EzPill.error({
    required this.title,
    super.key,
    this.onPressed,
  }) : _pillType = _PillType.error;

  const EzPill.warning({
    required this.title,
    super.key,
    this.onPressed,
  }) : _pillType = _PillType.warning;

  const EzPill.success({
    required this.title,
    super.key,
    this.onPressed,
  }) : _pillType = _PillType.success;

  const EzPill.disabled({
    required this.title,
    super.key,
    this.onPressed,
  }) : _pillType = _PillType.disabled;

  const EzPill.information({
    required this.title,
    super.key,
    this.onPressed,
  }) : _pillType = _PillType.information;

  final VoidCallback? onPressed;
  final String title;
  final _PillType _pillType;

  @override
  Widget build(BuildContext context) {
    final pillColor = switch (_pillType) {
      _PillType.error => AppColors.current.error,
      _PillType.warning => AppColors.current.warning,
      _PillType.success => AppColors.current.success,
      _PillType.disabled => AppColors.current.disabledText,
      _PillType.information => AppColors.current.primary,
    };

    return EzRippleEffect(
      onPressed: onPressed,
      color: pillColor,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(title, style: EzTextStyles.s10White),
      ),
    );
  }
}

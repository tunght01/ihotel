import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';

class SyncIcon extends StatefulWidget {
  const SyncIcon({this.onPressed, super.key, this.icon, this.isNotify = false});

  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isNotify;

  @override
  State<SyncIcon> createState() => _SyncIconState();
}

class _SyncIconState extends State<SyncIcon> {
  @override
  Widget build(BuildContext context) {
    return EzIconButton(
      borderRadius: BorderRadius.circular(Dimens.d16),
      onPressed: widget.onPressed,
      child: Stack(
        children: [
          Icon(
            widget.icon ?? Icons.cloud_outlined,
            color: AppColors.current.primaryText,
          ),
          if (widget.isNotify)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: Dimens.d10,
                height: Dimens.d10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.current.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EzRadio extends StatelessWidget {
  const EzRadio({
    this.onTap,
    this.isSelected = false,
    this.scale = 1,
    this.enabled = true,
    super.key,
  });

  final bool isSelected;
  final void Function(bool)? onTap;
  final double scale;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Radio(
        value: isSelected,
        groupValue: true,
        onChanged: (bool? value) => onTap?.call(value ?? false),
      ),
    );
  }
}

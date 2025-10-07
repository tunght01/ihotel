import 'package:flutter/material.dart';

class EzSwitch extends StatelessWidget {
  const EzSwitch({
    this.onSwitch,
    this.isSelected = false,
    this.enabled = true,
    this.scale = 0.7,
    super.key,
  });

  final bool isSelected;
  final bool enabled;
  final double scale;
  final void Function(bool)? onSwitch;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 8, maxWidth: 40),
      child: Transform.scale(
        scale: scale,
        child: Switch(
          value: isSelected,
          onChanged: (bool? value) => enabled ? onSwitch?.call(isSelected) : null,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EzCheckBox extends StatelessWidget {
  const EzCheckBox({
    required this.onTap,
    this.isSelected = false,
    this.scale = 1,
    super.key,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Checkbox(
        value: isSelected,
        onChanged: (b) => onTap.call,
      ),
    );
  }
}

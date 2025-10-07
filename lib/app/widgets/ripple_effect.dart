import 'package:flutter/material.dart';

class EzRippleEffect extends StatelessWidget {
  const EzRippleEffect({
    required this.child,
    this.borderRadius,
    this.onPressed,
    this.color,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onPressed,
        child: child,
      ),
    );
  }
}

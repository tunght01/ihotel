import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';

class EzCard extends StatelessWidget {
  const EzCard({
    super.key,
    this.child,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.color,
    this.onDelete,
    this.borderRadius,
  });

  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? color;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return EzRippleEffect(
      onPressed: onTap,
      color: color ?? AppColors.current.backgroundTextField,
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDelete != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: Dimens.d4, horizontal: Dimens.d6),
                      decoration: BoxDecoration(
                        color: AppColors.current.error,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(Dimens.d10),
                          bottomLeft: Radius.circular(Dimens.d10),
                        ),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            if (child != null)
              Padding(
                padding: padding ??
                    const EdgeInsets.symmetric(
                      vertical: Dimens.d12,
                      horizontal: Dimens.d16,
                    ),
                child: child,
              ),
          ],
        ),
      ),
    );
  }
}

class EzCardSliver extends StatelessWidget {
  const EzCardSliver({
    this.color,
    this.child,
    super.key,
  });

  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color ?? AppColors.current.backgroundTextField,
      child: child,
    );
  }
}

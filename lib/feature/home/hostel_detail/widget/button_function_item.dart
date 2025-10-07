import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';

class ButtonFunctionItem extends StatelessWidget {
  const ButtonFunctionItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.size = 56,
    super.key,
  });

  final SvgGenImage icon;
  final String title;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return EzRippleEffect(
      onPressed: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.current.primaryGradient,
            ),
            child: Center(
              child: icon.svg(
                width: Dimens.d24,
                height: Dimens.d24,
              ),
            ),
          ),
          Dimens.d6.verticalSpace,
          Text(
            title,
            style: EzTextStyles.s12.secondary.w400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

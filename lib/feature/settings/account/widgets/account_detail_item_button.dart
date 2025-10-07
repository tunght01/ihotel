import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';

class AccountDetailItemButton extends StatelessWidget {
  const AccountDetailItemButton({
    required this.icon,
    required this.title,
    required this.onPressed,
    required this.trailingIcon,
    required this.content,
    super.key,
  });

  final SvgGenImage icon;
  final String title;
  final Widget content;
  final VoidCallback onPressed;
  final Widget trailingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          icon.svg(
            width: Dimens.d44,
            height: Dimens.d44,
          ),
          Dimens.d20.horizontalSpace,
          Expanded(
            child: Text(
              title,
              style: EzTextStyles.s14.w500.primary,
            ),
          ),
          content,
          Dimens.d20.horizontalSpace,
          trailingIcon,
        ],
      ),
    );
  }
}

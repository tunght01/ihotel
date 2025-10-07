import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';

class ItemSettingButton extends StatelessWidget {
  const ItemSettingButton({
    required this.icon,
    required this.title,
    this.content = '',
    this.onPressed,
    this.onSwitch,
    this.isSelected = false,
    super.key,
  });

  final SvgGenImage icon;
  final String title;
  final String content;
  final VoidCallback? onPressed;
  final void Function(bool)? onSwitch;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSwitch != null ? () => onSwitch?.call(isSelected) : onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.d10),
        child: Row(
          children: [
            icon.svg(),
            Dimens.d20.horizontalSpace,
            Expanded(child: Text(title, style: EzTextStyles.s14.primary)),
            if (content.isNotEmpty) Expanded(child: Text(content, style: EzTextStyles.s14.primary, textAlign: TextAlign.right)),
            if (onSwitch != null) ...[
              Dimens.d20.horizontalSpace,
              EzSwitch(onSwitch: onSwitch),
            ],
            if (onPressed != null) ...[
              Dimens.d20.horizontalSpace,
              Assets.images.arrowRight.svg(
                width: Dimens.d20,
                height: Dimens.d20,
                color: AppColors.current.primaryText,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

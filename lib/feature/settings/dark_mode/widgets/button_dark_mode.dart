import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';

class ButtonDarkMode extends StatelessWidget {
  const ButtonDarkMode({
    required this.title,
    this.onPressed,
    this.isSelected = false,
    super.key,
  });

  final String title;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return EzRippleEffect(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.d12, horizontal: Dimens.d20),
        child: Row(
          children: [
            Expanded(child: Text(title, style: EzTextStyles.s11.primary)),
            Container(
              width: Dimens.d16,
              height: Dimens.d16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.current.primary : AppColors.current.disabled,
              ),
              child: Icon(
                Icons.check,
                size: Dimens.d8,
                color: isSelected ? const Color(0xFFF8F8F8) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

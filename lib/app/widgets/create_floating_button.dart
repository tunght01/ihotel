import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/shared/shared.dart';

class CreateFloatingButton extends StatefulWidget {
  const CreateFloatingButton({
    required this.iconLeft,
    required this.iconRight,
    super.key,
    this.onTabRight,
    this.onTabLeft,
    this.onDoubleTapLeft,
    this.onLongPressLeft,
    this.titleLeft = '',
    this.titleRight = '',
  });

  final VoidCallback? onTabRight;
  final VoidCallback? onTabLeft;
  final VoidCallback? onDoubleTapLeft;
  final VoidCallback? onLongPressLeft;
  final IconData iconLeft;
  final IconData iconRight;
  final String titleLeft;
  final String titleRight;

  @override
  State<CreateFloatingButton> createState() => _CreateFloatingButtonState();
}

class _CreateFloatingButtonState extends State<CreateFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: Dimens.paddingDefault),
      padding: const EdgeInsets.only(bottom: Dimens.d20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              EzFloatingButton(
                icon: widget.iconLeft,
                onSingleTap: widget.onTabLeft,
              ),
              const SizedBox(
                height: Dimens.d5,
              ),
              Container(
                alignment: Alignment.center,
                width: 66,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Text(
                    widget.titleLeft,
                    style: EzTextStyles.s10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              EzFloatingButton(
                icon: widget.iconRight,
                onSingleTap: widget.onTabRight,
              ),
              const SizedBox(
                height: Dimens.d5,
              ),
              Container(
                alignment: Alignment.center,
                width: 66,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Text(
                    widget.titleRight,
                    style: EzTextStyles.s10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EzFloatingButton extends StatelessWidget {
  const EzFloatingButton({
    required this.icon,
    this.onSingleTap,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onSingleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSingleTap,
      child: Container(
        alignment: Alignment.center,
        height: 54,
        width: 55,
        decoration: BoxDecoration(
          color: AppColors.lightTheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Container(
          alignment: Alignment.center,
          height: 47,
          width: 47,
          decoration: BoxDecoration(
            color: AppColors.lightTheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

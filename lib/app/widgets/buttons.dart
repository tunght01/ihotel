import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';

enum _ButtonKind {
  primaryFilled,
  primaryOutline,
  primaryText,
  secondaryText,
  errorText,
  custom,
}

class EzButton extends StatelessWidget {
  const EzButton.primaryOutline({
    required this.title,
    this.isEnabled = false,
    this.textStyle,
    super.key,
    this.onPressed,
  })  : _buttonKind = _ButtonKind.primaryOutline,
        child = null;

  const EzButton.primaryFilled({
    required this.title,
    this.isEnabled = false,
    this.textStyle,
    super.key,
    this.onPressed,
  })  : _buttonKind = _ButtonKind.primaryFilled,
        child = null;

  const EzButton.primaryText({
    required this.title,
    this.isEnabled = false,
    this.textStyle,
    super.key,
    this.onPressed,
  })  : _buttonKind = _ButtonKind.primaryText,
        child = null;

  const EzButton.secondaryText({
    required this.title,
    this.isEnabled = false,
    this.textStyle,
    super.key,
    this.onPressed,
  })  : _buttonKind = _ButtonKind.secondaryText,
        child = null;

  const EzButton.errorText({
    required this.title,
    this.isEnabled = false,
    this.textStyle,
    super.key,
    this.onPressed,
  })  : _buttonKind = _ButtonKind.errorText,
        child = null;

  const EzButton.custom({
    required this.child,
    this.isEnabled = false,
    this.textStyle,
    super.key,
    this.onPressed,
  })  : _buttonKind = _ButtonKind.custom,
        title = '';

  final VoidCallback? onPressed;
  final String title;
  final Widget? child;
  final _ButtonKind _buttonKind;
  final bool isEnabled;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return switch (_buttonKind) {
      _ButtonKind.primaryOutline => OutlinedButton(
          style: _styleButton,
          onPressed: isEnabled ? onPressed : null,
          child: Text(title, style: textStyle),
        ),
      _ButtonKind.primaryFilled => FilledButton(
          style: _styleButton,
          onPressed: isEnabled ? onPressed : null,
          child: Text(title, style: textStyle),
        ),
      _ButtonKind.primaryText => TextButton(
          style: _styleButton,
          onPressed: isEnabled ? onPressed : null,
          child: Text(title, textAlign: TextAlign.center, style: textStyle),
        ),
      _ButtonKind.secondaryText => TextButton(
          style: _styleButton.copyWith(
            foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary),
          ),
          onPressed: isEnabled ? onPressed : null,
          child: Text(title, textAlign: TextAlign.center, style: textStyle),
        ),
      _ButtonKind.errorText => TextButton(
          style: _styleButton.copyWith(
            foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.error),
          ),
          onPressed: isEnabled ? onPressed : null,
          child: Text(title, textAlign: TextAlign.center, style: textStyle),
        ),
      _ButtonKind.custom => FilledButton(
          onPressed: isEnabled ? onPressed : null,
          child: child,
        ),
    };
  }

  ButtonStyle get _styleButton => const ButtonStyle(
        fixedSize: MaterialStatePropertyAll(Size.fromHeight(52)),
      );
}

class ListTileButton extends StatelessWidget {
  const ListTileButton({
    required this.title,
    required this.icon,
    this.isEnabled = true,
    super.key,
    this.onPressed,
  });

  const ListTileButton.svg({
    required this.title,
    required this.icon,
    this.onPressed,
    this.isEnabled = true,
    super.key,
  });

  final String title;
  final Widget icon;
  final bool isEnabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Dimens.d12.horizontalSpace,
          Text(title, style: EzTextStyles.titlePrimary),
        ],
      ),
    );
  }
}

class EzIconButton extends StatelessWidget {
  EzIconButton({
    required this.child,
    this.onPressed,
    BorderRadius? borderRadius,
    this.padding = Dimens.d8,
    super.key,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(Dimens.d16);

  final VoidCallback? onPressed;
  final Widget child;
  final BorderRadius? borderRadius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        ),
      ),
    );
  }
}

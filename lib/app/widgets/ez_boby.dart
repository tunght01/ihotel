import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';

class EzBody extends StatelessWidget {
  const EzBody({this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyScaffold),
      child: child,
    );
  }
}

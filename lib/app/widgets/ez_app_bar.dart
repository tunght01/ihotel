import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';

class EzAppBar extends StatelessWidget implements PreferredSizeWidget {
   const EzAppBar({
    this.title,
    this.actions,
    super.key,
    this.bottom,
  });

  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: Navigator.canPop(context) ? 0 : Dimens.paddingBodyScaffold,
      title: title,
      actions: [...actions ?? [], Dimens.paddingActionIcon.horizontalSpace],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

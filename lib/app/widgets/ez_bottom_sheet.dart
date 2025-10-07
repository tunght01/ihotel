import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ihostel/app/app.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EzBottomSheet {
  const EzBottomSheet._();

  static Future<T?> show<T>(BuildContext context, {required Widget child}) async {
    final value = await showModalBottomSheet<T>(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => child,
    );
    return value;
  }

  static Future<T?> showMaterial<T>(BuildContext context, {required Widget child}) async {
    final value = await showMaterialModalBottomSheet<T>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimens.d16),
        ),
      ),
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) => child,
    );
    return value;
  }

  static Size getWidgetSize(GlobalKey globalKey) {
    final renderBox = globalKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }
  // TODO(Hoang): use push widget when show keyboard
  // AnimatedPadding(
  // padding: MediaQuery.of(context).viewInsets,
  // duration: const Duration(milliseconds: 100),
  // curve: Curves.bounceOut,
}

abstract class BaseBottomSheetState<T extends StatefulWidget> extends BaseBottomSheetStateDelegate<T> {}

abstract class BaseBottomSheetStateDelegate<T extends StatefulWidget> extends State<T> {
  Size? _contentSize;
  final GlobalKey<State<StatefulWidget>> _contentKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> _bottomSheetKey = GlobalKey();
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(_postFrameCallback);
    return Container(
      constraints: BoxConstraints.expand(height: _contentSize?.height),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: buildBottomNavigationBar(context) != null ? Container(key: _bottomSheetKey, child: buildBottomNavigationBar(context)) : null,
        body: Container(key: _contentKey, child: buildPage(context)),
      ),
    );
  }

  Widget? buildBottomNavigationBar(BuildContext context);

  Widget buildPage(BuildContext context);

  void _postFrameCallback(_) {
    if (isFirst) {
      final size = MediaQuery.of(context).size;
      _contentSize = _contentKey.currentContext?.size ?? size;
      _contentSize = Size(
        _contentSize?.width ?? 0,
        (_contentSize?.height ?? 0) + EzBottomSheet.getWidgetSize(_bottomSheetKey).height,
      );
      if ((_contentSize?.height ?? 0) >= size.height) {
        _contentSize = Size(size.width, size.height * 0.85);
      }
      setState(() {});
      isFirst = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

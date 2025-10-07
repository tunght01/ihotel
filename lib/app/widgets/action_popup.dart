import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:ihostel/feature/navigation.dart';

final class EzActionPopUpItem {
  const EzActionPopUpItem(this.svgIcon, this.title);

  final SvgGenImage svgIcon;
  final String title;
}

class ActionPopUpHelper {
  ActionPopUpHelper._init() {
    router.routerDelegate.addListener(() {
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  static const _itemHeight = 64.0;
  static const _iconSize = 20.0;
  static const _itemPadding = 20.0;
  static OverlayEntry? _overlayEntry;

  static final ActionPopUpHelper instance = ActionPopUpHelper._init();

  void show(
    BuildContext context,
    GlobalKey key,
    List<EzActionPopUpItem> actions,
    void Function(int) onActionTapped, {
    double? toRight,
  }) {
    final keyContext = key.currentContext;
    final box = keyContext?.findRenderObject() as RenderBox?;
    var top = 0.0;
    var left = 0.0;
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = _getMaxItemWidth(context, actions);
    final popUpHeight = _itemHeight * actions.length + (actions.length - 1) * (Theme.of(context).dividerTheme.thickness ?? 1);
    if (box != null) {
      final offset = box.localToGlobal(Offset.zero);
      if (offset.dx + itemWidth > screenSize.width) {
        left = offset.dx + box.size.width - itemWidth;
      } else {
        left = offset.dx;
      }
      if (offset.dy + box.size.height + popUpHeight > screenSize.height - MediaQuery.of(context).padding.bottom) {
        top = offset.dy - popUpHeight;
      } else {
        top = offset.dy + box.size.height;
      }
      if (toRight != null) {
        left = screenSize.width - itemWidth - toRight;
      }
    }

    final rootContext = rootNavigatorKey.currentContext;
    if (rootContext != null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: PopScope(
            canPop: false,
            child: Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  onTap: () {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
                Positioned(
                  top: top,
                  left: left,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: popUpHeight,
                      width: itemWidth,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: actions.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            _overlayEntry?.remove();
                            _overlayEntry = null;
                            onActionTapped.call(index);
                          },
                          child: Container(
                            height: _itemHeight,
                            width: itemWidth,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              horizontal: _itemPadding,
                            ),
                            child: Row(
                              children: [
                                actions[index].svgIcon.svg(
                                      height: _iconSize,
                                      width: _iconSize,
                                    ),
                                Dimens.d10.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    actions[index].title,
                                    style: EzTextStyles.defaultPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  static double _getMaxItemWidth(
    BuildContext context,
    List<EzActionPopUpItem> actions,
  ) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    var maxTitleWidth = 0.0;
    for (final action in actions) {
      final painter = TextPainter(
        textDirection: TextDirection.ltr,
        // ignore: deprecated_member_use
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(
          text: action.title,
          style: textStyle,
        ),
      )..layout(maxWidth: MediaQuery.of(context).size.width * 0.5);
      maxTitleWidth = max(painter.width, maxTitleWidth);
    }
    return maxTitleWidth + _itemPadding * 2 + _iconSize + Dimens.d15 + 2;
  }
}

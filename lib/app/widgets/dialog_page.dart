import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';

class DialogPage<T> extends Page<T> {
  const DialogPage({
    required this.content,
    this.anchorPoint,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  DialogPage.normalDialog({
    required Widget content,
    this.anchorPoint,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : content = Dialog(
    backgroundColor: Colors.white,
    child: content,
  );

  DialogPage.alertDialog({
    required Widget content,
    String? title,
    List<Widget>? actions,
    this.anchorPoint,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : content = AlertDialog(
    title: title != null ? Text(title) : null,
    backgroundColor: Colors.white,
    content: content,
    actions: actions,
    actionsPadding: const EdgeInsets.all(Dimens.d8),
  );

  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final Widget content;

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
    context: context,
    settings: this,
    builder: (context) => content,
    anchorPoint: anchorPoint,
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    themes: themes,
  );
}

Future<void> showAlert(
  BuildContext context, {
  required String title,
  required String content,
  List<String>? actions,
  bool isDismissible = true,
  EdgeInsets insetPadding = const EdgeInsets.symmetric(horizontal: Dimens.d80),
  void Function(int index)? onActionButtonTapped,
}) {
  final defaultActions = actions ?? ['Ok'];
  return showDialog<void>(
    context: context,
    barrierDismissible: isDismissible,
    builder: (context) => AlertDialog(
      title: title.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Text(title, style: EzTextStyles.titlePrimary, textAlign: TextAlign.center),
            ),
      content: content.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
              child: Text(content, style: EzTextStyles.s12, textAlign: TextAlign.center),
            ),
      actions: [
        Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 0.5, color: Theme.of(context).dividerColor)),
          ),
          child: Row(
            children: defaultActions.mapIndexed((i, e) {
              final hasOneAction = defaultActions.length == 1;
              final isLast = defaultActions.length - 1 == i;
              final isFist = i == 0;
              if (hasOneAction) {
                return Expanded(
                  child: InkWell(
                    customBorder: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    onTap: () {
                      context.pop();
                      onActionButtonTapped?.call(i);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(e, textAlign: TextAlign.center, style: EzTextStyles.s12.w600.copyWith(color: Colors.blue)),
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: InkWell(
                    customBorder: isFist
                        ? const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)))
                        : isLast
                            ? const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)))
                            : null,
                    onTap: () {
                      context.pop();
                      onActionButtonTapped?.call(i);
                    },
                    child: Container(
                      decoration: isLast
                          ? null
                          : BoxDecoration(
                        border: Border(right: BorderSide(width: 0.5, color: Theme.of(context).dividerColor)),
                            ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(e, textAlign: TextAlign.center, style: EzTextStyles.s12.w600.copyWith(color: Colors.blue)),
                    ),
                  ),
                );
              }
            }).toList(),
          ),
        ),
      ],
      actionsPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      insetPadding: insetPadding,
      contentPadding: EdgeInsets.zero,
    ),
  );
}

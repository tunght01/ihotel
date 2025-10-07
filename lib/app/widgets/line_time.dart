import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';

class EzLineTime extends StatefulWidget {
  EzLineTime({
    required this.pages,
    this.padding,
    this.margin,
    this.paddingTab,
    this.isOnTapTimeLine = false,
    this.isShowBottom = true,
    this.onCompleted,
    this.onNext,
    this.resizeToAvoidBottomInset,
    this.boxColor = Colors.blue,
    this.dividerColor = Colors.blue,
    this.textStyle,
    this.physics,
    PageController? pageController,
    super.key,
  }) : pageController = pageController ?? PageController();
  final bool isOnTapTimeLine;
  final bool isShowBottom;
  final bool? resizeToAvoidBottomInset;
  final List<PageTimeLine> pages;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? paddingTab;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onCompleted;
  final void Function(int)? onNext;
  final PageController pageController;
  final Color dividerColor;
  final Color boxColor;
  final TextStyle? textStyle;
  final ScrollPhysics? physics;

  @override
  State<EzLineTime> createState() => _EzLineTimeState();
}

class _EzLineTimeState extends State<EzLineTime> {
  final indexPageController = StreamController<int>.broadcast();

  Stream<int> get indexPageStream => indexPageController.stream;
  int _selected = 0;

  @override
  void initState() {
    _selected = widget.pageController.initialPage;
    indexPageController.sink.add(_selected);
    super.initState();
  }

  @override
  void dispose() {
    indexPageController.close();
    widget.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.isShowBottom
          ? StreamBuilder<int>(
              stream: indexPageStream,
              builder: (context, snapshot) {
                final indexPage = snapshot.data ?? widget.pageController.initialPage;
                return Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(Dimens.d24),
                  child: EzButton.primaryFilled(
                    isEnabled: true,
                    title: indexPage == widget.pages.length - 1 ? S.current.save : S.current.next,
                    onPressed: () async {
                      widget.onNext?.call(_selected);

                      _selected = (widget.pageController.page?.toInt() ?? 0) + 1;
                      final lastPage = _selected;
                      if (_selected > widget.pages.length - 1) {
                        _selected = widget.pages.length - 1;
                      } else if (_selected < 0) {
                        _selected = 0;
                      }
                      await widget.pageController.animateToPage(
                        _selected,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      if (lastPage > widget.pages.length - 1) {
                        widget.onCompleted?.call();
                      }
                      // if (await widget.getXController?.validate(page: widget.selected) == true) {
                      //
                      // }
                    },
                  ),
                );
              },
            )
          : null,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: widget.paddingTab,
              child: StreamBuilder<int>(
                stream: indexPageStream,
                builder: (context, snapshot) {
                  return radio(
                    onPressed: widget.isOnTapTimeLine
                        ? (index) {
                            widget.pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: widget.margin,
                child: PageView(
                  controller: widget.pageController,
                  onPageChanged: (index) {
                    _selected = index;
                    hiddenKeyboard();
                    indexPageController.sink.add(_selected);
                  },
                  physics: widget.physics,
                  children: widget.pages.mapIndexed((i, e) {
                    return Container(
                      padding: widget.padding,
                      child: _ChildTimeLine(
                        isKeep: true,
                        child: e.child,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget radio({void Function(int)? onPressed}) {
    return Row(children: [...genItem(onPressed: onPressed)]);
  }

  List<Widget> genItem({void Function(int)? onPressed}) {
    final listItem = <Widget>[];
    widget.pages.forEachIndexed(
      (i, element) {
        listItem.add(
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                if (onPressed != null) {
                  _selected = i;
                  onPressed.call(i);
                }
              },
              child: _customRadioButton(
                dividerColor: widget.dividerColor,
                boxColor: widget.boxColor,
                style: widget.textStyle,
                state: (i < getIndex())
                    ? StateRadio.done
                    : (i == getIndex())
                        ? StateRadio.active
                        : StateRadio.cancel,
                title: element.title,
                visibleL: !(i == 0),
                visibleR: !(i == widget.pages.length - 1),
              ),
            ),
          ),
        );
      },
    );
    return listItem;
  }

  int getIndex() => _selected >= widget.pages.length
      ? widget.pages.length
      : _selected <= 0
          ? 0
          : _selected;
}

class _ChildTimeLine extends StatefulWidget {
  const _ChildTimeLine({
    required this.child,
    required this.isKeep,
  });

  final bool isKeep;
  final Widget child;

  @override
  State<_ChildTimeLine> createState() => _ChildTimeLineState();
}

class _ChildTimeLineState extends State<_ChildTimeLine> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(child: widget.child);
  }

  @override
  bool get wantKeepAlive => widget.isKeep;
}

enum StateRadio { cancel, active, done }

Widget _customRadioButton({
  required String title,
  StateRadio state = StateRadio.cancel,
  Color dividerColor = Colors.blue,
  Color boxColor = Colors.blue,
  TextStyle? style,
  bool visibleL = true,
  bool visibleR = true,
}) {
  switch (state) {
    case StateRadio.cancel:
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Visibility(
                  visible: visibleL,
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  child: Divider(color: dividerColor, height: Dimens.d2),
                ),
              ),
              Container(
                width: Dimens.d32,
                height: Dimens.d32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.d32),
                  border: Border.all(color: boxColor, width: Dimens.d2),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: visibleR,
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  child: Divider(color: dividerColor, height: Dimens.d2),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: Dimens.d2),
            child: Text(title, style: style),
          ),
        ],
      );
    case StateRadio.active:
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Visibility(
                  visible: visibleL,
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  child: Divider(color: dividerColor, height: Dimens.d2),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(Dimens.d10),
                width: Dimens.d32,
                height: Dimens.d32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.d32),
                  border: Border.all(color: boxColor, width: Dimens.d2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.d10),
                    color: boxColor,
                  ),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: visibleR,
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  child: Divider(color: dividerColor, height: Dimens.d2),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: Dimens.d2),
            child: Text(title, style: style),
          ),
        ],
      );
    case StateRadio.done:
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Visibility(
                  visible: visibleL,
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  child: Divider(color: dividerColor, height: Dimens.d2),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimens.d11,
                  horizontal: Dimens.d9,
                ),
                width: Dimens.d32,
                height: Dimens.d32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.d32),
                  color: boxColor,
                ),
                child: Assets.images.icTick.svg(
                  width: Dimens.d20,
                  height: Dimens.d20,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: visibleR,
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  child: Divider(color: dividerColor, height: Dimens.d2),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: Dimens.d2),
            child: Text(title, style: style),
          ),
        ],
      );
  }
}

class PageTimeLine {
  PageTimeLine({required this.title, required this.child});

  final String title;
  final Widget child;
}

mixin BaseGetXTimeLine {
  Future<bool> validate<T>({required int page});
}

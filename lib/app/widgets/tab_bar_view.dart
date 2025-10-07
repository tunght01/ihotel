import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';

class EzTabBarView extends StatefulWidget {
  EzTabBarView({
    required this.children,
    this.onTapChange,
    this.tabController,
    this.header,
    this.marginHorizontal = 0,
    this.isScrollable = false,
    this.padding,
    this.tabAlignment,
    super.key,
  }) {
    // TODO(Hoang): review
  }

  final TabController? tabController;
  final List<EzTabView> children;
  final Widget? header;
  final ValueSetter<int>? onTapChange;
  final TabAlignment? tabAlignment;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final double marginHorizontal;

  @override
  State<EzTabBarView> createState() => _EzTabBarViewState();
}

class _EzTabBarViewState extends State<EzTabBarView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = widget.tabController ??
        TabController(
          length: widget.children.length,
          vsync: this,
        );
    _tabController.addListener(() {
      widget.onTapChange?.call(_tabController.index);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EzTabBarView oldWidget) {
    if (oldWidget.children.length != widget.children.length) {
      _tabController.dispose();
      _tabController = widget.tabController ??
          TabController(
            length: widget.children.length,
            vsync: this,
          );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.header != null) widget.header!,
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: Theme.of(context).tabBarTheme.dividerColor,
              margin: EdgeInsets.only(
                bottom: 1,
                right: widget.marginHorizontal,
                left: widget.marginHorizontal,
              ),
            ),
            TabBar.secondary(
              padding: widget.padding,
              tabAlignment: widget.tabAlignment,
              controller: _tabController,
              isScrollable: widget.isScrollable,
              dividerColor: Colors.transparent,
              indicator: UnderlineTabIndicator(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                borderSide: BorderSide(color: AppColors.current.primary, width: 4),
              ),
              onTap: (i) => widget.children[i].onTapHeader?.call(),
              tabs: widget.children
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimens.d10),
                      child: Text(e.title, maxLines: 1),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: widget.children.map((e) => e.child).toList(),
          ),
        ),
      ],
    );
  }
}

class EzTabView {
  EzTabView({
    required this.title,
    required this.child,
    this.onTapHeader,
  });

  final String title;
  final Widget child;
  final VoidCallback? onTapHeader;
}

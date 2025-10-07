// ignore_for_file: prefer_asserts_with_message, parameter_assignments, library_private_types_in_public_api, use_late_for_private_fields_and_variables

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverStickyHeader extends RenderObjectWidget {
  const SliverStickyHeader({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  _RenderSliverStickyHeader createRenderObject(BuildContext context) => _RenderSliverStickyHeader();

  @override
  _SliverStickyHeaderElement createElement() => _SliverStickyHeaderElement(this);
}

class _SliverStickyHeaderElement extends RenderObjectElement {
  _SliverStickyHeaderElement(super.widget);

  @override
  _RenderSliverStickyHeader get renderObject => super.renderObject as _RenderSliverStickyHeader;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject._element = this;
  }

  @override
  void unmount() {
    renderObject._element = null;
    super.unmount();
  }

  @override
  void update(SliverStickyHeader newWidget) {
    final oldWidget = widget as SliverStickyHeader;
    super.update(newWidget);
    final newChild = newWidget.child;
    final oldChild = oldWidget.child;
    if (newChild != oldChild && (newChild.runtimeType != oldChild.runtimeType)) {
      renderObject.triggerRebuild();
    }
  }

  @override
  void performRebuild() {
    super.performRebuild();
    renderObject.triggerRebuild();
  }

  Element? child;

  void _build() {
    owner!.buildScope(this, () {
      final headerWidget = widget as SliverStickyHeader;
      child = updateChild(
        child,
        headerWidget.child,
        null,
      );
    });
  }

  @override
  void forgetChild(Element child) {
    assert(child == this.child);
    this.child = null;
    super.forgetChild(child);
  }

  @override
  void insertRenderObjectChild(covariant RenderBox child, Object? slot) {
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
  }

  @override
  void moveRenderObjectChild(
    covariant RenderObject child,
    Object? oldSlot,
    Object? newSlot,
  ) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(covariant RenderObject child, Object? slot) {
    renderObject.child = null;
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (child != null) {
      visitor(child!);
    }
  }
}

// --------------------- renderer --------------------------- //

Rect? _trim(
  Rect? original, {
  double top = -double.infinity,
  double right = double.infinity,
  double bottom = double.infinity,
  double left = -double.infinity,
}) =>
    original?.intersect(Rect.fromLTRB(left, top, right, bottom));

class _RenderSliverStickyHeader extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox>, RenderSliverHelpers {
  _RenderSliverStickyHeader({
    RenderBox? child,
  }) {
    this.child = child;
  }

  double? _lastActualScrollOffset;
  double? _effectiveScrollOffset;

  ScrollDirection? _lastStartedScrollDirection;

  double? _childPosition;

  _SliverStickyHeaderElement? _element;

  @protected
  double get childExtent {
    if (child == null) {
      return 0;
    }
    assert(child!.hasSize);
    switch (constraints.axis) {
      case Axis.vertical:
        return child!.size.height;
      case Axis.horizontal:
        return child!.size.width;
    }
  }

  bool _needsUpdateChild = true;

  @override
  void markNeedsLayout() {
    _needsUpdateChild = true;
    super.markNeedsLayout();
  }

  @protected
  void layoutChild(
    double scrollOffset,
    double maxExtent, {
    bool overlapsContent = false,
  }) {
    final double shrinkOffset = math.min(scrollOffset, maxExtent);
    if (_needsUpdateChild) {
      invokeLayoutCallback<SliverConstraints>((SliverConstraints constraints) {
        assert(constraints == this.constraints);
        updateChild(shrinkOffset, overlapsContent);
      });
      _needsUpdateChild = false;
    }
    child?.layout(
      constraints.asBoxConstraints(),
      parentUsesSize: true,
    );
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    assert(geometry!.hitTestExtent > 0.0);
    if (child != null) {
      return hitTestBoxChild(
        BoxHitTestResult.wrap(result),
        child!,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
      );
    }
    return false;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child == this.child);
    applyPaintTransformForBoxChild(child as RenderBox, transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection,
        constraints.growthDirection,
      )) {
        case AxisDirection.up:
          offset += Offset(0, geometry!.paintExtent - childMainAxisPosition(child!) - childExtent);
        case AxisDirection.down:
          offset += Offset(0, childMainAxisPosition(child!));
        case AxisDirection.left:
          offset += Offset(geometry!.paintExtent - childMainAxisPosition(child!) - childExtent, 0);
        case AxisDirection.right:
          offset += Offset(childMainAxisPosition(child!), 0);
      }
      context.paintChild(child!, offset);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.addTagForChildren(RenderViewport.excludeFromScrolling);
  }

  // pinned floating

  @protected
  double updateGeometry() {
    final minExtent = childExtent;
    final minAllowedExtent = constraints.remainingPaintExtent > minExtent ? minExtent : constraints.remainingPaintExtent;
    final maxExtent = childExtent;
    final paintExtent = maxExtent - _effectiveScrollOffset!;
    final clampedPaintExtent = clampDouble(
      paintExtent,
      minAllowedExtent,
      constraints.remainingPaintExtent,
    );
    final layoutExtent = maxExtent - constraints.scrollOffset;
    geometry = SliverGeometry(
      scrollExtent: maxExtent,
      paintOrigin: math.min(constraints.overlap, 0),
      paintExtent: clampedPaintExtent,
      layoutExtent: clampDouble(layoutExtent, 0, clampedPaintExtent),
      maxPaintExtent: maxExtent,
      maxScrollObstructionExtent: minExtent,
      hasVisualOverflow: true,
    );
    return 0;
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    final maxExtent = childExtent;
    if (_lastActualScrollOffset != null && ((constraints.scrollOffset < _lastActualScrollOffset!) || (_effectiveScrollOffset! < maxExtent))) {
      var delta = _lastActualScrollOffset! - constraints.scrollOffset;

      final allowFloatingExpansion = constraints.userScrollDirection == ScrollDirection.forward || (_lastStartedScrollDirection != null && _lastStartedScrollDirection == ScrollDirection.forward);
      if (allowFloatingExpansion) {
        if (_effectiveScrollOffset! > maxExtent) {
          _effectiveScrollOffset = maxExtent;
        }
      } else {
        if (delta > 0.0) {
          delta = 0.0;
        }
      }
      _effectiveScrollOffset = clampDouble(
        _effectiveScrollOffset! - delta,
        0,
        constraints.scrollOffset,
      );
    } else {
      _effectiveScrollOffset = constraints.scrollOffset;
    }
    final overlapsContent = _effectiveScrollOffset! < constraints.scrollOffset;

    layoutChild(
      _effectiveScrollOffset!,
      maxExtent,
      overlapsContent: overlapsContent,
    );
    _childPosition = updateGeometry();
    _lastActualScrollOffset = constraints.scrollOffset;
  }

  @override
  void showOnScreen({
    RenderObject? descendant,
    Rect? rect,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
  }) {
    assert(child != null || descendant == null);

    final childBounds = descendant != null
        ? MatrixUtils.transformRect(
            descendant.getTransformTo(child),
            rect ?? descendant.paintBounds,
          )
        : rect;

    double targetExtent;
    Rect? targetRect;
    switch (applyGrowthDirectionToAxisDirection(
      constraints.axisDirection,
      constraints.growthDirection,
    )) {
      case AxisDirection.up:
        targetExtent = childExtent - (childBounds?.top ?? 0);
        targetRect = _trim(childBounds, bottom: childExtent);
      case AxisDirection.right:
        targetExtent = childBounds?.right ?? childExtent;
        targetRect = _trim(childBounds, left: 0);
      case AxisDirection.down:
        targetExtent = childBounds?.bottom ?? childExtent;
        targetRect = _trim(childBounds, top: 0);
      case AxisDirection.left:
        targetExtent = childExtent - (childBounds?.left ?? 0);
        targetRect = _trim(childBounds, right: childExtent);
    }

    final double effectiveMaxExtent = math.max(childExtent, childExtent);

    targetExtent = clampDouble(
      clampDouble(
        targetExtent,
        double.negativeInfinity,
        double.infinity,
      ),
      childExtent,
      effectiveMaxExtent,
    );

    super.showOnScreen(
      descendant: descendant == null ? this : child,
      rect: targetRect,
      duration: duration,
      curve: curve,
    );
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    assert(child == this.child);
    return _childPosition ?? 0.0;
  }

  void updateChild(double shrinkOffset, bool overlapsContent) {
    assert(_element != null);
    _element!._build();
  }

  @protected
  void triggerRebuild() {
    markNeedsLayout();
  }
}

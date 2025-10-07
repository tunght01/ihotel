// ignore_for_file: parameter_assignments, prefer_asserts_with_message, type_annotate_public_apis

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverFloatingHeader extends SingleChildRenderObjectWidget {
  const SliverFloatingHeader({
    super.key,
    super.child,
  });

  @override
  RenderSliverFloatingHeader createRenderObject(context) => RenderSliverFloatingHeader();
}

class RenderSliverFloatingHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverFloatingHeader({super.child});

  double _lastActualScrollOffset = 0;
  double _effectiveScrollOffset = 0;
  double _childPosition = 0;

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final maxExtent = childExtent;
    final paintExtent = maxExtent - _effectiveScrollOffset;
    final layoutExtent = maxExtent - constraints.scrollOffset;

    if (constraints.scrollOffset < _lastActualScrollOffset || _effectiveScrollOffset < maxExtent) {
      var delta = _lastActualScrollOffset - constraints.scrollOffset;
      final allowFloatingExpansion = constraints.userScrollDirection == ScrollDirection.forward;
      if (allowFloatingExpansion) {
        _effectiveScrollOffset = min(_effectiveScrollOffset, maxExtent);
      } else {
        delta = min(delta, 0);
      }
      _effectiveScrollOffset = (_effectiveScrollOffset - delta).clamp(0.0, constraints.scrollOffset);
    } else {
      _effectiveScrollOffset = constraints.scrollOffset;
    }
    excludeFromSemanticsScrolling = _effectiveScrollOffset <= constraints.scrollOffset;
    geometry = SliverGeometry(
      scrollExtent: maxExtent,
      paintOrigin: min(constraints.overlap, 0),
      paintExtent: paintExtent.clamp(0.0, constraints.remainingPaintExtent),
      layoutExtent: min(
        paintExtent.clamp(0.0, constraints.remainingPaintExtent),
        layoutExtent.clamp(0.0, constraints.remainingPaintExtent),
      ),
      maxPaintExtent: maxExtent,
      hasVisualOverflow: true,
    );
    _childPosition = min(0, paintExtent - childExtent);
    _lastActualScrollOffset = constraints.scrollOffset;
  }

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
    // return null;
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    assert(geometry!.hitTestExtent > 0.0);

    return child != null &&
        hitTestBoxChild(
          BoxHitTestResult.wrap(result),
          child!,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        );
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

  bool get excludeFromSemanticsScrolling => _excludeFromSemanticsScrolling;
  bool _excludeFromSemanticsScrolling = false;

  set excludeFromSemanticsScrolling(bool value) {
    if (_excludeFromSemanticsScrolling != value) {
      _excludeFromSemanticsScrolling = value;
      markNeedsSemanticsUpdate();
    }
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    assert(child == this.child);
    return _childPosition;
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    if (_excludeFromSemanticsScrolling) {
      config.addTagForChildren(RenderViewport.excludeFromScrolling);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DoubleProperty('effective scroll offset', _effectiveScrollOffset),
      )
      ..add(
        DoubleProperty.lazy('child position', () => childMainAxisPosition(child!)),
      );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimationPage {
  static CustomTransitionPage<T> create<T>({required Widget child, LocalKey? key}) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class BaseGoRouteData extends GoRouteData {
  Future<T?> pushOnLy<T>(BuildContext? context);
}

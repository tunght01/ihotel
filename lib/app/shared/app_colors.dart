import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';

class AppColors {
  const AppColors({
    required this.primary,
    required this.secondary,
    required this.primaryText,
    required this.backgroundTextField,
    required this.secondaryBackgroundTextField,
    required this.hintColor,
    required this.secondaryText,
    required this.primaryGradient,
    required this.disabledText,
    required this.backgroundNavigationBar,
    required this.background,
    required this.divider,
    required this.error,
    required this.warning,
    required this.success,
    required this.disabled,
  });

  //common
  static const primaryCommon = Color(0xFF6617cb);

  static late AppColors current;

  static AppColors of(BuildContext context) {
    return current = Theme.of(context).appColor;
  }

  final Color primary;
  final Color secondary;
  final Color primaryText;
  final Color backgroundTextField;
  final Color secondaryBackgroundTextField;
  final Color background;
  final Color hintColor;
  final Color secondaryText;
  final Color disabledText;
  final Color backgroundNavigationBar;
  final Color divider;
  final Color error;
  final Color warning;
  final Color success;
  final Color disabled;

  /// gradient
  final LinearGradient primaryGradient;

  static const lightTheme = AppColors(
    primary: Color(0xFF6617cb),
    secondary: Color(0xFF246BFD),
    primaryText: Color(0xFF0F172A),
    backgroundTextField: Colors.white,
    secondaryBackgroundTextField: Color(0xFFF1F5F9),
    background: Color(0xFFFAFAFD),
    hintColor: Color(0xFF64748B),
    secondaryText: Color(0xFF64748B),
    disabledText: Color(0xFF94a3b8),
    backgroundNavigationBar: Color(0xffffffff),
    divider: Color(0xFF9E9E9E),
    error: Color(0xFFF75555),
    warning: Color(0xFFFFD023),
    success: Color(0xFF1BC256),
    disabled: Color(0xFFF8F8F8),
    primaryGradient: LinearGradient(
      colors: [
        Color(0xFF246BFD),
        Color(0xFF5089FD),
      ],
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ),
  );

  static const darkTheme = AppColors(
    primary: Color(0xFF6617cb),
    secondary: Color(0xFF246BFD),
    primaryText: Colors.white,
    hintColor: Color(0xFF64748B),
    backgroundTextField: Color(0xD33C3F3F),
    secondaryBackgroundTextField: Color(0xFF141414),
    background: Color(0xFF050505),
    secondaryText: Color(0xFF64748B),
    disabledText: Color(0xFF94a3b8),
    backgroundNavigationBar: Color(0xFF050505),
    divider: Color(0xFF9E9E9E),
    error: Color(0xFFF75555),
    warning: Color(0xFFFFD023),
    success: Color(0xFF1BC256),
    disabled: Color(0xFFF8F8F8),
    primaryGradient: LinearGradient(
      colors: [
        Color(0xFF246BFD),
        Color(0xFF5089FD),
      ],
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ),
  );

  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? primaryText,
    Color? backgroundTextField,
    Color? secondaryBackgroundTextField,
    Color? secondaryText,
    Color? disabledText,
    Color? backgroundNavigationBar,
    Color? background,
    Color? divider,
    Color? hintColor,
    Color? error,
    Color? warning,
    Color? success,
    Color? disabled,
    LinearGradient? primaryGradient,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      primaryText: primaryText ?? this.primaryText,
      backgroundTextField: backgroundTextField ?? this.backgroundTextField,
      secondaryBackgroundTextField: secondaryBackgroundTextField ?? this.secondaryBackgroundTextField,
      secondaryText: secondaryText ?? this.secondaryText,
      disabledText: disabledText ?? this.disabledText,
      backgroundNavigationBar: backgroundNavigationBar ?? this.backgroundNavigationBar,
      hintColor: hintColor ?? this.hintColor,
      divider: divider ?? this.divider,
      background: background ?? this.background,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      disabled: disabled ?? this.disabled,
      primaryGradient: primaryGradient ?? this.primaryGradient,
    );
  }
}

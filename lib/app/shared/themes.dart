import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:ihostel/assets_gen/fonts.gen.dart';

/// define custom themes here
final lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: FontFamily.inter,
  dividerColor: AppColors.lightTheme.divider,
  scaffoldBackgroundColor: AppColors.lightTheme.background,
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
    color: AppColors.lightTheme.background,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: Dimens.d18.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTheme.primaryText,
    ),
    iconTheme: IconThemeData(
      color: AppColors.darkTheme.background,
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.darkTheme.background,
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFF4F4F4),
    indent: 0,
    endIndent: 0,
    space: 0,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(0, 52),
      backgroundColor: AppColors.lightTheme.primary,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.white,
      disabledBackgroundColor: AppColors.lightTheme.disabled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: FontFamily.inter,
      ),
    ),
  ),
  datePickerTheme: const DatePickerThemeData(
    surfaceTintColor: Colors.transparent,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      fixedSize: const Size.fromHeight(52),
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      foregroundColor: AppColors.lightTheme.divider,
      disabledForegroundColor: Colors.white,
      disabledBackgroundColor: AppColors.lightTheme.disabled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: FontFamily.inter,
      ),
    ),
  ),
  dialogBackgroundColor: Colors.white,
  dialogTheme: DialogTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    indicatorColor: Colors.transparent,
    labelTextStyle: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return TextStyle(
          color: AppColors.lightTheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: FontFamily.inter,
          height: 1.3,
        );
      }
      return TextStyle(
        color: AppColors.lightTheme.background,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: FontFamily.inter,
        height: 1.3,
      );
    }),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(allowSnapshotting: false),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  bottomSheetTheme: BottomSheetThemeData(
    surfaceTintColor: AppColors.lightTheme.background,
    modalBackgroundColor: AppColors.lightTheme.background,
    backgroundColor: AppColors.lightTheme.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  ),
  tabBarTheme: TabBarTheme(
    dividerColor: AppColors.lightTheme.divider,
    indicatorColor: AppColors.lightTheme.primary,
    unselectedLabelColor: AppColors.lightTheme.secondaryText,
    labelColor: AppColors.lightTheme.primary,
    labelStyle: const TextStyle(
      fontSize: 14,
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w700,
      height: 1.50,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14,
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w600,
      height: 1.50,
    ),
  ),
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) => Assets.images.arrowLeft.svg(color: AppColors.darkTheme.background),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateColor.resolveWith((states) => AppColors.lightTheme.primary),
    splashRadius: 16,
  ),
  checkboxTheme: CheckboxThemeData(
    splashRadius: 16,
    checkColor: const MaterialStatePropertyAll(Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    side: BorderSide(color: AppColors.lightTheme.primary, width: 2),
  ),
  switchTheme: SwitchThemeData(
    splashRadius: 16,
    trackOutlineColor: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected) ? AppColors.lightTheme.primary : const Color(0xFFE2E8F0),
    ),
    thumbColor: const MaterialStatePropertyAll(Colors.white),
    overlayColor: const MaterialStatePropertyAll(Colors.transparent),
    trackColor: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected) ? AppColors.lightTheme.primary : const Color(0xFFE2E8F0),
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    linearTrackColor: Color(0xFFE0E0E0),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.lightTheme.secondaryBackgroundTextField),
      elevation: MaterialStateProperty.all<double>(0),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      visualDensity: VisualDensity.standard,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      constraints: BoxConstraints.tight(const Size.fromHeight(52)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      fillColor: AppColors.lightTheme.secondaryBackgroundTextField,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTheme.primaryText,
      fontFamily: FontFamily.inter,
    ),
  ),
  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
)..addAppColor(
    AppThemeType.light,
    AppColors.lightTheme,
  );

final darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: FontFamily.inter,
  dividerColor: AppColors.darkTheme.divider,
  scaffoldBackgroundColor: AppColors.darkTheme.background,
  iconTheme: const IconThemeData(color: Colors.white),
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
    color: AppColors.darkTheme.background,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: Dimens.d18.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTheme.background,
    ),
    iconTheme: IconThemeData(
      color: AppColors.lightTheme.background,
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.lightTheme.background,
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFF4F4F4),
    indent: 0,
    endIndent: 0,
    space: 0,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(0, 52),
      backgroundColor: AppColors.darkTheme.primary,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.white,
      disabledBackgroundColor: AppColors.lightTheme.disabled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: FontFamily.inter,
      ),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.darkTheme.background,
    surfaceTintColor: AppColors.darkTheme.background,
    indicatorColor: Colors.transparent,
    labelTextStyle: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return TextStyle(
          color: AppColors.darkTheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: FontFamily.inter,
          height: 1.3,
        );
      }
      return TextStyle(
        color: AppColors.lightTheme.background,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: FontFamily.inter,
        height: 1.3,
      );
    }),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      fixedSize: const Size.fromHeight(52),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: AppColors.darkTheme.divider,
      disabledForegroundColor: Colors.white,
      disabledBackgroundColor: AppColors.darkTheme.disabled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: FontFamily.inter,
      ),
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(allowSnapshotting: false),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  bottomSheetTheme: BottomSheetThemeData(
    surfaceTintColor: AppColors.lightTheme.background,
    modalBackgroundColor: AppColors.lightTheme.background,
    backgroundColor: AppColors.lightTheme.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  ),
  tabBarTheme: TabBarTheme(
    dividerColor: AppColors.lightTheme.background,
    indicatorColor: AppColors.darkTheme.primary,
    unselectedLabelColor: AppColors.lightTheme.background,
    labelColor: AppColors.darkTheme.primary,
    labelStyle: const TextStyle(
      fontSize: 14,
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w700,
      height: 1.50,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14,
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w500,
      height: 1.50,
    ),
  ),
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) => Assets.images.arrowLeft.svg(color: AppColors.lightTheme.background),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateColor.resolveWith((states) => const Color(0xFF246BFD)),
    splashRadius: 16,
  ),
  checkboxTheme: CheckboxThemeData(
    splashRadius: 16,
    checkColor: const MaterialStatePropertyAll(Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    side: const BorderSide(color: Color(0xFF246BFD), width: 2),
  ),
  switchTheme: SwitchThemeData(
    splashRadius: 16,
    trackOutlineColor: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected) ? AppColors.darkTheme.primary : const Color(0xFFE2E8F0),
    ),
    thumbColor: const MaterialStatePropertyAll(Colors.white),
    overlayColor: const MaterialStatePropertyAll(Colors.transparent),
    trackColor: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected) ? AppColors.darkTheme.primary : const Color(0xFFE2E8F0),
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    linearTrackColor: Color(0xFFE0E0E0),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: MaterialStatePropertyAll<Color>(AppColors.darkTheme.secondaryBackgroundTextField),
      elevation: const MaterialStatePropertyAll<double>(0),
      padding: const MaterialStatePropertyAll(EdgeInsets.zero),
      shape: const MaterialStatePropertyAll<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      visualDensity: VisualDensity.standard,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      constraints: BoxConstraints.tight(const Size.fromHeight(52)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      fillColor: AppColors.darkTheme.secondaryBackgroundTextField,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTheme.primaryText,
      fontFamily: FontFamily.inter,
    ),
  ),
  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
)..addAppColor(
    AppThemeType.dark,
    AppColors.darkTheme,
  );

enum AppThemeType {
  system,
  dark,
  light,
}

extension ThemeDataExtensions on ThemeData {
  static final Map<AppThemeType, AppColors> _appColorMap = {};

  void addAppColor(AppThemeType type, AppColors appColor) {
    _appColorMap[type] = appColor;
  }

  AppColors get appColor {
    final key = AppThemeSetting.currentAppThemeType == AppThemeType.system ? AppThemeType.light : AppThemeSetting.currentAppThemeType;
    return _appColorMap[key] ?? AppColors.lightTheme;
  }
}

extension AppThemeTypeExt on AppThemeType {
  String get title => switch (this) {
        AppThemeType.dark => S.current.general_on,
        AppThemeType.light => S.current.general_off,
        AppThemeType.system => S.current.general_system,
      };

  ThemeMode get theme => switch (this) {
        AppThemeType.dark => ThemeMode.dark,
        AppThemeType.light => ThemeMode.light,
        AppThemeType.system => ThemeMode.system,
      };

  bool get isDarkMode => this == AppThemeType.system ? WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark : this == AppThemeType.dark;
}

class AppThemeSetting {
  const AppThemeSetting._();

  static AppThemeType currentAppThemeType = AppThemeType.system;
}

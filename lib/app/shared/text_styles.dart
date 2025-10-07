import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';

extension EzTextStyleExt on TextStyle {
  TextStyle get w100 => copyWith(fontWeight: FontWeight.w100);

  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);

  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);

  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);

  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);

  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);

  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);

  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);

  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);

  TextStyle get primary => copyWith(color: AppColors.current.primaryText);

  TextStyle get secondary => copyWith(color: AppColors.current.secondaryText);
}

class EzTextStyles {
  EzTextStyles._();

  static const _defaultLetterSpacing = 0.03;

  static const _baseTextStyle = TextStyle(
    letterSpacing: _defaultLetterSpacing,
    // height: 1.0,
  );

  static TextStyle get defaultPrimary => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.current.primaryText,
        ),
      );

  static TextStyle get defaultSecondary => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.current.secondaryText,
        ),
      );

  static TextStyle get titlePrimary => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.current.primaryText,
        ),
      );

  static TextStyle get selectionPrimary => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.current.primary,
        ),
      );

  static TextStyle get disabled => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.current.disabledText,
        ),
      );

  static TextStyle get error => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.current.error,
        ),
      );

  static TextStyle get success => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.current.success,
        ),
      );

  static TextStyle get warning => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.current.warning,
        ),
      );

  static TextStyle get overBudget => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.current.error,
        ),
      );

  static TextStyle get inBudget => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.current.secondary,
        ),
      );

  static TextStyle get s10 => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d10.sp,
          fontWeight: FontWeight.w400,
        ),
      );

  static TextStyle get s10White => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d10.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );

  static TextStyle get s11 => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d11.sp,
          fontWeight: FontWeight.w400,
        ),
      );

  static TextStyle get s12 => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d12.sp,
          fontWeight: FontWeight.w400,
        ),
      );

  static TextStyle get s14 => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d14.sp,
          fontWeight: FontWeight.w600,
        ),
      );

  static TextStyle get s16 => _baseTextStyle.merge(
    TextStyle(
      fontSize: Dimens.d16.sp,
      color: AppColors.current.primaryText,
      fontWeight: FontWeight.w700,
    ),
  );

  static TextStyle get s18 => _baseTextStyle.merge(
        TextStyle(
          fontSize: Dimens.d18.sp,
          fontWeight: FontWeight.w700,
        ),
      );
}

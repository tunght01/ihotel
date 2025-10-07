import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.images.noData.svg(width: Dimens.d148),
        Dimens.d10.verticalSpace,
        Text(
          message,
          textAlign: TextAlign.center,
          style: EzTextStyles.s14.secondary.w500,
        ),
      ],
    );
  }
}

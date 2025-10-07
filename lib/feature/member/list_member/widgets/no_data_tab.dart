import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';

class NoDataTab extends StatelessWidget {
  const NoDataTab({required this.title, super.key, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.noData.svg(),
        Dimens.d25.verticalSpace,
        Text(title, style: EzTextStyles.s14.secondary.w500),
        Dimens.d15.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: EzButton.primaryFilled(
            isEnabled: true,
            onPressed: onTap,
            title: title,
          ),
        ),
      ],
    );
  }
}

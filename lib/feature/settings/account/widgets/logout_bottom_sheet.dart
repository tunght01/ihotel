import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';

Future<void> showLogoutBottomSheet(BuildContext context) async {
  await EzBottomSheet.show<void>(
    context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Dimens.d8.verticalSpace,
        Container(
          width: Dimens.d38,
          height: Dimens.d3,
          color: Colors.grey,
        ),
        Dimens.d24.verticalSpace,
        Text(
          'Đăng xuất',
          style: EzTextStyles.s14.w500.copyWith(color: Colors.red),
        ),
        Dimens.d24.verticalSpace,
        const Divider(),
        Dimens.d24.verticalSpace,
        Text(
          'Bạn có muốn thoát?',
          style: EzTextStyles.s14.w500.primary,
        ),
        Dimens.d24.verticalSpace,
        const Row(
            // Nên dùng nút gì vậy anh?
            ),
      ],
    ),
  );
}

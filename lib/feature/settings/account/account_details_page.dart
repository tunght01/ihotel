import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:ihostel/feature/navigation.dart';
import 'package:ihostel/feature/settings/account/widgets/account_detail_item_button.dart';
import 'package:ihostel/feature/settings/account/widgets/info_header_view.dart';

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({super.key});

  static const routeName = 'account_details';

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  final user = getIt<AppCubit>().localStorageDataSource.ezUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EzAppBar(title: Text('Tài khoản IHostel')),
      body: EzBody(
        child: Padding(
          padding: const EdgeInsets.only(bottom: Dimens.d48),
          child: Column(
            children: [
              InfoHeaderView(
                avatar: Assets.images.al,
                name: user?.fullName ?? '',
                email: user?.email ?? '',
              ),
              Dimens.d15.verticalSpace,
              const Divider(),
              Dimens.d15.verticalSpace,
              AccountDetailItemButton(
                icon: Assets.images.person,
                title: 'Liên kết ngân hàng',
                onPressed: () {
                  // Xu ly o day
                },
                trailingIcon: Assets.images.google.svg(
                  width: Dimens.d20,
                  height: Dimens.d20,
                ),
                content: Container(),
              ),
              Dimens.d24.verticalSpace,
              AccountDetailItemButton(
                icon: Assets.images.bank,
                title: 'Thông tin ngân hàng',
                content: Text(
                  'Thông tin ngân hàng',
                  style: EzTextStyles.s14.w600.primary,
                ),
                onPressed: () {
                  // Xu ly o day
                },
                trailingIcon: Assets.images.arrowRight.svg(
                  width: Dimens.d20,
                  height: Dimens.d20,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              Dimens.d24.verticalSpace,
              AccountDetailItemButton(
                icon: Assets.images.blueWindow,
                title: 'Mã người dùng',
                content: Text(
                  user?.inviteCode ?? '',
                  style: EzTextStyles.s14.w600.primary,
                ),
                onPressed: () => MemberInfoRoute().pushOnLy<void>(context),
                trailingIcon: Assets.images.arrowRight.svg(
                  width: Dimens.d20,
                  height: Dimens.d20,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

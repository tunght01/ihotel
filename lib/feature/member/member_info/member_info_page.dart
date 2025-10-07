import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MemberInfoPage extends StatefulWidget {
  const MemberInfoPage({super.key});

  static const routeName = 'member_info';

  @override
  State<MemberInfoPage> createState() => _MemberInfoPageState();
}

class _MemberInfoPageState extends State<MemberInfoPage> {
  final user = getIt<AppCubit>().localStorageDataSource.ezUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EzAppBar(
        title: Text('Thông tin gia nhập nhóm'),
      ),
      body: EzBody(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: EzCard(
                      borderRadius: BorderRadius.circular(Dimens.d10),
                      color: Colors.white,
                      height: 280,
                      child: SizedBox(
                        height: 250,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: QrImageView(
                            data: '${user?.email}/${user?.inviteCode}',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Dimens.d15.verticalSpace,
                  const Text(
                    'Vui lòng cung cấp thông tin dưới đây tới người quản lý khu trọ để họ thêm bạn vào nhóm.',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  Dimens.d15.verticalSpace,
                  EzTextField(
                    title: 'Tên',
                    value: user?.fullName ?? '',
                    enabled: false,
                  ),
                  Dimens.d15.verticalSpace,
                  EzTextField(
                    title: 'Email',
                    value: user?.email ?? '',
                    enabled: false,
                  ),
                  Dimens.d15.verticalSpace,
                  EzTextField(
                    title: 'Mã người dùng Ihostel',
                    value: user?.inviteCode ?? '',
                    enabled: false,
                    textStyle: EzTextStyles.s12.primary.w400,
                  ),
                  Dimens.d15.verticalSpace,
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Dimens.d10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: EzButton.custom(
                isEnabled: true,
                onPressed: () {},
                textStyle: EzTextStyles.s10.primary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimens.d18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.copy, size: Dimens.d20),
                      Dimens.d16.horizontalSpace,
                      Text('Copy', style: EzTextStyles.s14.primary.w500),
                    ],
                  ),
                ),
              ),
            ),
            Dimens.d16.horizontalSpace,
            Expanded(
              child: EzButton.custom(
                isEnabled: true,
                onPressed: () {},
                textStyle: EzTextStyles.s10.primary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimens.d18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.share_sharp, size: Dimens.d20),
                      Dimens.d16.horizontalSpace,
                      Text('Chia sẻ', style: EzTextStyles.s14.primary.w500),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

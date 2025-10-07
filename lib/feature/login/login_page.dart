import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:ihostel/feature/home/home.dart';
import 'package:ihostel/feature/login/cubit/login_cubit.dart';
import 'package:ihostel/feature/navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage, LoginCubit> {
  @override
  Widget buildPage(BuildContext context, AppState state) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyScaffold),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Dimens.d10.verticalSpace,
                Align(
                  alignment: Alignment.centerRight,
                  child: EzRippleEffect(
                    borderRadius: BorderRadius.circular(Dimens.d15),
                    onPressed: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimens.d5, vertical: Dimens.d4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).iconTheme.color ?? Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(Dimens.d15),
                      ),
                      child: BlocBuilder<AppCubit, AppState>(
                        bloc: bloc.appCubit,
                        builder: (context, state) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.locate.flagEmoji, style: EzTextStyles.s12),
                              Dimens.d5.horizontalSpace,
                              Text(state.locate.languageName, style: EzTextStyles.s12.primary),
                              Dimens.d5.horizontalSpace,
                              Assets.images.arrowRight.svg(color: Theme.of(context).iconTheme.color),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Dimens.d24.verticalSpace,
                Assets.images.logo.svg(),
                Dimens.d30.verticalSpace,
                Text(
                  'IHOSTEL',
                  style: EzTextStyles.s18.primary.copyWith(fontSize: Dimens.d24.sp),
                  textAlign: TextAlign.center,
                ),
                Dimens.d30.verticalSpace,
                Text(
                  'Giải pháp quản lý chuyên nghiệp cho các khu trọ',
                  style: EzTextStyles.s14.primary.w500,
                  textAlign: TextAlign.center,
                ),
                Dimens.d15.verticalSpace,
                Text(
                  'Thông báo đóng tiền, tính tiền tự động, chi tiết, đầy đủ',
                  style: EzTextStyles.s14.primary.w500,
                  textAlign: TextAlign.center,
                ),
                Dimens.d30.verticalSpace,
                ListTileButton.svg(
                  icon: Assets.images.google.svg(),
                  onPressed: () => bloc.loginWithGoogle(callback: () => HomeRoute().go(context)),
                  title: 'Đăng nhập với Google',
                ),
                Dimens.d20.verticalSpace,
                ListTileButton.svg(
                  icon: Assets.images.apple.svg(color: Theme.of(context).iconTheme.color),
                  onPressed: () {},
                  title: 'Đăng nhập với Apple',
                ),
                Dimens.d20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.security1.svg(),
                    Dimens.d6.horizontalSpace,
                    Text(
                      'Thông tin người dùng được bảo mật',
                      style: EzTextStyles.s12.copyWith(color: const Color(0xFF00B17E)),
                    ),
                  ],
                ),
                Dimens.paddingSafeArea.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

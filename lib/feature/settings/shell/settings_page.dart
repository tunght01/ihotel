import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/feature/home/shell/cubit/home_cubit.dart';
import 'package:ihostel/feature/navigation.dart';
import 'package:ihostel/feature/settings/shell/data/settings_type.dart';
import 'package:ihostel/feature/settings/shell/widgets/item_setting_button.dart';

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SettingsPage();
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const routeName = 'settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends BasePageState<SettingsPage, HomeCubit> {
  final _appInfo = getIt<AppInfo>();
  final user = getIt<AppCubit>().localStorageDataSource.ezUser;

  @override
  Widget buildPage(BuildContext context, AppState state) {
    return Scaffold(
      appBar: EzAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cài đặt'),
            Text(
              'Hôm nay, ${DateTime.now().toFormatString(format: mediumDateFormat)}',
              style: const TextStyle(
                fontSize: Dimens.d12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: const [SyncAnimationIcon()],
      ),
      body: EzBody(
        child: SafeArea(
          child: Column(
            children: [
              InkWell(
                onTap: () => AccountDetailsRoute().pushOnLy<void>(context),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/ad_circle.svg',
                      width: 50,
                      height: 50,
                    ),
                    Dimens.verticalItem.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Bạn chưa đăng nhập',
                          ),
                          Text(
                            user?.email ?? 'Vui lòng đăng nhập để sử dụng tính năng này',
                            style: const TextStyle(
                              fontSize: Dimens.d12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: Dimens.d20, bottom: Dimens.d10),
                child: Divider(),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = SettingsType.values[index];
                    return ItemSettingButton(
                      title: item.title,
                      content: getSettingContent(item, state),
                      icon: item.icon,
                      onPressed: onPressed(item),
                      onSwitch: onSwitch(item),
                    );
                  },
                  itemCount: SettingsType.values.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void Function(bool)? onSwitch(SettingsType type) {
    if (type.isNotification) return (value) {};
    if (type.isSecurity) return (value) {};
    return null;
  }

  void Function()? onPressed(SettingsType type) {
    if (type.isLanguage) return () => LanguageRoute().pushOnLy<void>(context);
    if (type.isDarkMode) return () => DarkModeRoute().pushOnLy<void>(context);
    if (type.isSupport) return () {};
    if (type.isRefreshData) return () {};
    if (type.isTermsOfUse) return () {};
    return null;
  }

  String getSettingContent(SettingsType type, AppState state) {
    if (type.isLanguage) return state.locate.languageName;
    if (type.isDarkMode) return state.darkMode.title;
    if (type.isVersion) return _appInfo.versionName;
    return '';
  }
}

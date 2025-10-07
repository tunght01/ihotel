import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/usecase/notification_use_case.dart';
import 'package:ihostel/app/utils/date_time_utils.dart';
import 'package:ihostel/feature/home/shell/cubit/home_cubit.dart';
import 'package:ihostel/feature/member/member.dart';
import 'package:ihostel/feature/navigation.dart';

class HomeRoute extends BaseGoRouteData {
  HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage, HomeCubit> {
  late final user = bloc.appCubit.localStorageDataSource.ezUser;
  final NotificationUseCase _notificationUseCase = getIt<NotificationUseCase>();

  @override
  void initState() {
    bloc.load();
    _notificationUseCase.schedulePaymentNotifications();
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context, AppState appState) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: EzAppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Xin chào, ${user?.fullName}'),
                Dimens.d5.verticalSpace,
                Text(
                  'Hôm nay ${DateTimeUtils.getCurrentDate()}',
                  style: EzTextStyles.defaultSecondary,
                ),
              ],
            ),
            actions: [
              SyncIcon(
                icon: Icons.notifications_outlined,
                onPressed: () => NotificationRoute().pushOnLy<void>(context),
                isNotify: true,
              ),
              const SyncAnimationIcon(),
            ],
          ),
          body: EzBody(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimens.d10),
                  child: EzTextField(isSearch: true, hint: 'Tìm theo từ khóa'),
                ),
                Expanded(
                  child: EzTabBarView(
                    children: [
                      EzTabView(
                        title: 'Đang diễn ra',
                        child: HappenedTab(groups: state.groupsWorking),
                      ),
                      EzTabView(
                        title: 'Hoàn tất/Đã xóa',
                        child: const NoDataTab(
                          title: 'Chưa có khu trọ nào',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

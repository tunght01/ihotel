import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/utils/animation_utils.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:ihostel/feature/home/home.dart';
import 'package:ihostel/feature/link_account/link_account.dart';
import 'package:ihostel/feature/login/login.dart';
import 'package:ihostel/feature/member/member.dart';
import 'package:ihostel/feature/notification/notification_page.dart';
import 'package:ihostel/feature/room/room.dart';
import 'package:ihostel/feature/settings/settings.dart';
import 'package:ihostel/feature/splash/splash.dart';
import 'package:ihostel/feature/statistic/shell/statistic_page.dart';

part 'navigation.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/${SplashPage.routeName}',
  debugLogDiagnostics: kDebugMode,
  routes: $appRoutes,
  navigatorKey: rootNavigatorKey,
);

@TypedStatefulShellRoute<MyShellRouteData>(
  branches: [
    TypedStatefulShellBranch<StatefulShellBranchData>(
      routes: [
        TypedGoRoute<HomeRoute>(path: '/${HomePage.routeName}'),
      ],
    ),
    TypedStatefulShellBranch<StatefulShellBranchData>(
      routes: [
        TypedGoRoute<StatisticRoute>(path: '/${StatisticPage.routeName}'),
      ],
    ),
    TypedStatefulShellBranch<StatefulShellBranchData>(
      routes: [
        TypedGoRoute<SettingsRoute>(path: '/${SettingsPage.routeName}'),
      ],
    ),
  ],
)
class MyShellRouteData extends StatefulShellRouteData {
  const MyShellRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return BottomNavigationShellPage(navigationShell: navigationShell);
  }
}

class BottomNavigationShellPage extends StatefulWidget {
  const BottomNavigationShellPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<BottomNavigationShellPage> createState() => _BottomNavigationShellPageState();
}

class _BottomNavigationShellPageState extends State<BottomNavigationShellPage> with TickerProviderStateMixin {
  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  final listShell = [
    HomePage.routeName,
    StatisticPage.routeName,
    SettingsPage.routeName,
  ];

  late AnimationController _controller;
  late Animation<Offset> _animation;
  final bool _isShow = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _animation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SlideTransition(
        transformHitTests: false,
        position: _animation,
        child: Visibility(
          visible: _isShow,
          child: BottomBarDefault(
            items: [
              TabItem(
                child: NavigationIconSvg(
                  iconSvg: Assets.images.icOrder,
                  isSelected: 0 == widget.navigationShell.currentIndex,
                ),
                title: S.current.home,
              ),
              TabItem(
                child: NavigationIconSvg(
                  iconSvg: Assets.images.icCommodity,
                  isSelected: 1 == widget.navigationShell.currentIndex,
                ),
                title: S.current.statistical,
              ),
              TabItem(
                child: NavigationIconSvg(
                  iconSvg: Assets.images.icProfit,
                  isSelected: 2 == widget.navigationShell.currentIndex,
                ),
                title: S.current.settings,
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimens.d20),
              topRight: Radius.circular(Dimens.d20),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.current.primaryText.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
            backgroundColor: AppColors.current.backgroundNavigationBar,
            color: AppColors.current.primaryText,
            colorSelected: AppColors.current.primary,
            indexSelected: widget.navigationShell.currentIndex,
            onTap: _onTap,
          ),
        ),
      ),
    );
  }
}

class NavigationIconSvg extends StatelessWidget {
  const NavigationIconSvg({
    required this.iconSvg,
    required this.isSelected,
    super.key,
  });

  final SvgGenImage iconSvg;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return iconSvg.svg(
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.current.primary : AppColors.current.primaryText,
        BlendMode.srcIn,
      ),
    );
  }
}

@TypedGoRoute<SplashRoute>(path: '/${SplashPage.routeName}')
class SplashRoute extends BaseGoRouteData {
  SplashRoute();

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: const SplashPage(),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<LoginRoute>(path: '/${LoginPage.routeName}')
class LoginRoute extends BaseGoRouteData {
  LoginRoute();

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: const LoginPage(),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<LanguageRoute>(path: '/${LanguagePage.routeName}')
class LanguageRoute extends BaseGoRouteData {
  LanguageRoute();

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: const LanguagePage(),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<DarkModeRoute>(path: '/${DarkModePage.routeName}')
class DarkModeRoute extends BaseGoRouteData {
  DarkModeRoute();

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: const DarkModePage(),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<ListMemberRoute>(path: '/${ListMemberPage.routeName}')
class ListMemberRoute extends BaseGoRouteData {
  ListMemberRoute(this.$extra);

  final EzGroup $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: ListMemberPage(group: $extra),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<AddMemberRoute>(path: '/${AddMemberPage.routeName}')
class AddMemberRoute extends BaseGoRouteData {
  AddMemberRoute(this.$extra);

  final (EzGroup, EzGroupRoom?) $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: AddMemberPage(group: $extra.$1, room: $extra.$2),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<NotificationRoute>(path: '/${NotificationPage.routeName}')
class NotificationRoute extends BaseGoRouteData {
  NotificationRoute();

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: const NotificationPage(),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<MotelDetailRoute>(path: '/${HostelDetailPage.routeName}')
class MotelDetailRoute extends BaseGoRouteData {
  MotelDetailRoute(this.$extra);

  final EzGroup $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: HostelDetailPage(group: $extra),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<CreateHostelRoute>(path: '/${CreateHostelPage.routeName}')
class CreateHostelRoute extends BaseGoRouteData {
  CreateHostelRoute();

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: const CreateHostelPage(),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<MemberInfoRoute>(path: '/${MemberInfoPage.routeName}')
class MemberInfoRoute extends BaseGoRouteData {
  MemberInfoRoute();

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: const MemberInfoPage(),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<LinkAccountRoute>(path: '/${LinkAccountPage.routeName}')
class LinkAccountRoute extends BaseGoRouteData {
  LinkAccountRoute();

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: const LinkAccountPage(),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<RoomManagerRoute>(path: '/${RoomManagerPage.routeName}')
class RoomManagerRoute extends BaseGoRouteData {
  RoomManagerRoute(this.$extra);

  final EzGroup $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: RoomManagerPage(group: $extra),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<CreateRoomRoute>(path: '/${CreateRoomPage.routeName}')
class CreateRoomRoute extends BaseGoRouteData {
  CreateRoomRoute(this.$extra);

  final EzGroup $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: CreateRoomPage(group: $extra),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<RoomDetailsRoute>(path: '/${RoomDetailsPage.routeName}')
class RoomDetailsRoute extends BaseGoRouteData {
  RoomDetailsRoute(this.$extra);

  final EzGroupRoom $extra;

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: RoomDetailsPage(room: $extra),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

@TypedGoRoute<AccountDetailsRoute>(path: '/${AccountDetailsPage.routeName}')
class AccountDetailsRoute extends BaseGoRouteData {
  AccountDetailsRoute();

  @override
  CustomTransitionPage<void> buildPage(BuildContext context, GoRouterState state) => AnimationPage.create<void>(
        key: state.pageKey,
        child: const AccountDetailsPage(),
      );

  @override
  Future<T?> pushOnLy<T>(BuildContext? context) async {
    if (context == null) return null;
    if (router.routerDelegate.currentConfiguration.last.matchedLocation != location) {
      return push<T>(context);
    }
    return null;
  }
}

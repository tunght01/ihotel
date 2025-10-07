import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:ihostel/feature/home/shell/home_page.dart';
import 'package:ihostel/feature/navigation.dart';
import 'package:ihostel/feature/splash/cubit/splash_cubit.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = 'splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BasePageState<SplashPage, SplashCubit> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(vsync: this);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context, AppState appState) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state.isLoggedIn) {
          HomeRoute().go(context);
        } else {
          LoginRoute().go(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.current.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Lottie.asset(
            Assets.animations.splashScreen,
            controller: controller,
            onLoaded: (composition) {
              controller
                ..duration = composition.duration
                ..forward().whenComplete(bloc.load);
            },
          ),
        ),
      ),
    );
  }
}

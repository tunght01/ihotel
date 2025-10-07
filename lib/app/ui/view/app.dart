import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/feature/navigation.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _bloc = getIt<AppCubit>();

  /// Precaches the images and SVGs. This can be an expensive operation and should ideally be done
  /// at each screen, before it loads. We are doing it here since it makes the app development easier.
  /// Remove this if the app has too many images.
  Future<void> precacheImages() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final imageCachingFutures = assetManifest //
        .listAssets()
        .where(
          (assetPath) => assetPath.endsWith('.jpg') || assetPath.endsWith('.png'),
        )
        .map((assetPath) async {
      final imageProvider = AssetImage(assetPath);
      await precacheImage(imageProvider, context);
      if (mounted) {
        imageProvider.resolve(createLocalImageConfiguration(context)).addListener(
              ImageStreamListener((imageInfo, synchronousCall) {}),
            );
      }
    });

    final svgCachingFutures = assetManifest //
        .listAssets()
        .where((assetPath) => assetPath.endsWith('.svg'))
        .map((svgAsset) async {
      final loader = SvgAssetLoader(svgAsset);
      await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    });

    await Future.wait([...imageCachingFutures, ...svgCachingFutures]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImages();
  }

  @override
  void initState() {
    super.initState();
    _bloc.setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: KeyboardDismisser(
        gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
        child: BlocBuilder<AppCubit, AppState>(
          bloc: _bloc,
          builder: (context, state) => MaterialApp.router(
            builder: (context, child) {
              Dimens.of(context);
              AppColors.of(context);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                child: child ?? const SizedBox.shrink(),
              );
            },
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: state.locate,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state.darkMode.theme,
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}

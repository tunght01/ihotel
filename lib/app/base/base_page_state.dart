import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/base/base_error.dart';
import 'package:ihostel/app/widgets/snack_bar.dart';

abstract class BasePageState<T extends StatefulWidget, B extends BaseCubit> extends BasePageStateDelegate<T, B> {}

abstract class BasePageStateDelegate<T extends StatefulWidget, B extends BaseCubit> extends State<T> {
  final AppCubit appCubit = getIt<AppCubit>();

  late final CommonCubit commonCubit = getIt<CommonCubit>()..appCubit = appCubit;

  late final B bloc = getIt<B>()
    ..appCubit = appCubit
    ..commonCubit = commonCubit;

  bool get isAppWidget => false;

  void _showFlushbar(
    BuildContext context, {
    required String message,
    ExceptionType exceptionType = ExceptionType.error,
    String? title,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(context);
      switch (exceptionType) {
        case ExceptionType.error:
          EzFlushbar.showError<void>(
            overlay.context,
            title: title,
            message: message,
          );
        case ExceptionType.warning:
          EzFlushbar.showWarning<void>(
            overlay.context,
            title: title,
            message: message,
          );
        case ExceptionType.success:
          EzFlushbar.show<void>(
            overlay.context,
            title: title,
            message: message,
          );
      }
    });
  }

  void _showError(BuildContext context, String message) {
    _showFlushbar(
      context,
      message: message,
      title: 'Lưu ý',
    );
  }

  void _showWarning(BuildContext context, String message) {
    _showFlushbar(
      context,
      message: message,
      title: 'Cảnh báo',
      exceptionType: ExceptionType.warning,
    );
  }

  void _showMessage(BuildContext context, String message) {
    _showFlushbar(
      context,
      message: message,
      title: 'Thông báo',
      exceptionType: ExceptionType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => bloc),
        BlocProvider(create: (_) => commonCubit),
      ],
      child: BlocListener<CommonCubit, CommonState>(
        listener: (context, state) {
          if (state.error != null) {
            if (state.error!.exceptionType.isError) {
              _showError(context, state.error!.message);
            } else {
              _showWarning(context, state.error!.message);
            }
          } else if (state.success.isNotEmpty) {
            _showMessage(context, state.success);
          }
        },
        child: Stack(
          children: [
            BlocBuilder<AppCubit, AppState>(
              bloc: bloc.appCubit,
              builder: buildPage,
            ),
            BlocBuilder<CommonCubit, CommonState>(
              buildWhen: (previous, current) => previous.isLoading != current.isLoading,
              builder: (context, state) => Visibility(
                visible: state.isLoading,
                child: buildPageLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPageListeners({required Widget child}) => child;

  Widget buildPageLoading() => Scaffold(
        backgroundColor: Colors.transparent,
        body: ColoredBox(
          color: AppColors.current.background.withOpacity(0.3),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.d16),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d40, vertical: Dimens.d10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: Dimens.d5),
                  Text('Loading...', style: EzTextStyles.defaultSecondary),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildPage(BuildContext context, AppState appState);

  @override
  void dispose() {
    super.dispose();
  }
}

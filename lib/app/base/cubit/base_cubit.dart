import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/base/base_error.dart';

abstract class BaseCubit<S extends BaseCubitState> extends BaseCubitDelegate<S> {
  BaseCubit(super.initialState);
}

abstract class BaseCubitDelegate<S extends BaseCubitState> extends Cubit<S> {
  BaseCubitDelegate(super.initialState);

  late final AppCubit appCubit;
  late final CommonCubit _commonCubit;

  set commonCubit(CommonCubit commonCubit) {
    _commonCubit = commonCubit;
  }

  @override
  void emit(S state) {
    if (!isClosed) {
      super.emit(state);
    } else {
      Log.e('Cannot emit new state $state because $runtimeType was closed');
    }
  }

  CommonCubit get commonCubit => this is CommonCubit ? this as CommonCubit : _commonCubit;

  void showLoading() {
    _commonCubit.onLoadingVisibilityEmitted(true);
  }

  void hideLoading() {
    _commonCubit.onLoadingVisibilityEmitted(false);
  }

  void showError(BaseError error) {
    _commonCubit.onErrorVisibilityEmitted(error);
  }

  void hideError() {
    _commonCubit.onErrorVisibilityEmitted(null);
  }

  void showSuccess(String success) {
    _commonCubit.onSuccessVisibilityEmitted(success);
  }

  void hideSuccess() {
    _commonCubit.onSuccessVisibilityEmitted('');
  }

  Future<void> runCubitCatching({
    required FutureOr<void> Function() action,
    FutureOr<void> Function()? doOnSubscribe,
    FutureOr<void> Function(Exception)? doOnError,
    FutureOr<void> Function()? doOnEventCompleted,
    String success = '',
    bool handleSuccess = true,
    bool handleLoading = false,
    bool handleError = true,
  }) async {
    try {
      await doOnSubscribe?.call();
      if (handleLoading) {
        showLoading();
      }

      await action.call();

      if (handleLoading) {
        hideLoading();
      }
      if (handleSuccess) {
        showSuccess(success);
      }
    } on Exception catch (e) {
      if (handleLoading) {
        hideLoading();
      }
      if (handleError) {
        if (e is BaseError) {
          showError(e);
        } else {
          showError(BaseError(ExceptionType.error, e.toString()));
        }
        await doOnError?.call(e);
      }
    } finally {
      hideSuccess();
      hideError();
      await doOnEventCompleted?.call();
    }
  }
}

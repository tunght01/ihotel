import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/base/base_error.dart';
import 'package:injectable/injectable.dart';

part 'common_cubit.freezed.dart';

@Injectable()
class CommonCubit extends BaseCubit<CommonState> {
  CommonCubit() : super(const CommonState());

  FutureOr<void> onLoadingVisibilityEmitted(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  FutureOr<void> onErrorVisibilityEmitted(BaseError? error) {
    emit(state.copyWith(error: error));
  }

  FutureOr<void> onSuccessVisibilityEmitted(String success) {
    emit(state.copyWith(success: success));
  }
}

@freezed
sealed class CommonState extends BaseCubitState with _$CommonState {
  const factory CommonState({
    @Default(false) bool isLoading,
    BaseError? error,
    @Default('') String success,
  }) = _CommonState;
}

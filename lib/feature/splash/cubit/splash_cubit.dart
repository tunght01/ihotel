import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:injectable/injectable.dart';

part 'splash_cubit.freezed.dart';

@freezed
class SplashState extends BaseCubitState with _$SplashState {
  const factory SplashState({
    @Default(false) bool isLoggedIn,
  }) = _SplashState;
}

@injectable
class SplashCubit extends BaseCubit<SplashState> {
  SplashCubit(this._localStorageDataSource) : super(const SplashState());

  final LocalStorageDataSource _localStorageDataSource;

  Future<void> load() async {
    emit(state.copyWith(isLoggedIn: _localStorageDataSource.userId.isNotEmpty));
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:injectable/injectable.dart';

part 'dark_mode_cubit.freezed.dart';

@freezed
class DarkModeState extends BaseCubitState with _$DarkModeState {
  const factory DarkModeState() = _DarkModeState;
}

@injectable
class DarkModeCubit extends BaseCubit<DarkModeState> {
  DarkModeCubit() : super(const DarkModeState());
}

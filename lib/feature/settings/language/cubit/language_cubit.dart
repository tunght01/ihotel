import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:injectable/injectable.dart';

part 'language_cubit.freezed.dart';

@freezed
class LanguageState extends BaseCubitState with _$LanguageState {
  const factory LanguageState() = _LanguageState;
}

@injectable
class LanguageCubit extends BaseCubit<LanguageState> {
  LanguageCubit() : super(const LanguageState());
}

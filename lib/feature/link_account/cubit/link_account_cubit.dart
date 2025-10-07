import 'package:email_validator/email_validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/base/base_error.dart';
import 'package:injectable/injectable.dart';

part 'link_account_cubit.freezed.dart';

@freezed
class LinkAccountState extends BaseCubitState with _$LinkAccountState {
  const factory LinkAccountState({
    @Default(false) bool hasScannerQr,
    @Default(('', '')) (String, String) result,
  }) = _LinkAccountState;
}

@injectable
class LinkAccountCubit extends BaseCubit<LinkAccountState> {
  LinkAccountCubit() : super(const LinkAccountState());

  Future<void> updateResult(String newResult) async {
    await runCubitCatching(
      handleLoading: true,
      action: () async {
        final text = newResult.split('/');
        if (text.length == 2 && EmailValidator.validate(text.first) && text.last.length == 6) {
          emit(state.copyWith(result: (text.first, text.last)));
        } else {
          throw const BaseError(ExceptionType.error, 'Mã Qr không hợp lệ');
        }
      },
    );
  }

  void onHasScannerQr(bool value) {
    emit(state.copyWith(hasScannerQr: value));
  }
}

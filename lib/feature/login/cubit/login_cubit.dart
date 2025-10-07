import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/base/base_error.dart';
import 'package:ihostel/app/data/models/ez_user/ez_user.dart';
import 'package:ihostel/app/data/repository/ez_user/ez_user_repository.dart';
import 'package:ihostel/app/data/usecase/sync_use_case.dart';
import 'package:ihostel/app/utils/uuid_utils.dart';
import 'package:injectable/injectable.dart';

part 'login_cubit.freezed.dart';

@freezed
class LoginState extends BaseCubitState with _$LoginState {
  const factory LoginState({
    @Default('Toan') String name,
  }) = _LoginState;
}

@injectable
class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit(
    this._ezUserRepository,
    this._syncUseCase,
  ) : super(const LoginState());
  final EzUserRepository _ezUserRepository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final SyncUseCase _syncUseCase;

  FutureOr<void> loginWithGoogle({VoidCallback? callback}) async {
    await runCubitCatching(
      handleLoading: true,
      action: () async {
        try {
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult.contains(ConnectivityResult.none)) {
            throw const BaseError(ExceptionType.error, 'Mất kết nối internet vui lòng thử lại');
          } else {
            await _syncUseCase.syncUsers();
            final id = await getDeviceId();
            await googleSignIn.signOut();
            final account = await googleSignIn.signIn();
            if (account != null) {
              final googleSignInAuthentication = await account.authentication;
              final credential = GoogleAuthProvider.credential(
                accessToken: googleSignInAuthentication.accessToken,
                idToken: googleSignInAuthentication.idToken,
              );
              final authResult = await auth.signInWithCredential(credential);
              final userRemote = authResult.user;
              if (userRemote != null && !userRemote.isAnonymous) {
                final user = EzUser().convertUserFromGoogle(userRemote);
                await appCubit.localStorageDataSource.setDeviceId(id);
                await appCubit.localStorageDataSource.setUserId(user.id);
                callback?.call();
                final userLocal = _ezUserRepository.getById(user.id);
                if (userLocal == null) {
                  _ezUserRepository.insert(user);
                }
                await appCubit.localStorageDataSource.setEzUser(userLocal ?? user);
                _syncUseCase.syncAll();
              }
            }
          }
        } catch (e) {
          Log.d(e);
          throw const BaseError(ExceptionType.error, 'Có lỗi xảy ra vui lòng thử lại sau.');
        }
      },
      doOnError: (e) async => Log.d(e),
    );
  }
}

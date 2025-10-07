import 'dart:convert';
import 'dart:io';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:ihostel/app/data/models/ez_user/ez_user.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class LocalStorageDataSource {
  LocalStorageDataSource(this._sharedPreferences) : _encryptedSharedPreferences = EncryptedSharedPreferences(prefs: _sharedPreferences);
  final SharedPreferences _sharedPreferences;
  final EncryptedSharedPreferences _encryptedSharedPreferences;

  /// Must be called before the local storage can be used.
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final isFirstRun = _sharedPreferences.getBool(StorageKey.isFirstRun.name) ?? true;

    if (isFirstRun) {
      await _sharedPreferences.setBool(StorageKey.isFirstRun.name, false);
    }
  }

  String? read(StorageKey key) => _sharedPreferences.getString(key.name);

  Future<void> delete(StorageKey key) async => _sharedPreferences.remove(key.name);

  Future<void> deleteAll() async => _sharedPreferences.clear();

  Future<void> setUserId(String id) async {
    await _sharedPreferences.setString(StorageKey.userId.name, id);
  }

  String get userId => read(StorageKey.userId) ?? '';

  Future<void> setStorageVersion(int id) async {
    await _sharedPreferences.setString(StorageKey.storageVersion.name, id.toString());
  }

  int get storageVersion => int.tryParse(read(StorageKey.storageVersion) ?? '0') ?? 0;

  Future<void> setDeviceId(String id) async {
    await _sharedPreferences.setString(StorageKey.deviceId.name, id);
  }

  String get deviceId => read(StorageKey.deviceId) ?? '';

  Future<void> saveAccessToken(String accessToken) async {
    await _encryptedSharedPreferences.setString(
      StorageKey.accessToken.name,
      accessToken,
    );
  }

  Future<String> get accessToken {
    return _encryptedSharedPreferences.getString(StorageKey.accessToken.name);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _encryptedSharedPreferences.setString(
      StorageKey.refreshToken.name,
      refreshToken,
    );
  }

  Future<String> get refreshToken {
    return _encryptedSharedPreferences.getString(StorageKey.refreshToken.name);
  }

  Future<void> setDarkMode(String value) async {
    await _sharedPreferences.setString(StorageKey.darkMode.name, value);
  }

  String get darkMode => read(StorageKey.darkMode) ?? '';

  Future<void> setLanguageCode(String value) async {
    await _sharedPreferences.setString(StorageKey.languageCode.name, value);
  }

  String get languageCode => read(StorageKey.languageCode) ?? Platform.localeName;

  Future<void> setEzUser(EzUser? user) async {
    await _sharedPreferences.setString(StorageKey.ezUser.name, jsonEncode(user?.toJson() ?? ''));
  }

  EzUser? get ezUser {
    final user = read(StorageKey.ezUser) ?? '';
    if (user.isEmpty) {
      return null;
    } else {
      return EzUser.fromJson(jsonDecode(user) as Map<String, dynamic>);
    }
  }

  Future<void> setFcmToken(String id) async {
    await _sharedPreferences.setString(StorageKey.fcmToken.name, id);
  }

  String get fcmToken => read(StorageKey.fcmToken) ?? '';

  Future<void> setNotificationEnabled(bool value) async {
    await _sharedPreferences.setString(StorageKey.notificationEnabled.name, value ? '1' : '0');
  }

  //default = true
  bool get notificationEnabled => (read(StorageKey.notificationEnabled) ?? '1') == '1';
}

enum StorageKey {
  isFirstRun,
  storageVersion,
  languageCode,
  darkMode,
  notificationEnabled,
  refreshToken,
  accessToken,
  userId,
  deviceId,
  ezUser,
  fcmToken,
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/shared/gen_code.dart';
import 'package:isar/isar.dart';

part 'ez_user.g.dart';

enum AuthType { apple, google }

@collection
@JsonSerializable()
class EzUser extends BaseModel<EzUser> {
  EzUser({
    this.email = '',
    this.phone = '',
    this.authType = '',
    this.socialToken = '',
    this.socialId = '',
    this.avatar = '',
    this.birthday,
    this.firstName = '',
    this.lastName = '',
    this.gender = true,
    this.status = '',
    this.inviteCode = '',
    this.language = '',
    this.appColor = '',
    super.id,
    super.created,
    super.updated,
    super.syncedTime,
    super.isDeleted,
    super.isSynced,
    super.isSyncedFlag,
  }) : super();

  factory EzUser.fromJson(Map<String, dynamic> json) => _$EzUserFromJson(json);

  String email;
  String phone;
  String authType;
  String socialToken;
  String socialId;
  String avatar;
  DateTime? birthday;
  String firstName;
  String lastName;
  bool gender;
  String status;
  String inviteCode;
  String language;
  String appColor;

  @ignore
  DateTime get getBirthday => birthday ??= DateTime.now();

  @ignore
  String get fullName => '$firstName $lastName'.trim();

  EzUser convertUserFromGoogle(User userGoogle) {
    final user = EzUser().copyWith(
      id: userGoogle.uid,
      firstName: userGoogle.displayName,
      email: userGoogle.email,
      authType: AuthType.google.name,
      socialId: userGoogle.uid,
      avatar: userGoogle.photoURL,
      inviteCode: EzGenCode.gen(),
    );

    return user;
  }

  @override
  EzUser convertUtc() => clone();

  @override
  EzUser toObject(Map<String, dynamic> json) => EzUser.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EzUserToJson(this);

  @override
  EzUser copyWith({
    String? email,
    String? phone,
    String? authType,
    String? socialToken,
    String? socialId,
    String? avatar,
    DateTime? birthday,
    String? firstName,
    String? lastName,
    bool? gender,
    String? status,
    String? inviteCode,
    String? language,
    String? appColor,
    String? id,
    DateTime? created,
    DateTime? updated,
    DateTime? syncedTime,
    bool? isSynced,
    bool? isDeleted,
    bool? isSyncedFlag,
  }) {
    return super.copyWith(
      id: id,
      created: created,
      updated: updated,
      syncedTime: syncedTime,
      isSynced: isSynced,
      isDeleted: isDeleted,
      isSyncedFlag: isSyncedFlag,
    )
      ..email = email ?? this.email
      ..phone = phone ?? this.phone
      ..authType = authType ?? this.authType
      ..socialToken = socialToken ?? this.socialToken
      ..socialId = socialId ?? this.socialId
      ..avatar = avatar ?? this.avatar
      ..birthday = birthday ?? this.birthday
      ..firstName = firstName ?? this.firstName
      ..lastName = lastName ?? this.lastName
      ..gender = gender ?? this.gender
      ..status = status ?? this.status
      ..inviteCode = inviteCode ?? this.inviteCode
      ..language = language ?? this.language
      ..appColor = appColor ?? this.appColor;
  }
}

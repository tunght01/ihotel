import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:isar/isar.dart';

part 'ez_group_room_user.g.dart';

@collection
@JsonSerializable()
class EzGroupRoomUser extends BaseModel<EzGroupRoomUser> {
  EzGroupRoomUser({
    this.groupId = '',
    this.groupRoomId = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.linkedUserId = '',
    this.role = '',
    this.type = '',
    this.startDate = 1,
    this.endDate = 0,
    this.birthDay,
    this.creatorId = '',
    super.id,
    super.created,
    super.updated,
    super.syncedTime,
    super.isDeleted,
    super.isSynced,
    super.isSyncedFlag,
  });

  factory EzGroupRoomUser.fromJson(Map<String, dynamic> json) => _$EzGroupRoomUserFromJson(json);

  String groupId;
  String groupRoomId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String linkedUserId;
  String role;
  String type;
  int startDate;
  int endDate;
  DateTime? birthDay;
  String creatorId;

  @ignore
  DateTime get getBirthday => birthDay ??= DateTime.now();

  @ignore
  String get fullName => '$firstName $lastName'.trim();

  @override
  EzGroupRoomUser toObject(Map<String, dynamic> json) => EzGroupRoomUser.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EzGroupRoomUserToJson(this);

  @override
  EzGroupRoomUser convertUtc() => clone();

  @override
  EzGroupRoomUser copyWith({
    String? id,
    DateTime? created,
    DateTime? updated,
    DateTime? syncedTime,
    bool? isSynced,
    bool? isDeleted,
    bool? isSyncedFlag,
    String? groupId,
    String? groupRoomId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? linkedUserId,
    String? role,
    String? type,
    int? startDate,
    int? endDate,
    DateTime? birthDay,
    String? creatorId,
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
      ..groupId = groupId ?? this.groupId
      ..groupRoomId = groupRoomId ?? this.groupRoomId
      ..firstName = firstName ?? this.firstName
      ..lastName = lastName ?? this.lastName
      ..email = email ?? this.email
      ..phone = phone ?? this.phone
      ..linkedUserId = linkedUserId ?? this.linkedUserId
      ..role = role ?? this.role
      ..type = type ?? this.type
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..birthDay = birthDay ?? this.birthDay
      ..creatorId = creatorId ?? this.creatorId;
  }
}

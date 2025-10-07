import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:isar/isar.dart';

part 'ez_group_room.g.dart';

@collection
@JsonSerializable()
class EzGroupRoom extends BaseModel<EzGroupRoom> {
  EzGroupRoom({
    this.groupId = '',
    this.name = '',
    this.status = '',
    this.rate = 0,
    this.startDate = 1,
    this.discount = 0,
    this.price = 0,
    this.maxMember = 0,
    this.creatorId = '',
    super.id,
    super.created,
    super.updated,
    super.syncedTime,
    super.isDeleted,
    super.isSynced,
    super.isSyncedFlag,
  });

  factory EzGroupRoom.fromJson(Map<String, dynamic> json) => _$EzGroupRoomFromJson(json);

  String groupId = '';
  String name = '';
  String status = '';
  double rate = 0;
  int startDate;
  double discount = 0;
  double price = 0;
  double maxMember = 0;
  String creatorId;

  @override
  EzGroupRoom toObject(Map<String, dynamic> json) => EzGroupRoom.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EzGroupRoomToJson(this);

  @override
  EzGroupRoom convertUtc() => clone();
}

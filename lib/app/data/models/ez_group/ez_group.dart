import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';
import 'package:isar/isar.dart';

part 'ez_group.g.dart';

@collection
@JsonSerializable()
class EzGroup extends BaseModel<EzGroup> {
  EzGroup({
    this.name = '',
    this.status = '',
    this.creatorId = '',
    this.avatar = '',
    this.currency = '',
    this.paymentDate = 1,
    super.id,
    super.created,
    super.updated,
    super.syncedTime,
    super.isDeleted,
    super.isSynced,
    super.isSyncedFlag,
  });

  factory EzGroup.fromJson(Map<String, dynamic> json) => _$EzGroupFromJson(json);
  String name;
  String status;
  String creatorId;
  String avatar;
  String currency;
  int paymentDate;

  @override
  EzGroup toObject(Map<String, dynamic> json) => EzGroup.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EzGroupToJson(this);

  @override
  EzGroup convertUtc() => clone();
}

import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/shared/gen_code.dart';
import 'package:isar/isar.dart';

abstract class BaseModel<T extends BaseModel<T>> {
  BaseModel({
    this.id = '',
    this.created,
    this.updated,
    this.syncedTime,
    this.isSynced = false,
    this.isDeleted = false,
    this.isSyncedFlag = false,
  }) {
    if (this.id.isEmpty) this.id = EzGenCode.genUniqueStringKey();
    this.created ??= DateTime.now();
    this.updated ??= DateTime.now();
    this.syncedTime ??= DateTime.now();
  }

  Id get isarId => id.fastHash();

  String id;
  DateTime? created;
  DateTime? updated;
  DateTime? syncedTime;
  bool isSynced;
  bool isDeleted;
  bool isSyncedFlag;

  @ignore
  DateTime get getCreated => created ??= DateTime.now();

  @ignore
  DateTime get getUpdated => updated ??= DateTime.now();

  @ignore
  DateTime get getSyncedTime => syncedTime ??= DateTime.now();

  Map<String, dynamic> toJson();

  T toObject(Map<String, dynamic> json);

  T clone() {
    final originalJson = this.toJson();
    final clonedObject = toObject(originalJson);
    return clonedObject;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  T copyWith({
    String? id,
    DateTime? created,
    DateTime? updated,
    DateTime? syncedTime,
    bool? isSynced,
    bool? isDeleted,
    bool? isSyncedFlag,
  }) {
    final result = clone()
      ..id = id ?? this.id
      ..created = created ?? this.created
      ..updated = updated ?? this.updated
      ..syncedTime = syncedTime ?? this.syncedTime
      ..isSynced = isSynced ?? this.isSynced
      ..isDeleted = isDeleted ?? this.isDeleted
      ..isSyncedFlag = isSyncedFlag ?? this.isSyncedFlag;
    return result;
  }

  T convertUtc();
}

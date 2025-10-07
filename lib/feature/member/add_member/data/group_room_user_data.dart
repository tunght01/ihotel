import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_user/ez_user.dart';
import 'package:ihostel/app/shared/gen_code.dart';

class GroupRoomUserData {
  GroupRoomUserData({
    this.id = '',
    this.firstName = '',
    this.numberPhone = '',
    this.room,
    this.user,
  }) {
    if (id.isEmpty) id = EzGenCode.genUniqueStringKey();
  }

  String id;
  String firstName;
  String numberPhone;
  EzGroupRoom? room;
  EzUser? user;

  GroupRoomUserData copyWith({
    String? id,
    String? firstName,
    String? numberPhone,
    EzGroupRoom? room,
    EzUser? user,
  }) {
    return this
      ..id = id ?? this.id
      ..firstName = firstName ?? this.firstName
      ..numberPhone = numberPhone ?? this.numberPhone
      ..room = room ?? this.room
      ..user = user ?? this.user;
  }
}

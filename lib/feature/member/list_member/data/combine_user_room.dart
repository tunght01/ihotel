import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';

class CombineUserRoom {
  const CombineUserRoom({
    this.room,
    this.groupRoomUser,
  });

  final EzGroupRoomUser? groupRoomUser;
  final EzGroupRoom? room;
}

import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';

class CombineRoom {
  const CombineRoom({
    required this.room,
    this.members = const [],
  });

  final EzGroupRoom room;
  final List<EzGroupRoomUser> members;
}

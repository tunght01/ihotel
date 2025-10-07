import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';

class CombineHostel {
  const CombineHostel({
    required this.group,
    this.rooms = const [],
    this.members = const [],
  });

  final EzGroup group;
  final List<EzGroupRoom> rooms;
  final List<EzGroupRoomUser> members;
}

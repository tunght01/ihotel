import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/feature/room/room.dart';
import 'package:ihostel/feature/room/room_manager/data/combine_room.dart';

class AreStayingTab extends StatelessWidget {
  const AreStayingTab({
    this.rooms = const [],
    super.key,
  });

  final List<CombineRoom> rooms;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (rooms.isEmpty) const NoDataWidget(message: 'Chưa có phòng nào được sử dụng'),
        if (rooms.isNotEmpty)
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: Dimens.d20, bottom: Dimens.paddingSafeArea),
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = rooms[index];
                  return RoomItem(
                    room: item.room,
                    members: item.members,
                  );
                },
                separatorBuilder: (context, index) => Dimens.verticalItem.verticalSpace,
                itemCount: rooms.length,
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';
import 'package:ihostel/feature/navigation.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({
    required this.room,
    this.members = const [],
    super.key,
  });

  final EzGroupRoom room;
  final List<EzGroupRoomUser> members;

  @override
  Widget build(BuildContext context) {
    return EzCard(
      borderRadius: BorderRadius.circular(Dimens.d10),
      onTap: () => RoomDetailsRoute(room).pushOnLy<void>(context),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.room_preferences_outlined,
                      size: Dimens.d20.sp,
                      color: AppColors.current.primary,
                    ),
                    Dimens.d8.horizontalSpace,
                    Expanded(
                      child: Text(
                        room.name,
                        style: EzTextStyles.s14.primary.copyWith(
                          color: AppColors.current.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const EzPill.information(title: 'Chi tiết'),
            ],
          ),
          Dimens.verticalContentItem.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline_outlined,
                      size: Dimens.d18.sp,
                    ),
                    Dimens.d5.horizontalSpace,
                    Flexible(
                      child: Text(
                        '${members.length} thành viên',
                        style: EzTextStyles.s12.primary.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on_outlined,
                      size: Dimens.d18.sp,
                    ),
                    Dimens.d5.horizontalSpace,
                    Flexible(
                      child: Text(
                        '${room.price.toCurrencyInfinity()}/tháng',
                        style: EzTextStyles.s12.primary.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Dimens.verticalContentItem.verticalSpace,
          Row(
            children: [
              Icon(
                Icons.calendar_month_sharp,
                size: Dimens.d18.sp,
              ),
              Dimens.d5.horizontalSpace,
              Flexible(
                child: Text(
                  DateTime.now().copyWith(day: room.startDate).toFormatString(format: 'dd/MM/yyyy'),
                  style: EzTextStyles.s12.primary.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

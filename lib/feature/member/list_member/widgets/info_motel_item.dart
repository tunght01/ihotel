import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/data/models/ez_group_room/ez_group_room.dart';
import 'package:ihostel/app/data/models/ez_group_room_user/ez_group_room_user.dart';

class InfoMotelItem extends StatelessWidget {
  const InfoMotelItem({
    required this.group,
    this.rooms = const [],
    this.members = const [],
    this.onTap,
    super.key,
  });

  final EzGroup group;
  final List<EzGroupRoom> rooms;
  final List<EzGroupRoomUser> members;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final amount = 0.0;
    return EzCard(
      borderRadius: BorderRadius.circular(Dimens.d10),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: EzTextStyles.s14.primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Dimens.d8.verticalSpace,
              const EzPill.information(title: 'Đang diễn ra'),
            ],
          ),
          Dimens.verticalContentItem.verticalSpace,
          Text(
            'Ngày đóng phí: ${DateTime.now().copyWith(day: group.paymentDate, month: DateTime.now().month + 1).toFormatString(format: 'dd/MM/yyyy')}',
            style: EzTextStyles.s12.secondary.w400,
            overflow: TextOverflow.ellipsis,
          ),
          Dimens.verticalContentItem.verticalSpace,
          Row(
            children: [
              const Icon(Icons.room_preferences_outlined, size: Dimens.d18),
              Dimens.d5.horizontalSpace,
              Expanded(
                child: Text(
                  '${rooms.length} phòng',
                  style: EzTextStyles.s12.primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Dimens.d8.horizontalSpace,
              const Icon(Icons.account_circle_outlined, size: Dimens.d18),
              Dimens.d5.horizontalSpace,
              Expanded(
                child: Text(
                  '${members.length} thành viên',
                  style: EzTextStyles.s12.primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Dimens.verticalContentItem.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on_outlined, size: Dimens.d18),
                    Dimens.d5.horizontalSpace,
                    Expanded(
                      child: Text(
                        amount.toCurrencyInfinity(),
                        style: EzTextStyles.s12.primary,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: Dimens.d15),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:ihostel/feature/member/list_member/data/combine_user_room.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({required this.roomUser, super.key});
  final CombineUserRoom roomUser;

  @override
  Widget build(BuildContext context) {
    return EzCard(
      borderRadius: BorderRadius.circular(Dimens.d10),
      onTap: () {},
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.current.primary.withOpacity(0.5),
                      child: Text('TH', style: EzTextStyles.s16.primary.w600),
                    ),
                    Dimens.d8.horizontalSpace,
                    Expanded(
                      child: Text(
                        (roomUser.groupRoomUser!.lastName.isNotEmpty) ? ((roomUser.groupRoomUser?.firstName ?? '') + (roomUser.groupRoomUser?.lastName ?? '')) : (roomUser.groupRoomUser?.firstName ?? ''),
                        style: EzTextStyles.s14.primary.copyWith(
                          color: AppColors.current.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Assets.images.icFingerScan.svg(
                width: Dimens.d24.w,
                height: Dimens.d24.h,
              ),
            ],
          ),
          Dimens.verticalContentItem.verticalSpace,
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.person_pin_outlined,
                      size: Dimens.d18.sp,
                    ),
                    Dimens.d5.horizontalSpace,
                    Flexible(
                      child: Text(
                        roomUser.room?.name ?? '',
                        style: EzTextStyles.s12.primary.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Row(
                  children: [
                    Icon(
                      Icons.monetization_on_outlined,
                      size: Dimens.d18.sp,
                    ),
                    Dimens.d5.horizontalSpace,
                    Flexible(
                      child: Text(
                        (roomUser.room?.price ?? 0).toCurrencyInfinity(),
                        style: EzTextStyles.s12.primary.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const EzPill.information(title: 'Chi tiết'),
            ],
          ),
        ],
      ),
    );
  }
}

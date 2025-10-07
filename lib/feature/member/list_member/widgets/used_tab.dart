import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/feature/member/list_member/data/combine_user_room.dart';
import 'package:ihostel/feature/member/list_member/widgets/member_item.dart';

class UsedTab extends StatefulWidget {
  const UsedTab({required this.roomUser, super.key});
  final List<CombineUserRoom> roomUser;

  @override
  State<UsedTab> createState() => _HappenedPageState();
}

class _HappenedPageState extends State<UsedTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.roomUser.isEmpty) const NoDataWidget(message: 'Khu trọ chưa có người thuê'),
        if (widget.roomUser.isNotEmpty) ...[
          Dimens.d2.verticalSpace,
          ListView.separated(
            itemCount: widget.roomUser.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = widget.roomUser[index];
              return MemberItem(
                roomUser: item,
              );
            },
            separatorBuilder: (context, index) => Dimens.verticalItem.verticalSpace,
          ),
        ],
      ],
    );
  }
}

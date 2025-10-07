import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/feature/member/list_member/data/combine_user_room.dart';
import 'package:ihostel/feature/member/list_member/widgets/member_item.dart';

class DiscontinueTab extends StatefulWidget {
  const DiscontinueTab({required this.roomUser, super.key});
  final List<CombineUserRoom> roomUser;

  @override
  State<DiscontinueTab> createState() => _DiscontinueTabState();
}

class _DiscontinueTabState extends State<DiscontinueTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.roomUser.isEmpty) const NoDataWidget(message: 'Chưa có thành viên nào ngừng sử dụng'),
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

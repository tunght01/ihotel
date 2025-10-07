import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/feature/home/shell/data/combine_hostel.dart';
import 'package:ihostel/feature/member/member.dart';
import 'package:ihostel/feature/navigation.dart';

class HappenedTab extends StatefulWidget {
  HappenedTab({
    this.groups = const [],
    super.key,
  }) {
    // TODO(Hoang): review
  }

  final List<CombineHostel> groups;

  @override
  State<HappenedTab> createState() => _HappenedTabState();
}

class _HappenedTabState extends State<HappenedTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.groups.isEmpty)
          NoDataTab(
            title: 'Tạo khu trọ',
            onTap: () => CreateHostelRoute().pushOnLy<void>(context),
          ),
        if (widget.groups.isNotEmpty) ...[
          Dimens.d7.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Khu trọ(${widget.groups.length})', style: EzTextStyles.s16),
              EzIconButton(
                child: const Icon(Icons.add_circle_outline),
                onPressed: () => CreateHostelRoute().pushOnLy<void>(context),
              ),
            ],
          ),
          Dimens.d2.verticalSpace,
          ListView.separated(
            itemCount: widget.groups.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = widget.groups[index];
              return InfoMotelItem(
                group: item.group,
                members: item.members,
                rooms: item.rooms,
                onTap: () => MotelDetailRoute(item.group).push<void>(context),
              );
            },
            separatorBuilder: (context, index) => Dimens.verticalItem.verticalSpace,
          ),
        ],
      ],
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_group/ez_group.dart';
import 'package:ihostel/app/widgets/calendar_view.dart';
import 'package:ihostel/app/widgets/dynamic_height_gid_view.dart';
import 'package:ihostel/feature/home/hostel_detail/data/function_button_type.dart';
import 'package:ihostel/feature/home/hostel_detail/data/hostel_detail_type.dart';
import 'package:ihostel/feature/home/hostel_detail/widget/button_function_item.dart';
import 'package:ihostel/feature/home/hostel_detail/widget/financial_receivables_item.dart';
import 'package:ihostel/feature/navigation.dart';

class HostelDetailPage extends StatefulWidget {
  const HostelDetailPage({required this.group, super.key});

  static const routeName = 'hostel_detail';
  final EzGroup group;

  @override
  State<HostelDetailPage> createState() => _HostelDetailPageState();
}

class _HostelDetailPageState extends State<HostelDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EzAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.group.name),
            Dimens.d5.verticalSpace,
            Text('${DateTime.now().copyWith(day: widget.group.paymentDate).toFormatString(format: 'dd/MM/yy')} - ${DateTime.now().copyWith(day: widget.group.paymentDate).nextMonth().subtract(const Duration(days: 1)).toFormatString(format: 'dd/MM/yy')}', style: EzTextStyles.s12.secondary.w400),
          ],
        ),
        actions: [
          SyncIcon(icon: Icons.filter_alt_outlined, onPressed: () {}),
          SyncIcon(icon: Icons.settings_outlined, onPressed: () {}),
        ],
      ),
      body: EzBody(
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverList.list(
              children: [
                Dimens.d15.verticalSpace,
                EzCard(
                  borderRadius: BorderRadius.circular(Dimens.d10),
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d16),
                  child: Column(
                    children: List.generate(
                      HostelDetailType.values.length,
                      (index) {
                        final item = HostelDetailType.values[index];
                        return FinancialReceivablesItem(
                          title: item.title,
                          money: getMotelDetailContent(item),
                          hasDivider: item != HostelDetailType.values.last,
                        );
                      },
                    ),
                  ),
                ),
                Dimens.d15.verticalSpace,
                Text(
                  'Chức năng',
                  style: EzTextStyles.s14.primary,
                ),
                Dimens.d10.verticalSpace,
                DynamicHeightGridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  itemCount: 5,
                  builder: (context, index) {
                    final item = FunctionButtonType.values[index];
                    return ButtonFunctionItem(
                      icon: item.icon,
                      title: item.title,
                      onTap: onPressed(item),
                    );
                  },
                ),
                Dimens.d10.verticalSpace,
                CalendarView(
                  startOfMonth: DateTime.now().copyWith(day: widget.group.paymentDate).startOfDate(),
                  endOfMonth: DateTime.now().copyWith(day: widget.group.paymentDate).nextMonth().subtract(const Duration(days: 1)).endOfDate(),
                  selectedDays: [DateTime.now().subtract(const Duration(days: 1))],
                  hasDataDayList: const [23],
                  overlayBuilder: (date, isOutOfRange) {
                    if (isOutOfRange) return null;
                    final data = [55, 66];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(
                              min(2, data.length),
                              (index) => Text(
                                data[index].toString(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: [
                                    AppColors.current.primary,
                                    AppColors.current.error,
                                  ][index],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TODO(Tung): AppState state
  String getMotelDetailContent(HostelDetailType type) {
    if (type.isReceivable) return '0';
    if (type.isRevenue) return '0';
    return '';
  }

  void Function() onPressed(FunctionButtonType type) {
    if (type.isCashAudit) return () {};
    if (type.isMemberList) return () => ListMemberRoute(widget.group).pushOnLy<void>(context);
    if (type.isRoomManagement) return () => RoomManagerRoute(widget.group).pushOnLy<void>(context);
    if (type.isProfitManagement) return () {};
    if (type.isExportToExcel) return () {};
    return () {};
  }
}

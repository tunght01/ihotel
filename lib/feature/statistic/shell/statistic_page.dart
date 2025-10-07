import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/widgets/calendar_view.dart';

class StatisticRoute extends GoRouteData {
  const StatisticRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const StatisticPage();
}

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  static const routeName = 'statistic';

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EzAppBar(
        title: CircleAvatar(child: Text('TH')),
      ),
      body: Column(
        children: [
          CalendarView(
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
          EzButton.custom(
            isEnabled: true,
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text('+ Thành viên', style: EzTextStyles.s14.copyWith(color: Colors.white)),
                  Dimens.d5.verticalSpace,
                  Text('Mới hoàn toàn', style: EzTextStyles.s12.w400.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_calender/enums/time_zone.dart';
import 'package:full_calender/full_calender.dart';
import 'package:full_calender/full_calender_extension.dart';
import 'package:full_calender/models/lunar_date_time.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/utils/date_time_utils.dart';

class CalendarView extends StatefulWidget {
  CalendarView({
    super.key,
    DateTime? startOfMonth,
    DateTime? endOfMonth,
    this.isLunarCalendar = false,
    this.selectedDays = const [],
    this.header,
    this.onDateSelectedChange,
    this.isShowAllDates = true,
    this.backgroundBuilder,
    this.overlayBuilder,
    this.onNextMonthTapped,
    this.onPreviousMonthTapped,
    this.onMonthChanged,
    this.hasDataDayList = const [],
    this.topRightButtonTap,
    this.topRightString = '',
    this.isPersonalView = false,
    this.onCollapse,
  })  : startOfMonth = startOfMonth ??
            FullCalender(
              date: DateTime.now(),
              timeZone: TimeZone.vietnamese.timezone,
            ).startOfMonth(isLunarCalendar: isLunarCalendar).date,
        endOfMonth = endOfMonth ??
            FullCalender(
              date: DateTime.now(),
              timeZone: TimeZone.vietnamese.timezone,
            ).endOfMonth(isLunarCalendar: isLunarCalendar).date;
  final DateTime startOfMonth;
  final DateTime endOfMonth;
  final List<DateTime> selectedDays;
  final bool isLunarCalendar;
  final VoidCallback? onNextMonthTapped;
  final VoidCallback? onPreviousMonthTapped;
  final ValueChanged<DateTime>? onMonthChanged;
  final ValueChanged<DateTime>? onDateSelectedChange;
  final Widget? header;
  final bool isShowAllDates;
  final Widget? Function(DateTime date, bool isOutOfRange)? backgroundBuilder;
  final Widget? Function(DateTime date, bool isOutOfRange)? overlayBuilder;
  final List<int> hasDataDayList;
  final VoidCallback? topRightButtonTap;
  final String topRightString;
  final bool isPersonalView;
  final VoidCallback? onCollapse;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late FullCalender _currentMonth;
  bool isLunarCalendar = false;

  @override
  void initState() {
    _currentMonth = FullCalender(
      date: widget.startOfMonth,
      timeZone: TimeZone.vietnamese.timezone,
    );
    isLunarCalendar = widget.isLunarCalendar;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CalendarView oldWidget) {
    _currentMonth = FullCalender(
      date: widget.startOfMonth,
      timeZone: TimeZone.vietnamese.timezone,
    );
    isLunarCalendar = widget.isLunarCalendar;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = DateTimeUtils.getWeekDaysTitle();
    final totalDays = widget.endOfMonth.diffDays(widget.startOfMonth) + widget.startOfMonth.weekday - DateTime.monday + DateTime.sunday - widget.endOfMonth.weekday + 1;
    final startIndex = widget.startOfMonth.weekday - DateTime.monday;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.current.backgroundTextField,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              EzRippleEffect(
                onPressed: widget.onPreviousMonthTapped,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              EzRippleEffect(
                onPressed: _showYearMonthPicker,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        _currentMonth.date
                            .monthYearString(
                              format: 'MMMM/yyyy',
                              isLunarCalendar: isLunarCalendar,
                            )
                            .capitalizeFirstCharacter(),
                        style: EzTextStyles.s12.primary.w700,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CustomPaint(
                        painter: LineDashedPainter(Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ],
                ),
              ),
              EzRippleEffect(
                onPressed: widget.onNextMonthTapped,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              if (widget.isPersonalView)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EzPill.information(
                        title: 'Thu gọn',
                        onPressed: () {
                          widget.onCollapse?.call();
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (widget.header != null) widget.header!,
          const SizedBox(height: 15),
          Row(
            children: List.generate(weekDays.length, (index) {
              return Expanded(
                child: Center(
                  child: Text(
                    weekDays[index],
                    style: EzTextStyles.s14.copyWith(
                      color: AppColors.current.disabledText,
                    ),
                  ),
                ),
              );
            }),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: DateTime.daysPerWeek,
            ),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 5),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalDays,
            itemBuilder: (context, index) {
              final date = FullCalender(
                date: widget.startOfMonth.add(Duration(days: index - startIndex)),
                timeZone: TimeZone.vietnamese.timezone,
              );
              final dateNumber = isLunarCalendar ? date.lunarDate.day : date.date.day;
              final isToday = date.date.isSameDate(DateTime.now());
              final isSelected = widget.selectedDays.any((e) => e.isSameDate(date.date));

              final isOutOfRange = index < startIndex || date.date.startOfDate().isAfter(widget.endOfMonth.startOfDate());
              if (!widget.isShowAllDates && isOutOfRange) {
                return const SizedBox.shrink();
              }
              final dateCheck = isLunarCalendar ? DateTime(date.lunarDate.year, date.lunarDate.month, date.lunarDate.day) : date.date;
              return _CalendarCell(
                date: dateNumber,
                isSelected: isSelected,
                isToday: isToday,
                isEnabled: !isOutOfRange,
                cells: [
                  AppColors.current.disabledText.withOpacity(0.5),
                  AppColors.current.background,
                  AppColors.current.warning,
                ],
                overlay: widget.hasDataDayList.contains(dateNumber) ? widget.overlayBuilder?.call(dateCheck, isOutOfRange) : null,
                background: widget.backgroundBuilder?.call(date.date, isOutOfRange),
                onTap: () {
                  setState(() {
                    widget.onDateSelectedChange?.call(date.date);
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showYearMonthPicker() async {
    final selection = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => SizedBox(
        height: 232,
        child: DateTimePickerSelection(
          title: '',
          selectedDate: _currentMonth.date,
          isLunarCalendar: widget.isLunarCalendar,
        ),
      ),
    );
    if (context.mounted && selection != null) {
      widget.onMonthChanged?.call(selection);
    }
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
    required this.date,
    this.cells = const [],
    this.isSelected = false,
    this.isToday = false,
    this.isEnabled = true,
    this.overlay,
    this.background,
    this.onTap,
  });

  final int date;

  final List<Color> cells;
  final bool isSelected;
  final bool isToday;
  final bool isEnabled;
  final VoidCallback? onTap;
  final Widget? overlay;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    return EzRippleEffect(
      onPressed: isEnabled ? () => onTap?.call() : null,
      child: Stack(
        children: [
          if (background != null) SizedBox.expand(child: background),
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday && isSelected && isEnabled
                    ? AppColors.current.warning
                    : isSelected && isEnabled
                        ? AppColors.current.primaryText
                        : Colors.transparent,
              ),
              constraints: const BoxConstraints(minWidth: 24),
              padding: const EdgeInsets.all(4),
              child: Text(
                '$date',
                textAlign: TextAlign.center,
                style: EzTextStyles.s14.primary.w700.copyWith(
                  color: !isEnabled
                      ? cells[0]
                      : isSelected
                          ? cells[1]
                          : isToday
                              ? cells[2]
                              : null,
                ),
              ),
            ),
          ),
          if (overlay != null) overlay!,
        ],
      ),
    );
  }
}

class LineDashedPainter extends CustomPainter {
  const LineDashedPainter(this.color);

  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1;
    if (color != null) {
      paint.color = color!;
    }
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    var startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      const space = dashSpace + dashWidth;
      startX += space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DateTimePickerSelection extends StatefulWidget {
  const DateTimePickerSelection({
    required this.title,
    required this.isLunarCalendar,
    super.key,
    this.selectedDate,
  });

  final String title;
  final DateTime? selectedDate;
  final bool isLunarCalendar;

  @override
  State<DateTimePickerSelection> createState() => _DateTimePickerSelectionState();
}

class _DateTimePickerSelectionState extends State<DateTimePickerSelection> {
  var _selectedDate = FullCalender.now(TimeZone.vietnamese.timezone);
  late final List<int> _years;
  List<int> _months = List.generate(12, (index) => index + 1);

  final _kItemExtent = 32.0;

  @override
  void initState() {
    _selectedDate = FullCalender(
      date: widget.selectedDate ?? DateTime.now(),
      timeZone: TimeZone.vietnamese.timezone,
    );

    final maxYear = (widget.isLunarCalendar ? _selectedDate.lunarDate.year : _selectedDate.date.year) + 1;
    _years = List.generate(50, (index) => maxYear - index).reversed.toList();
    _loadMonths();
    super.initState();
  }

  void _loadMonths() {
    if (widget.isLunarCalendar) {
      final selectedLunarDate = _selectedDate.lunarDate;
      var date = FullCalender(
        date: FullCalenderExtension.convertLunarDateToSolarDate(
          LunarDateTime(year: selectedLunarDate.year, month: 1, day: 1),
        )!,
        timeZone: TimeZone.vietnamese.timezone,
      );
      _months = [];
      while (date.lunarDate.year == selectedLunarDate.year) {
        _months.add(date.lunarDate.month);
        date = date.nextMonth(isLunarCalendar: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lunarDate = _selectedDate.lunarDate;
    final selectedYear = widget.isLunarCalendar ? lunarDate.year : _selectedDate.date.year;
    final selectedMonthIndex = widget.isLunarCalendar ? lunarDate.month + (lunarDate.isLeap ? 1 : 0) : _selectedDate.date.month;
    return CupertinoPageScaffold(
      child: SafeArea(
        child: DefaultTextStyle(
          style: TextStyle(
            color: CupertinoColors.label.resolveFrom(context),
            fontSize: 22,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      EzButton.errorText(
                        title: 'huy',
                        onPressed: context.pop,
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 80,
                        right: 80,
                        child: Center(
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: EzButton.primaryText(
                          title: 'done',
                          onPressed: () => context.pop(_selectedDate.date),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: _kItemExtent,
                        // This sets the initial item.
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedMonthIndex - 1,
                        ),
                        // This is called when selected item is changed.
                        onSelectedItemChanged: (int selectedItem) {
                          setState(() {
                            if (widget.isLunarCalendar) {
                              final isLeap = selectedItem > 0 && _months[selectedItem - 1] == _months[selectedItem];
                              _selectedDate = FullCalender(
                                date: FullCalenderExtension.convertLunarDateToSolarDate(
                                  LunarDateTime(
                                    year: lunarDate.year,
                                    month: _months[selectedItem],
                                    day: lunarDate.day,
                                    isLeap: isLeap,
                                  ),
                                )!,
                                timeZone: TimeZone.vietnamese.timezone,
                              );
                            } else {
                              _selectedDate = FullCalender(
                                date: _selectedDate.date.copyWith(month: _months[selectedItem]),
                                timeZone: TimeZone.vietnamese.timezone,
                              );
                            }
                          });
                        },
                        children: List.generate(_months.length, (index) {
                          if (widget.isLunarCalendar && index > 0 && _months[index - 1] == _months[index]) {
                            return Center(
                              child: Text(
                                '${_months[index]}(L)',
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                '${_months[index]}',
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: _kItemExtent,
                        // This sets the initial item.
                        scrollController: FixedExtentScrollController(
                          initialItem: _years.indexOf(selectedYear),
                        ),
                        // This is called when selected item is changed.
                        onSelectedItemChanged: (int selectedItem) {
                          setState(() {
                            if (widget.isLunarCalendar) {
                              _selectedDate = FullCalender(
                                date: FullCalenderExtension.convertLunarDateToSolarDate(
                                  LunarDateTime(
                                    year: _years[selectedItem],
                                    month: lunarDate.month,
                                    day: lunarDate.day,
                                  ),
                                )!,
                                timeZone: TimeZone.vietnamese.timezone,
                              );
                              _loadMonths();
                            } else {
                              _selectedDate = FullCalender(
                                date: _selectedDate.date.copyWith(year: _years[selectedItem]),
                                timeZone: TimeZone.vietnamese.timezone,
                              );
                            }
                          });
                        },
                        children: _years
                            .map(
                              (e) => Center(
                                child: Text(
                                  '$e',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/widgets/content.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:sprintf/sprintf.dart';

Future<DateTime?> showEzDatePicker(
  BuildContext context, {
  DateTime? minDate,
  DateTime? maxDate,
  DateTime? selectedDate,
  bool dayOnly = false,
  bool timeOnly = false,
  List<DateTime> notificationDays = const [],
}) {
  return showDialog<DateTime?>(
    context: context,
    builder: (context) => DateTimePicker(
      minDate: minDate,
      maxDate: maxDate,
      selectedDate: selectedDate,
      dayOnly: dayOnly,
      timeOnly: timeOnly,
      notificationDays: notificationDays,
    ),
  );
}

class DateTimePicker extends StatefulWidget {
  DateTimePicker({
    super.key,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? selectedDate,
    this.dayOnly = false,
    this.timeOnly = false,
    this.notificationDays = const [],
  })  : minDate = minDate ?? DateTime(DateTime.now().year - 100, DateTime.now().month),
        maxDate = maxDate ?? DateTime(DateTime.now().year + 100, DateTime.now().month) {
    this.selectedDate = selectedDate ?? DateTime.now();
  }

  final DateTime minDate;
  final DateTime maxDate;
  late final DateTime selectedDate;
  final bool dayOnly;
  final bool timeOnly;
  final List<DateTime> notificationDays;

  @override
  State<StatefulWidget> createState() {
    return _DateTimePickerState();
  }
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime _selectedDate;
  late TimeOfDay _timeOfDay;
  bool _pickingYears = false;
  int _selectedTab = 0;
  late DateTime _currentMonth;
  late final FixedExtentScrollController _hourScrollController;
  late final FixedExtentScrollController _minuteScrollController;
  final _scrollController = ScrollController();

  final _timeTextFieldFocusNode = FocusNode();
  final _timeTextFieldController = TextEditingController();

  @override
  void initState() {
    _selectedDate = widget.selectedDate;
    _timeOfDay = TimeOfDay(
      hour: widget.selectedDate.hour,
      minute: widget.selectedDate.minute,
    );
    if (widget.timeOnly) {
      _selectedTab = 1;
    }

    _currentMonth = widget.selectedDate;

    _hourScrollController = FixedExtentScrollController(
      initialItem: _timeOfDay.hour,
    );

    _minuteScrollController = FixedExtentScrollController(
      initialItem: _timeOfDay.minute,
    );
    _timeTextFieldController.addListener(_onTimeTextChanged);
    super.initState();
  }

  void _onTimeTextChanged() {
    final text = _timeTextFieldController.text;
    if (text.isNotEmpty) {
      final hour = int.tryParse(text.length > 1 ? text.substring(0, 2) : text);
      if (hour != null && hour < 24 && hour != _timeOfDay.hour) {
        setState(() {
          _timeOfDay = TimeOfDay(hour: hour, minute: _timeOfDay.minute);
        });
        _hourScrollController.jumpToItem(_timeOfDay.hour);
      }
      if (text.length >= 3) {
        final minute = int.tryParse(text.substring(2));
        if (minute != null && minute <= 60 && minute != _timeOfDay.minute) {
          setState(() {
            _timeOfDay = TimeOfDay(hour: _timeOfDay.hour, minute: minute);
          });
          _minuteScrollController.jumpToItem(_timeOfDay.minute);
        }
      }
    }
    if (text.length >= 4) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _timeTextFieldController.text = '';
      });
    }
  }

  @override
  void dispose() {
    _timeTextFieldFocusNode.dispose();
    _timeTextFieldController.dispose();
    super.dispose();
  }

  int getIndex(DateTime dateTime) {
    final index = widget.maxDate.year * 12 + widget.maxDate.month - dateTime.year * 12 - dateTime.month;
    if (index < 0) {
      return 0;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width * 3 / 4;

    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: '00', style: Theme.of(context).textTheme.bodyMedium),
    )..layout(maxWidth: (pageWidth - Dimens.d8 * 2) / 7);
    final itemHeight = painter.size.height + 8 * 2;
    return GestureDetector(
      onTap: () async {
        if (KeyboardVisibilityController().isVisible) {
          FocusScope.of(context).unfocus();
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: DismissibleKeyboardContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: pageWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(Dimens.d8),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Visibility(
                          visible: !widget.timeOnly,
                          child: Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedTab = 0;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: Dimens.d15),
                                alignment: Alignment.center,
                                child: Text(
                                  _selectedDate.date.toFormatString(format: 'dd/MM/yyyy'),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 13,
                                        color: _selectedTab == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !widget.timeOnly && !widget.dayOnly,
                          child: VerticalDivider(
                            width: 1,
                            color: AppColors.current.hintColor,
                          ),
                        ),
                        Visibility(
                          visible: !widget.dayOnly,
                          child: Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedTab = 1;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: Dimens.d15),
                                alignment: Alignment.center,
                                child: Text(
                                  sprintf(
                                    '%02d:%02d',
                                    [_timeOfDay.hour, _timeOfDay.minute],
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 13,
                                        color: _selectedTab == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  alignment: Alignment.center,
                  width: pageWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(Dimens.d8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IntrinsicHeight(
                        child: Stack(
                          children: [
                            IgnorePointer(
                              ignoring: _selectedTab == 1,
                              child: Opacity(
                                opacity: _selectedTab == 0 ? 1 : 0,
                                child: _dayContainer(pageWidth, itemHeight),
                              ),
                            ),
                            Visibility(
                              visible: _selectedTab == 1,
                              child: Center(
                                child: _timeContainer(pageWidth, itemHeight),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      _actionsWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _yearsWidget() {
    final maxYear = widget.maxDate.year;
    final minYear = widget.minDate.year;
    final numberOfYears = 1 + maxYear - minYear;
    final selectedYear = _selectedDate.date.year;
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d8),
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: Dimens.d32,
      ),
      itemCount: numberOfYears,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          DateTime date;
          date = DateTime(
            minYear + index,
            _selectedDate.date.month,
            _selectedDate.date.day,
          );
          if (date.isBefore(widget.minDate.startOfDate())) {
            setState(() {
              _pickingYears = false;
              _currentMonth = widget.minDate;
            });
          } else if (date.isAfter(widget.maxDate.endOfDate())) {
            setState(() {
              _pickingYears = false;
              _currentMonth = widget.maxDate;
            });
          } else {
            setState(() {
              _pickingYears = false;
              _currentMonth = date;
            });
          }
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          height: Dimens.d32,
          child: Text(
            '${widget.minDate.year + index}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selectedYear == minYear + index ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
        ),
      ),
    );
  }

  Widget _actionsWidget() => IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  if (_selectedTab == 0) {
                    if (!DateTime.now().isAfter(widget.maxDate.endOfDate()) && !DateTime.now().isBefore(widget.minDate.startOfDate())) {
                      setState(() {
                        _selectedDate = DateTime.now();
                        _currentMonth = _selectedDate;
                      });
                    } else {
                      setState(() {
                        _selectedDate = widget.selectedDate;
                        _currentMonth = _selectedDate;
                      });
                    }
                  } else {
                    setState(() {
                      _timeOfDay = TimeOfDay.now();
                      _hourScrollController.jumpToItem(_timeOfDay.hour);
                      _minuteScrollController.jumpToItem(_timeOfDay.minute);
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimens.d15,
                  ),
                  child: FittedBox(
                    child: Text(
                      _selectedTab == 0 ? 'Ngày hiện tại' : 'Giờ hiện tại',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop(
                    _selectedDate.date.copyWith(
                      hour: _timeOfDay.hour,
                      minute: _timeOfDay.minute,
                      second: 0,
                      millisecond: 0,
                      microsecond: 0,
                    ),
                  );
                },
                child: Container(
                  // height: Span.s30,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimens.d15,
                  ),
                  child: FittedBox(
                    child: Text(
                      'xong',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 13,
                          ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _dayContainer(double pageWidth, double itemHeight) {
    final currentMonth = _currentMonth;
    final year = _currentMonth.date.year;

    return Column(
      children: [
        const SizedBox(height: Dimens.d8),
        Container(
          margin: const EdgeInsets.only(left: Dimens.d16, right: Dimens.d8),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _pickingYears = !_pickingYears;
                      if (_pickingYears) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final minYear = widget.minDate.year;
                          final index = 1 + (year - minYear) / 4;
                          _scrollController.jumpTo(
                            max(0, index * Dimens.d32 - itemHeight * 7),
                          );
                        });
                      }
                    });
                  },
                  child: Text(
                    currentMonth.date.toFormatString(format: 'MMMM, yyyy').capitalizeFirstCharacter(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: currentMonth.date.startOfDate().isBefore(widget.minDate),
                child: Opacity(
                  opacity: currentMonth.date.startOfDate().isBefore(widget.minDate) ? 0.2 : 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentMonth = currentMonth.previousMonth();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimens.d8),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: currentMonth.date.endOfDate().isAfter(widget.maxDate),
                child: Opacity(
                  opacity: currentMonth.date.endOfDate().isAfter(widget.maxDate) ? 0.2 : 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentMonth = currentMonth.nextMonth();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimens.d8),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: pageWidth,
          height: itemHeight * 7,
          child: Stack(
            children: [
              IgnorePointer(
                ignoring: _pickingYears,
                child: Opacity(
                  opacity: !_pickingYears ? 1 : 0,
                  child: _dateGridView(
                    _currentMonth,
                    itemHeight,
                  ),
                ),
              ),
              Visibility(
                visible: _pickingYears,
                child: _yearsWidget(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timeContainer(double pageWidth, double itemHeight) {
    const kMagnification = 2.45 / 1.7;
    const kItemExtent = Dimens.d32;
    const kSqueeze = 1.05;
    return SizedBox(
      height: itemHeight * 7,
      child: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: SizedBox(
              width: 10,
              height: 10,
              child: EditableText(
                focusNode: _timeTextFieldFocusNode,
                controller: _timeTextFieldController,
                cursorColor: Colors.transparent,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                keyboardType: TextInputType.number,
                style: const TextStyle(),
                backgroundCursorColor: Colors.transparent,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60,
                child: GestureDetector(
                  onTap: () => _showTimeKeyboard(false),
                  child: CupertinoPicker(
                    magnification: kMagnification,
                    scrollController: _hourScrollController,
                    itemExtent: kItemExtent,
                    squeeze: kSqueeze,
                    backgroundColor: Colors.transparent,
                    looping: true,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _timeOfDay = TimeOfDay(hour: index, minute: _timeOfDay.minute);
                      });
                    },
                    children: List<Widget>.generate(24, (int index) {
                      final label = sprintf('%02i', [index]);
                      return Center(
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                fontSize: 12,
                              ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                child: GestureDetector(
                  onTap: () => _showTimeKeyboard(true),
                  child: CupertinoPicker(
                    magnification: kMagnification,
                    scrollController: _minuteScrollController,
                    itemExtent: kItemExtent,
                    squeeze: kSqueeze,
                    backgroundColor: Colors.transparent,
                    looping: true,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _timeOfDay = TimeOfDay(
                          hour: _timeOfDay.hour,
                          minute: index,
                        );
                      });
                    },
                    children: List<Widget>.generate(60, (int index) {
                      final label = sprintf('%02i', [index]);
                      return Center(
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                fontSize: 12,
                              ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTimeKeyboard(bool isFromMinute) {
    // final hour =
    //     _timeOfDay.hour < 10 ? '0${_timeOfDay.hour}' : '${_timeOfDay.hour}';
    // _timeTextFieldController.text = isFromMinute ? hour : '';
    // _timeTextFieldFocusNode.requestFocus();
  }

  Widget _headerText(String text) => Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                overflow: TextOverflow.ellipsis,
              ),
          maxLines: 1,
        ),
      );

  Widget _dateGridView(DateTime dateTime, double itemHeight) {
    final lastOfMonth = dateTime.endOfMonth();
    final firstOfMonth = dateTime.startOfMonth();
    final totalDays = lastOfMonth.date.diffDays(firstOfMonth.date) + 1;

    final startDateIndex = firstOfMonth.date.weekday - DateTime.monday;
    final d = firstOfMonth.date.subtract(Duration(days: startDateIndex));

    return Column(
      children: [
        GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: itemHeight,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.d8),
          children: [
            _headerText('T2'),
            _headerText('T3'),
            _headerText('T4'),
            _headerText('T5'),
            _headerText('T6'),
            _headerText('T7'),
            _headerText('CN'),
          ],
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: itemHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimens.d8),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final date = d.add(Duration(days: index));
            final isToday = date.date.isSameDate(DateTime.now());
            final isSelected = date.date.isSameDate(_selectedDate.date);
            final bgColor = isToday && isSelected
                ? AppColors.current.warning
                : isSelected
                    ? Theme.of(context).textTheme.bodyMedium?.color
                    : Colors.transparent;
            final textColor = isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : isToday
                    ? AppColors.current.warning
                    : Theme.of(context).textTheme.bodyMedium?.color;
            return Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: itemHeight - 2,
                width: itemHeight - 2,
                child: InkWell(
                  onTap: () {
                    if (!widget.minDate.startOfDate().isAfter(date.date) && !widget.maxDate.endOfDate().isBefore(date.date)) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(
                              itemHeight / 2,
                            ),
                          ),
                          child: Text(
                            date.date.day.toString(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: index < startDateIndex ||
                                          index >= startDateIndex + totalDays || //
                                          widget.maxDate.endOfDate().isBefore(date.date) ||
                                          widget.minDate.startOfDate().isAfter(date.date)
                                      ? AppColors.current.disabledText
                                      : textColor,
                                ),
                          ),
                        ),
                      ),
                      if (widget.notificationDays.any((e) => e.isSameDate(date.date)))
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: 42,
        ),
      ],
    );
  }
}

Future<List<DateTime>?> showCalendarDatePickerRangeDialog({
  required BuildContext context,
  Size dialogSize = const Size(325, 400),
  DateTime? from,
  DateTime? to,
  BorderRadius? borderRadius,
  bool useRootNavigator = true,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  bool useSafeArea = true,
  Color? dialogBackgroundColor,
  RouteSettings? routeSettings,
  String? barrierLabel,
  TransitionBuilder? builder,
}) {
  final dialogHeight = max(dialogSize.height, 410);
  final dialog = Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: Dimens.d16, vertical: Dimens.d24),
    backgroundColor: dialogBackgroundColor ?? Theme.of(context).canvasColor,
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
    ),
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      width: dialogSize.width,
      height: dialogHeight.toDouble(),
      child: _DayRangeDialog(
        from: from,
        to: to,
      ),
    ),
  );

  return showDialog<List<DateTime>>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
  );
}

class _DayRangeDialog extends StatefulWidget {
  const _DayRangeDialog({
    this.from,
    this.to,
  });

  final DateTime? from;
  final DateTime? to;

  @override
  State<_DayRangeDialog> createState() => _DayRangeDialogState();
}

class _DayRangeDialogState extends State<_DayRangeDialog> {
  late List<DateTime> _selectedRange;

  @override
  void initState() {
    _selectedRange = [widget.from, widget.to].whereNotNull().toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CalendarDatePicker2(
          value: _selectedRange,
          config: CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.range,
            calendarViewMode: CalendarDatePicker2Mode.day,
            allowSameValueSelection: false,
            openedFromDialog: false,
            dayBuilder: _dateBuilder,
          ),
          onValueChanged: _handleValueChange,
        ),
        Padding(
          padding: const EdgeInsets.only(right: Dimens.d8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              EzButton.primaryText(
                isEnabled: true,
                title: 'Hủy',
                onPressed: context.pop,
              ),
              EzButton.primaryText(
                title: 'Đồng ý',
                isEnabled: _selectedRange.length >= 2,
                onPressed: () => context.pop([_selectedRange[0], _selectedRange[1]]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget? _dateBuilder({
    required DateTime date,
    TextStyle? textStyle,
    BoxDecoration? decoration,
    bool? isSelected,
    bool? isDisabled,
    bool? isToday,
  }) {
    if ((isToday ?? false) && !(isSelected ?? false)) {
      return Container(
        margin: const EdgeInsets.all(Dimens.d4),
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(
              color: Theme.of(context).textTheme.bodyMedium!.color!,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: EzTextStyles.titlePrimary,
        ),
      );
    }
    return null;
  }

  void _handleValueChange(List<DateTime?> value) {
    final selectedDays = value.whereNotNull().toList();
    if (selectedDays.isEmpty) {
      if (_selectedRange.isNotEmpty) {
        setState(() {
          _selectedRange = [];
        });
      }
    } else if (selectedDays.length == 1) {
      final date = selectedDays.first;
      if (_selectedRange.length == 1) {
        final previousSelectedDate = _selectedRange.first;
        if (!previousSelectedDate.isSameDate(date)) {
          if (previousSelectedDate.isBefore(date)) {
            setState(() {
              _selectedRange = [DateTime.fromMillisecondsSinceEpoch(max(previousSelectedDate.millisecondsSinceEpoch, date.previousMonth().add(const Duration(days: 1)).millisecondsSinceEpoch)), date];
            });
          } else {
            setState(() {
              _selectedRange = [date, DateTime.fromMillisecondsSinceEpoch(min(previousSelectedDate.millisecondsSinceEpoch, date.nextMonth().subtract(const Duration(days: 1)).millisecondsSinceEpoch))];
            });
          }
        }
      } else {
        setState(() {
          _selectedRange = [date];
        });
      }
    } else if (selectedDays.length == 2) {
      if (selectedDays.first.isSameDate(selectedDays[1])) {
        setState(() {
          _selectedRange = [selectedDays.first];
        });
      } else if (selectedDays.first == _selectedRange.first) {
        setState(() {
          _selectedRange = [DateTime.fromMillisecondsSinceEpoch(max(_selectedRange.first.millisecondsSinceEpoch, selectedDays[1].previousMonth().add(const Duration(days: 1)).millisecondsSinceEpoch)), selectedDays[1]];
        });
      } else {
        setState(() {
          _selectedRange = [selectedDays.first, DateTime.fromMillisecondsSinceEpoch(min(_selectedRange.first.millisecondsSinceEpoch, _selectedRange[1].nextMonth().subtract(const Duration(days: 1)).millisecondsSinceEpoch))];
        });
      }
    }
  }
}

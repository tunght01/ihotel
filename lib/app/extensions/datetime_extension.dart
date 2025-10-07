import 'package:full_calender/enums/time_zone.dart';
import 'package:full_calender/full_calender.dart';
import 'package:full_calender/full_calender_extension.dart';
import 'package:full_calender/models/lunar_date_time.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

String longDateFormat = 'd MMMM, yyyy';
String mediumDateFormat = 'dd/MM/yyyy';

extension DateTimeExtension on DateTime {
  String toUTCDateString() {
    //converts date into the following format:
    // or 2019-06-04T12:08:56.235-0700
    return toUtc().toIso8601String();
  }

  String toFormatString({String format = 'HH:mm dd/MM/yyyy'}) {
    return DateFormat(format).format(this);
  }


  String toHourFormat() {
    return DateFormat('HH:mm').format(this);
  }

  String yearString({String format = 'yy'}) {
    return DateFormat(format).format(this);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int diffDays(DateTime other) {
    return startOfDate().difference(other.startOfDate()).inDays;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  DateTime dayOfMonth(int daySet) {
    return DateTime(year, month, daySet, 12);
  }

  String monthYearString({
    String format = 'MMMM, yyyy',
    bool isLunarCalendar = false,
    bool showSuffix = true,
  }) {
    final fullCalendarDate = FullCalender(date: this, timeZone: TimeZone.vietnamese.timezone);
    final lunarDate = fullCalendarDate.lunarDate;
    if (isLunarCalendar) {
      final leapSuffix = lunarDate.isLeap ? '(L)' : '';
      return '${DateFormat(format).format(DateTime(lunarDate.year, lunarDate.month))}${showSuffix ? ' L' : ''}$leapSuffix';
    } else {
      return DateFormat(format).format(this);
    }
  }

  DateTime toDayOfMonth(
    int daySet,
    int monthSet,
  ) {
    return copyWith(
      year: year,
      month: monthSet,
      day: daySet,
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
      second: DateTime.now().second,
    );
  }

  DateTime startOfDate() => copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  DateTime endOfDate() => copyWith(hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);

  DateTime nextMonth() {
    return DateTime(year, month + 1, day);
  }

  DateTime previousMonth() {
    return DateTime(year, month - 1, day);
  }
}
extension FullCalendarExtension on FullCalender {
  String shouldShowLunar({
    String format = 'MM/ yyyy',
    bool isLunarCalendar = false,
    bool showSuffix = true,
  }) {
    if (isLunarCalendar) {
      final leapSuffix = lunarDate.isLeap ? '(L)' : '';
      return '${DateFormat(format).format(DateTime(lunarDate.year, lunarDate.month, lunarDate.day))}${showSuffix ? ' L' : ''}$leapSuffix';
    } else {
      return DateFormat(format).format(date.toLocal());
    }
  }

  FullCalender endOfMonth({bool isLunarCalendar = false}) {
    if (isLunarCalendar) {
      final lunarDate = this.lunarDate;
      DateTime firstDateOfNextMonth;
      if (lunarDate.month == 12) {
        final nextMonth = LunarDateTime(year: lunarDate.year + 1, month: 1, day: 1);
        firstDateOfNextMonth = FullCalenderExtension.convertLunarDateToSolarDate(nextMonth) ?? date;
      } else {
        var nextMonth = this;
        while (nextMonth.lunarDate.month == lunarDate.month && nextMonth.lunarDate.isLeap == lunarDate.isLeap) {
          nextMonth = FullCalender(
            date: nextMonth.date.add(
              const Duration(days: 28),
            ),
            timeZone: timeZone,
          );
        }
        final lunarDateOfNextMonth = nextMonth.lunarDate;
        final firstLunarDateOfNextMonth = LunarDateTime(
          year: lunarDateOfNextMonth.year,
          month: lunarDateOfNextMonth.month,
          day: 1,
          isLeap: lunarDateOfNextMonth.isLeap,
        );
        firstDateOfNextMonth = FullCalenderExtension.convertLunarDateToSolarDate(
              firstLunarDateOfNextMonth,
            ) ??
            date;
      }
      return FullCalender(
        date: firstDateOfNextMonth.subtract(const Duration(days: 1)).endOfDate(),
        timeZone: timeZone,
      );
    } else {
      return FullCalender(
        date: DateTime(date.year, date.month + 1)
            .subtract(
              const Duration(days: 1),
            )
            .endOfDate(),
        timeZone: timeZone,
      );
    }
  }

  FullCalender startOfMonth({bool isLunarCalendar = false}) {
    if (isLunarCalendar) {
      final lunarDate = this.lunarDate;
      final firstDayOfMonth = LunarDateTime(
        year: lunarDate.year,
        month: lunarDate.month,
        day: 1,
        isLeap: lunarDate.isLeap,
      );
      final solarDate = FullCalenderExtension.convertLunarDateToSolarDate(firstDayOfMonth) ?? date;
      return FullCalender(
        date: solarDate.startOfDate(),
        timeZone: timeZone,
      );
    } else {
      return FullCalender(
        date: DateTime(date.year, date.month).startOfDate(),
        timeZone: timeZone,
      );
    }
  }

  FullCalender nextMonth({bool isLunarCalendar = false}) {
    if (isLunarCalendar) {
      final lunarDate = this.lunarDate;
      if (lunarDate.month == 12) {
        final d = FullCalenderExtension.convertLunarDateToSolarDate(
              LunarDateTime(year: lunarDate.year + 1, month: 1, day: 1),
            ) ??
            date;
        return FullCalender(date: d, timeZone: timeZone);
      } else {
        var nextMonth = FullCalender(
          date: date.add(const Duration(days: 28)),
          timeZone: timeZone,
        );
        while (nextMonth.lunarDate.month == lunarDate.month && nextMonth.lunarDate.isLeap == lunarDate.isLeap) {
          nextMonth = FullCalender(
            date: nextMonth.date.add(const Duration(days: 1)),
            timeZone: timeZone,
          );
        }
        final solarDate = FullCalenderExtension.convertLunarDateToSolarDate(
              LunarDateTime(
                year: nextMonth.lunarDate.year,
                month: nextMonth.lunarDate.month,
                day: 1,
                isLeap: nextMonth.lunarDate.isLeap,
              ),
            ) ??
            nextMonth.date;

        return FullCalender(
          date: solarDate,
          timeZone: timeZone,
        );
      }
    } else {
      return FullCalender(
        date: DateTime(date.year, date.month + 1),
        timeZone: timeZone,
      );
    }
  }

  FullCalender nextDay({bool isLunarCalendar = false}) {
    if (isLunarCalendar) {
      final lunarNextDate = lunarDate.getDateNext(1);
      final d = FullCalenderExtension.convertLunarDateToSolarDate(
            LunarDateTime(
              year: lunarNextDate.year,
              month: lunarNextDate.month,
              day: lunarNextDate.day,
            ),
          ) ??
          date;
      return FullCalender(date: d, timeZone: timeZone);
    } else {
      return FullCalender(
        date: DateTime(date.year, date.month, date.day + 1),
        timeZone: timeZone,
      );
    }
  }

  FullCalender previousDay({bool isLunarCalendar = false}) {
    if (isLunarCalendar) {
      final lunarNextDate = lunarDate.getDateNext(-1);
      final d = FullCalenderExtension.convertLunarDateToSolarDate(
            LunarDateTime(
              year: lunarNextDate.year,
              month: lunarNextDate.month,
              day: lunarNextDate.day,
            ),
          ) ??
          date;
      return FullCalender(date: d, timeZone: timeZone);
    } else {
      return FullCalender(
        date: DateTime(date.year, date.month, date.day - 1),
        timeZone: timeZone,
      );
    }
  }

  FullCalender previousMonth({bool isLunarCalendar = false}) {
    if (isLunarCalendar) {
      final lunarDate = this.lunarDate;
      if (lunarDate.month == 1) {
        final d = FullCalenderExtension.convertLunarDateToSolarDate(
              LunarDateTime(year: lunarDate.year - 1, month: 12, day: 1),
            ) ??
            date;
        return FullCalender(date: d, timeZone: timeZone);
      }
      var previousMonth = FullCalender(
        date: date.subtract(const Duration(days: 28)),
        timeZone: timeZone,
      );
      while (previousMonth.lunarDate.month == lunarDate.month && previousMonth.lunarDate.isLeap == lunarDate.isLeap) {
        previousMonth = FullCalender(
          date: previousMonth.date.subtract(const Duration(days: 1)),
          timeZone: timeZone,
        );
      }
      final solarDate = FullCalenderExtension.convertLunarDateToSolarDate(
            LunarDateTime(
              year: previousMonth.lunarDate.year,
              month: previousMonth.lunarDate.month,
              day: 1,
              isLeap: previousMonth.lunarDate.isLeap,
            ),
          ) ??
          previousMonth.date;

      return FullCalender(
        date: solarDate,
        timeZone: timeZone,
      );
    } else {
      return FullCalender(
        date: DateTime(date.year, date.month - 1),
        timeZone: timeZone,
      );
    }
  }

  FullCalender startDateOfMonth(
    int startDateOfMonth, {
    bool isLunarCalendar = false,
  }) {
    if (isLunarCalendar) {
      final lunarDate = this.lunarDate;
      if (lunarDate.day >= startDateOfMonth) {
        return FullCalender(
          date: FullCalenderExtension.convertLunarDateToSolarDate(
            LunarDateTime(
              year: lunarDate.year,
              month: lunarDate.month,
              day: startDateOfMonth,
              isLeap: lunarDate.isLeap,
            ),
          )!,
          timeZone: TimeZone.vietnamese.timezone,
        );
      } else {
        final previousMonth = this.previousMonth(isLunarCalendar: true).lunarDate;
        return FullCalender(
          date: FullCalenderExtension.convertLunarDateToSolarDate(
            LunarDateTime(
              year: previousMonth.year,
              month: previousMonth.month,
              day: startDateOfMonth,
              isLeap: previousMonth.isLeap,
            ),
          )!,
          timeZone: TimeZone.vietnamese.timezone,
        );
      }
    } else {
      if (date.day >= startDateOfMonth) {
        return FullCalender(
          date: DateTime(date.year, date.month, startDateOfMonth),
          timeZone: TimeZone.vietnamese.timezone,
        );
      } else {
        final previousMonth = this.previousMonth();
        return FullCalender(
          date: DateTime(
            previousMonth.date.year,
            previousMonth.date.month,
            startDateOfMonth,
          ),
          timeZone: TimeZone.vietnamese.timezone,
        );
      }
    }
  }

  FullCalender endDateOfMonth(
    int startDateOfMonth, {
    bool isLunarCalendar = false,
  }) {
    if (isLunarCalendar) {
      final lunarDate = this.lunarDate;
      if (lunarDate.day >= startDateOfMonth) {
        final nextMonth = this.nextMonth(isLunarCalendar: true).lunarDate;
        return FullCalender(
          date: FullCalenderExtension.convertLunarDateToSolarDate(
            LunarDateTime(
              year: nextMonth.year,
              month: nextMonth.month,
              day: startDateOfMonth,
              isLeap: nextMonth.isLeap,
            ),
          )!
              .subtract(const Duration(days: 1))
              .endOfDate(),
          timeZone: TimeZone.vietnamese.timezone,
        );
      } else {
        return FullCalender(
          date: FullCalenderExtension.convertLunarDateToSolarDate(
            LunarDateTime(
              year: lunarDate.year,
              month: lunarDate.month,
              day: startDateOfMonth,
              isLeap: lunarDate.isLeap,
            ),
          )!
              .subtract(const Duration(days: 1))
              .endOfDate(),
          timeZone: TimeZone.vietnamese.timezone,
        );
      }
    } else {
      if (date.day >= startDateOfMonth) {
        final nextMonth = this.nextMonth();
        final newDate = DateTime(
          nextMonth.date.year,
          nextMonth.date.month,
          startDateOfMonth,
        );
        return FullCalender(
          date: newDate.subtract(const Duration(days: 1)).endOfDate(),
          timeZone: TimeZone.vietnamese.timezone,
        );
      } else {
        return FullCalender(
          date: DateTime(date.year, date.month, startDateOfMonth).subtract(const Duration(days: 1)).endOfDate(),
          timeZone: TimeZone.vietnamese.timezone,
        );
      }
    }
  }

  FullCalender findDateEnd({
    required int startDayOfGroup,
    bool isLunarCalendar = false,
  }) {
    if (isLunarCalendar) {
      final lunarDate = this.lunarDate;
      if (lunarDate.month == 12) {
        final d = FullCalenderExtension.convertLunarDateToSolarDate(
              LunarDateTime(
                year: lunarDate.year + 1,
                month: 1,
                day: startDayOfGroup - 1,
              ),
            ) ??
            date;
        return FullCalender(date: d, timeZone: timeZone);
      } else {
        var nextMonth = FullCalender(
          date: date.add(Duration(days: 28 - startDayOfGroup + 1)),
          timeZone: timeZone,
        );
        while (nextMonth.lunarDate.month == lunarDate.month && nextMonth.lunarDate.isLeap == lunarDate.isLeap) {
          nextMonth = FullCalender(
            date: nextMonth.date.add(const Duration(days: 1)),
            timeZone: timeZone,
          );
        }
        final solarDate = FullCalenderExtension.convertLunarDateToSolarDate(
              LunarDateTime(
                year: nextMonth.lunarDate.year,
                month: nextMonth.lunarDate.month,
                day: startDayOfGroup - 1,
                isLeap: nextMonth.lunarDate.isLeap,
              ),
            ) ??
            nextMonth.date;

        return FullCalender(
          date: solarDate,
          timeZone: timeZone,
        );
      }
    } else {
      final dateEnd = DateTime(date.year, date.month + 1, startDayOfGroup - 1);
      return FullCalender(
        date: dateEnd,
        timeZone: TimeZone.vietnamese.timezone,
      );
    }
  }

  FullCalender changeYear({required int year, bool isLunarCalendar = false}) {
    if (isLunarCalendar) {
      final lunarDateChange = LunarDateTime(year: year, month: 1, day: 1);
      final solarDate = FullCalenderExtension.convertLunarDateToSolarDate(lunarDateChange) ?? date;
      return FullCalender(
        date: solarDate,
        timeZone: timeZone,
      );
    } else {
      return FullCalender(date: DateTime(year), timeZone: timeZone);
    }
  }

  FullCalender startDateOfYear(
    int startDateOfMonth, {
    bool isLunarCalendar = false,
  }) {
    if (isLunarCalendar) {
      return FullCalender(
        date: FullCalenderExtension.convertLunarDateToSolarDate(
          LunarDateTime(
            year: lunarDate.year,
            month: 1,
            day: startDateOfMonth,
          ),
        )!,
        timeZone: TimeZone.vietnamese.timezone,
      );
    } else {
      return FullCalender(
        date: DateTime(date.year, 1, startDateOfMonth),
        timeZone: TimeZone.vietnamese.timezone,
      );
    }
  }

  FullCalender endDateOfYear(
    int startDateOfMonth, {
    bool isLunarCalendar = false,
  }) {
    if (isLunarCalendar) {
      return FullCalender(
        date: FullCalenderExtension.convertLunarDateToSolarDate(
          LunarDateTime(
            year: lunarDate.year + 1,
            month: 1,
            day: startDateOfMonth,
            isLeap: lunarDate.isLeap,
          ),
        )!
            .subtract(const Duration(days: 1))
            .endOfDate(),
        timeZone: TimeZone.vietnamese.timezone,
      );
    } else {
      return FullCalender(
        date: DateTime(date.year + 1, 1, startDateOfMonth).subtract(const Duration(days: 1)).endOfDate(),
        timeZone: TimeZone.vietnamese.timezone,
      );
    }
  }

  FullCalender switchMonth(bool isLunarCalendar, bool isNextMonth, int startDay) {
    final now = FullCalender.now(TimeZone.vietnamese.timezone);
    final switchMonth = isNextMonth ? nextMonth(isLunarCalendar: isLunarCalendar) : previousMonth(isLunarCalendar: isLunarCalendar);
    final end = switchMonth.endDateOfMonth(1, isLunarCalendar: isLunarCalendar);
    if (isLunarCalendar) {
      final lunarDay = FullCalenderExtension.convertLunarDateToSolarDate(
            LunarDateTime(
              year: switchMonth.lunarDate.year,
              month: switchMonth.lunarDate.month,
              day: now.lunarDate.day > end.lunarDate.day ? end.lunarDate.day : now.lunarDate.day,
              isLeap: switchMonth.lunarDate.isLeap,
            ),
          ) ??
          end.date;
      return FullCalender(date: lunarDay, timeZone: TimeZone.vietnamese.timezone);
    } else {
      return FullCalender(
        date: switchMonth.date.copyWith(
          day: now.date.day > end.date.day ? end.date.day : now.date.day,
        ),
        timeZone: TimeZone.vietnamese.timezone,
      );
    }
  }
}

extension DurationExtension on int {
  String millisecondToFormattedString() {
    final hour = this ~/ 3600000;
    final minute = this ~/ 60000 - hour * 60;
    final second = this ~/ 1000 - this ~/ 60000;
    if (hour > 0) {
      return sprintf('%02i:%02i:%02i', [hour, minute, second]);
    } else {
      return sprintf('%02i:%02i', [minute, second]);
    }
  }
}

import 'package:intl/intl.dart';

class DateTimeUtils {
  static List<String> getWeekDaysTitle() {
    return [
      'T2',
      'T3',
      'T4',
      'T5',
      'T6',
      'T7',
      'CN',
    ];
  }

  static String getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }
}

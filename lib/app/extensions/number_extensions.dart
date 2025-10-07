import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';

extension DoubleExtensions on double {
  String toCurrency({String currency = 'VND'}) {
    final currencySymbol = NumberFormat().simpleCurrencySymbol(currency);
    if (this < 0) {
      return '- $currencySymbol${abs().currencyFormat()}';
    } else {
      return '+ $currencySymbol${currencyFormat()}';
    }
  }

  String toCurrencyInfinity({String currency = 'VND'}) {
    final currencySymbol = NumberFormat().simpleCurrencySymbol(currency);
    if (this < 0) {
      return '$currencySymbol${abs().headerCurrencyFormat()}';
    } else {
      return '$currencySymbol${headerCurrencyFormat()}';
    }
  }

  String toCurrencyFormat({String currency = ''}) {
    final currencySymbol = NumberFormat().simpleCurrencySymbol(currency);
    if (currency == 'VND') {
      if (this == 0) return '';
      if (this < 0) {
        return '$currencySymbol${abs().headerCurrencyFormat()}';
      } else {
        return '$currencySymbol${headerCurrencyFormat()}';
      }
    } else {
      if (this == 0) return '';
      if (this < 0) {
        return '$currencySymbol${abs().currencyFormat()}';
      } else {
        return '$currencySymbol${currencyFormat()}';
      }
    }
  }

  String toCurrencyNotSymbol({String currency = 'VND'}) {
    if (currency == 'VND') {
      if (this < 0) {
        return '-${abs().headerCurrencyFormat()}';
      } else {
        return '+${headerCurrencyFormat()}';
      }
    } else {
      if (this < 0) {
        return '-${abs().currencyFormat()}';
      } else {
        return '+${currencyFormat()}';
      }
    }
  }

  String toCurrencyShort({String currency = 'VND'}) {
    final currencySymbol = NumberFormat().simpleCurrencySymbol(currency);
    if (this >= 1000 && (this % 1000 == 0)) {
      final short = this / 1000;
      return '$currencySymbol${short.headerCurrencyFormat()}K';
    } else {
      if (this < 0) {
        return '$currencySymbol${abs().headerCurrencyFormat()}';
      } else {
        return '$currencySymbol${headerCurrencyFormat()}';
      }
    }
  }

  String currencyFormat() {
    if (toString().endsWith('.0')) {
      return NumberFormat('###,###,###,##0', 'en_US').format(this);
    } else {
      return NumberFormat('###,###,###,##0.00', 'en_US').format(this);
    }
  }

  String numberFormat() {
    if (toString().endsWith('.0')) {
      return NumberFormat('###,###,###,##0', 'en_US').format(this);
    } else {
      return NumberFormat('###,###,###,##0.0#', 'en_US').format(this);
    }
  }

  String headerCurrencyFormat() {
    return NumberFormat('###,###,###,##0', 'en_US').format(this);
  }
}

extension IntExtensions on int {
  String dateOfMonthString(String languageCode) {
    if (languageCode.toLowerCase() == 'vi') {
      return 'ngày $this';
    }
    final now = DateTime.now();
    final moment = Moment(
      DateTime(now.year, now.month, this),
      localization: MomentLocalizations.byLanguage('vi', countryCode: 'vn'),
    );
    return moment.format('Do');
  }

  String minus() {
    final value = this - 1;
    return value.maxValue(1).toString();
  }

  String add() {
    return (this + 1).toString();
  }

  int maxValue(int max) {
    return this < max ? max : this;
  }
}

extension NumberParsing on String {
  double toDouble() {
    if (isEmpty) {
      return 0;
    } else {
      return double.tryParse(replaceAll(',', '.')) ?? 0;
    }
  }

  int toIntQuantity() {
    if (isEmpty) {
      return 1;
    } else {
      return (int.tryParse(this) ?? 0).maxValue(1);
    }
  }

  int toInt() {
    if (isEmpty) {
      return 0;
    } else {
      return int.tryParse(this) ?? 0;
    }
  }

  double toDoubleCurrency() {
    if (isEmpty) {
      return 0;
    } else {
      try {
        return double.parse(replaceAll(RegExp('[^0-9.]'), ''));
      } catch (e) {
        return 0;
      }
    }
  }
}

extension DurationExtensions on Duration {
  String toTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    return '${twoDigits(inHours)}:$twoDigitMinutes';
  }

  String toTimeWork() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    return '${inHours}h${twoDigitMinutes}m';
  }
}

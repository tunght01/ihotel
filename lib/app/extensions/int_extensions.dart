extension IntExtension on int? {
  int? toRemainder() {
    if (this == null) return 0;
    return (this ?? 0) % 60;
  }

  int? toWhole() {
    if (this == null) return 0;
    return (this ?? 0) ~/ 60;
  }

  String monthFormat() {
    return toString().padLeft(2, '0');
  }

  String toTimeString() {
    if (this == null) return '';
    final h = this! ~/ 60;
    final m = this! % 60;
    if (m < 10) {
      return '$h:0$m';
    }else{
      return '$h:$m';
    }
  }
}
extension IntExtensions on int {
  int plus(int other) {
    return this + other;
  }

  int minus(int other) {
    return this - other;
  }
}

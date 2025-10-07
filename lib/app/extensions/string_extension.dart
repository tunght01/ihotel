// ignore_for_file: avoid_js_rounded_ints

extension StringExtension on String {
  String capitalizeFirstCharacter() {
    if (isEmpty) return '';
    if (length == 1) {
      return this[0].toUpperCase();
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String addSpaceToString() {
    if (isEmpty) return '';
    return RegExp('.{1}').allMatches(this).map((e) => e.group(0)).join(' ');
  }

  String? trimSpaceToString() {
    if (isEmpty) return '';
    return replaceAll(' ', '');
  }

  String trimCharLeft(String from, String pattern) {
    if (from.isEmpty || pattern.isEmpty || pattern.length > from.length) {
      return from;
    }

    while (from.startsWith(pattern)) {
      // ignore: parameter_assignments
      from = from.substring(pattern.length);
    }
    return from;
  }

  String trimCharRight(String from, String pattern) {
    if (from.isEmpty || pattern.isEmpty || pattern.length > from.length) {
      return from;
    }
    while (from.endsWith(pattern)) {
      // ignore: parameter_assignments
      from = from.substring(0, from.length - pattern.length);
    }
    return from;
  }

  String trimChar(String from, String pattern) {
    return trimCharLeft(trimCharRight(from, pattern), pattern);
  }

  int? timeToInt() {
    final parts = split(':');
    final h = (int.parse(parts[0])) * 60;
    final m = int.parse(parts[1]);
    return h + m;
  }

  String shortName() {
    if (trim().isEmpty) {
      return '';
    }
    final words = trim().split(' ');
    if (words.length >= 2) {
      return words.first[0].toUpperCase() + words[1][0].toUpperCase();
    }
    if (words.first.length > 2) {
      return words.first[0].toUpperCase() + words.first[1];
    }
    return words.first[0].toUpperCase();
  }

  int fastHash() {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < length) {
      final codeUnit = codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }
}

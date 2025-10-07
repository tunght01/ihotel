import 'dart:math';

import 'package:ulid/ulid.dart';

class EzGenCode {
  const EzGenCode._();


  static String genUniqueStringKey() {
    final ulid = Ulid();

    return ulid.toUuid();
  }

  static String gen([int length = 6]) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}

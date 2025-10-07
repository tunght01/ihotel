import 'package:ihostel/app/shared/gen_code.dart';

class FastRoom {
  FastRoom({
    this.id = '',
    this.name = '',
    this.price = 0,
  }) {
    if (id.isEmpty) id = EzGenCode.genUniqueStringKey();
  }

  String id;
  String name;
  double price;

  FastRoom copyWith({
    String? id,
    String? name,
    double? price,
  }) {
    return this
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..price = price ?? this.price;
  }
}

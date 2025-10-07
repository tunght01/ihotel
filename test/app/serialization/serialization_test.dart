import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/serialization/serialization.dart';

part 'serialization_test.freezed.dart';
part 'serialization_test.g.dart';

void main() {
  group('When a json string is', () {
    test('a serialized list of objects, deserializeJsonList should return the valid list of objects', () {
      const data = [SerializableClass(data: 'data 1'), SerializableClass(data: 'data 2')];
      final jsonString = jsonEncode(data);

      final result = deserializeJsonList(jsonString, SerializableClass.fromJson);

      expect(result, orderedEquals(data));
    });

    test('not a serialized list of objects, deserializeJsonList should throw', () {
      const data = SerializableClass(data: 'data 1');
      final jsonString = jsonEncode(data);

      expect(() => deserializeJsonList(jsonString, SerializableClass.fromJson), throwsArgumentError);
    });
  });
}

@freezed
class SerializableClass with _$SerializableClass {
  const factory SerializableClass({
    required String data,
  }) = _SerializableClass;

  const SerializableClass._();

  factory SerializableClass.fromJson(Map<String, Object?> json) => _$SerializableClassFromJson(json);
}

import 'dart:convert' hide json;

typedef JsonDeserializer<T> = T Function(Map<String, Object?> json);

List<T> deserializeJsonList<T>(
  String jsonString,
  JsonDeserializer<T> deserializer,
) {
  final json = jsonDecode(jsonString);

  return switch (json) {
    List<dynamic> _ => List.unmodifiable(
        json.map((jsonItem) => deserializer(jsonItem as Map<String, Object?>)),
      ),
    _ => throw ArgumentError('The json is not a list of objects'),
  };
}

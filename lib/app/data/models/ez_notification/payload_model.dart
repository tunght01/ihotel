import 'package:freezed_annotation/freezed_annotation.dart';

part 'payload_model.g.dart';

@JsonSerializable()
class PayloadModel {
  PayloadModel(
    this.type,
    this.message,
    this.timeLocal,
  );

  factory PayloadModel.fromJson(Map<String, dynamic> json) => _$PayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadModelToJson(this);

  final String? message;
  final String? type;
  final DateTime? timeLocal;

  DateTime get getTimeLocal => timeLocal ?? DateTime.now();
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ihostel/app/app.dart';

part 'ez_notification.g.dart';

@JsonSerializable()
class EzNotification extends BaseModel<EzNotification> {
  EzNotification({
    this.title = '',
    this.createdDate = '',
    this.content = '',
    this.isRead = false,
    this.type = 0,
    super.id,
  });

  factory EzNotification.fromJson(Map<String, dynamic> json) => _$EzNotificationFromJson(json);
  String title;
  String createdDate;
  String content;
  bool isRead;
  int type;


  @override
  Map<String, dynamic> toJson() => _$EzNotificationToJson(this);

  @override
  EzNotification convertUtc() => copyWith();

  @override
  EzNotification toObject(Map<String, dynamic> json) => EzNotification.fromJson(json);
}

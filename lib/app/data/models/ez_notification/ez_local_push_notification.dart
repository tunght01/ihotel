class EzReceivedNotification {
  EzReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.type,
    this.requestedUser,
    this.groupId,
    this.roomId,
  });

  // check loại type khi click vào thông báo api trả về
  static const typeSync = 'sync-data';

  //local push
  static const typeExpired = 'expired';

  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final String? type;
  final String? requestedUser;
  final String? groupId;
  final String? roomId;
}

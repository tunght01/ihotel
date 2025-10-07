enum ButtonAddType {
  brandNew('+ Thành viên', 'Mới hoàn toàn'),
  usedIHostel('+ Thành viên', 'Đã sử dụng IHostel');

  const ButtonAddType(this.title, this.content);

  final String title;
  final String content;

  bool get isBrandNew => this == ButtonAddType.brandNew;

  bool get isUsedIHostel => this == ButtonAddType.usedIHostel;
}

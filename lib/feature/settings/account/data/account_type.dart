import 'package:ihostel/assets_gen/assets.gen.dart';

enum AccountType {
  accountLink,
  bankInformation,
  userCode,
  deleteAccount,
  logout,
}

extension AccountTypeExt on AccountType {
  String get title => switch (this) {
    AccountType.accountLink => 'Liên kết ngân hàng',
    AccountType.bankInformation => 'Thông tin ngân hàng',
    AccountType.userCode => 'Mã người dùng',
    AccountType.deleteAccount => 'Xoá tài khoản, ngừng sử dụng',
    AccountType.logout => 'Đăng xuất'
  };

  SvgGenImage get icon => switch (this) {
    AccountType.accountLink => Assets.images.person,
    AccountType.bankInformation => Assets.images.bank,
    AccountType.userCode => Assets.images.blueWindow,
    AccountType.deleteAccount => Assets.images.deleteAccount,
    AccountType.logout => Assets.images.logout
  };
}

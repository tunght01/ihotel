import 'package:ihostel/assets_gen/assets.gen.dart';

enum FunctionButtonType {
  cashAudit,
  memberList,
  roomManagement,
  profitManagement,
  exportToExcel,
}

extension FunctionButtonTypeExtension on FunctionButtonType {
  String get title => switch (this) {
        FunctionButtonType.cashAudit => 'Kiểm quỹ',
        FunctionButtonType.memberList => 'Danh sách thành viên',
        FunctionButtonType.roomManagement => 'Quản lý phòng',
        FunctionButtonType.profitManagement => 'QL lợi nhuận',
        FunctionButtonType.exportToExcel => 'Xuất Excel',
      };
  SvgGenImage get icon => switch (this) {
        FunctionButtonType.cashAudit => Assets.images.icWalletSearch,
        FunctionButtonType.memberList => Assets.images.icUserSquare,
        FunctionButtonType.roomManagement => Assets.images.icClock,
        FunctionButtonType.profitManagement => Assets.images.icMoney,
        FunctionButtonType.exportToExcel => Assets.images.icExport,
      };

  bool get isCashAudit => this == FunctionButtonType.cashAudit;
  bool get isMemberList => this == FunctionButtonType.memberList;
  bool get isRoomManagement => this == FunctionButtonType.roomManagement;
  bool get isProfitManagement => this == FunctionButtonType.profitManagement;
  bool get isExportToExcel => this == FunctionButtonType.exportToExcel;
}

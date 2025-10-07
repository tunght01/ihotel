enum HostelDetailType {
  receivable,
  revenue,
}

extension MotelDetailTypeExt on HostelDetailType {
  String get title => switch (this) {
        HostelDetailType.receivable => 'Còn nợ',
        HostelDetailType.revenue => 'Tổng thu',
      };

  bool get isReceivable => this == HostelDetailType.receivable;

  bool get isRevenue => this == HostelDetailType.revenue;
}

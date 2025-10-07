import 'package:flutter/material.dart';
import 'package:ihostel/app/shared/dimens.dart';
import 'package:ihostel/app/shared/text_styles.dart';

class FinancialReceivablesItem extends StatelessWidget {
  const FinancialReceivablesItem({
    this.title,
    this.money,
    this.hasDivider = false,
    super.key,
  });

  final String? title;
  final String? money;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.d13),
          child: Row(
            children: [
              Expanded(child: Text(title ?? '0', style: EzTextStyles.s14.primary.w500)),
              Text(money ?? '0', style: EzTextStyles.s14.primary),
            ],
          ),
        ),
        if (hasDivider) const Divider(),
      ],
    );
  }
}

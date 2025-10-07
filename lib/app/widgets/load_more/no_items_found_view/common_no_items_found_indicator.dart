import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';

class CommonNoItemsFoundIndicator extends StatelessWidget {
  const CommonNoItemsFoundIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(
      child: Center(child: NoDataWidget(message: 'Không có dữ liệu')),
    );
  }
}

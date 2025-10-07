import 'package:flutter/material.dart';
import 'package:ihostel/app/app.dart';

class EzTitleBox extends StatelessWidget {
  const EzTitleBox({
    this.padding = const EdgeInsets.all(Dimens.d16),
    this.title = '',
    this.content = '',
    this.hasDivider = true,
    super.key,
    this.mergeContent,
  });

  final String title;
  final String content;
  final EdgeInsetsGeometry padding;
  final bool hasDivider;
  final TextStyle? mergeContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: EzTextStyles.s14.secondary),
              Text(content, style: EzTextStyles.s14.primary.merge(mergeContent)),
            ],
          ),
        ),
        if (hasDivider) const Divider(),
      ],
    );
  }
}

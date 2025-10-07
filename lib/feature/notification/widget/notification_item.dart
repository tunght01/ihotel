import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.title,
    required this.content,
    required this.date,
    this.onTap,
    this.isRead = false,
    super.key,
  });

  final VoidCallback? onTap;
  final bool isRead;
  final String title;
  final String content;
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return EzCard(
      padding: const EdgeInsets.only(bottom: Dimens.d15, top: Dimens.d15),
      onTap: onTap,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: EzTextStyles.s14),
              Row(
                children: [
                  Text(date.toFormatString(), style: EzTextStyles.s12.primary.w500),
                  Dimens.d8.horizontalSpace,
                  Container(
                    width: Dimens.d10,
                    height: Dimens.d10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.current.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Dimens.d10.verticalSpace,
          Text(content, style: EzTextStyles.s14.primary.w500),
        ],
      ),
    );
  }
}

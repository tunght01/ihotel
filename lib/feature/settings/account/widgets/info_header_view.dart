import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/shared/dimens.dart';
import 'package:ihostel/app/shared/text_styles.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';

class InfoHeaderView extends StatefulWidget {
  const InfoHeaderView({
    required this.avatar,
    required this.name,
    required this.email,
    super.key,
  });

  final SvgGenImage avatar;
  final String name;
  final String email;

  @override
  State<InfoHeaderView> createState() => _InfoHeaderViewState();
}

class _InfoHeaderViewState extends State<InfoHeaderView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d15, vertical: Dimens.d12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue,
      ),
      child: Row(
        children: [
          Container(
            width: Dimens.d56,
            height: Dimens.d56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.d5),
              child: widget.avatar.svg(),
            ),
          ),
          Dimens.d5.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: EzTextStyles.s18.w700.primary.copyWith(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                Dimens.d6.verticalSpace,
                Text(
                  widget.email,
                  style: EzTextStyles.s12.w500.primary.copyWith(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Dimens.d16.horizontalSpace,
              ],
            ),
          ),
          Assets.images.edit.svg(height: 20, width: 20),
        ],
      ),
    );
  }
}

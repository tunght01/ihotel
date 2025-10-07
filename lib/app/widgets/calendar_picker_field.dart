import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';

class CalenderPickerProfitField extends StatelessWidget {
  const CalenderPickerProfitField({
    required this.date,
    required this.onTap,
    required this.onNext,
    required this.onPre,
    required this.title,
    super.key,
  });

  final DateTime? date;
  final void Function(DateTime?)? onTap;
  final VoidCallback onNext;
  final VoidCallback onPre;
  final String title;

  @override
  Widget build(BuildContext context) {
    final hint = (date ?? DateTime.now()).toFormatString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Row(
            children: [
              Text(title, style: EzTextStyles.defaultPrimary.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: Dimens.d10),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EzCard(
              height: Dimens.d52,
              width: Dimens.d52,
              onTap: onPre,
              child: const Icon(Icons.chevron_left_rounded),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DateTimeSelectionField(
                hint: hint,
                selectedDate: date,
                isDate: true,
                height: Dimens.d52,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.d16,
                ),
                hasOnBackground: true,
                suffixIcon: Assets.images.calendar.svg(),
                onTap: onTap,
              ),
            ),
            Dimens.d10.horizontalSpace,
            EzCard(
              height: Dimens.d52,
              width: Dimens.d52,
              onTap: onNext,
              child: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ],
    );
  }
}

class DateTimeSelectionField extends StatefulWidget {
  DateTimeSelectionField({
    String? hint,
    this.isDate = false,
    this.isTime = false,
    this.margin,
    EdgeInsets? padding,
    TextEditingController? controller,
    this.suffixIcon,
    this.width,
    this.height,
    this.onTap,
    this.bgColor,
    this.hintColor,
    this.selectedDate,
    this.hasOnBackground = false,
    this.enable = true,
    this.validateDate,
    this.errorValidateDate,
    this.isLunar = false,
    super.key,
  })  : hint = hint ?? '',
        padding = padding ?? const EdgeInsets.all(12),
        controller = controller ?? TextEditingController();

  final String hint;
  final bool isDate;
  final bool isTime;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final void Function(DateTime)? onTap;
  final double? width;
  final double? height;
  final Color? bgColor;
  final Color? hintColor;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final DateTime? selectedDate;
  final bool hasOnBackground;
  final bool enable;
  final DateTime? validateDate;
  final VoidCallback? errorValidateDate;
  final bool isLunar;

  @override
  State<DateTimeSelectionField> createState() => _DateTimeSelectionFieldState();
}

class _DateTimeSelectionFieldState extends State<DateTimeSelectionField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.selectedDate;
    widget.controller.text = widget.isDate ? _selectedDate?.toFormatString() ?? '' : _selectedDate?.toHourFormat() ?? '';
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DateTimeSelectionField oldWidget) {
    _selectedDate = widget.selectedDate;
    widget.controller.text = widget.isDate ? _selectedDate?.toFormatString() ?? '' : _selectedDate?.toHourFormat() ?? '';
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showEzWorkDatePicker,
      child: Container(
        width: widget.width ?? double.maxFinite,
        height: widget.height ?? Dimens.d52,
        decoration: BoxDecoration(
          color: widget.bgColor ??
              [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.onTertiary,
              ][widget.hasOnBackground ? 1 : 0],
          border: Border.all(
            color: [
              Theme.of(context).colorScheme.scrim,
              Theme.of(context).colorScheme.onTertiary,
            ][widget.hasOnBackground ? 1 : 0],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: widget.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.controller.text.isEmpty ? widget.hint : widget.controller.text,
                style: EzTextStyles.defaultPrimary.copyWith(
                  color: widget.controller.text.isEmpty ? widget.hintColor ?? Theme.of(context).hintColor : null,
                ),
              ),
              //
              Container(margin: widget.margin, child: widget.suffixIcon),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEzWorkDatePicker() async {
    if (widget.enable) {
      final selected = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1971),
        lastDate: DateTime(DateTime.now().year + 100),
      );
      setState(() {
        if (selected != null) {
          if (widget.validateDate != null && widget.validateDate?.hour == selected.hour && widget.validateDate?.minute == selected.minute) {
            widget.errorValidateDate?.call();
          } else {
            widget.onTap?.call(selected);
            _selectedDate = selected;
            if (widget.isDate) {
              widget.controller.text = selected.toFormatString();
            } else if (widget.isTime) {
              widget.controller.text = selected.toHourFormat();
            }
          }
        }
      });
    }
  }
}

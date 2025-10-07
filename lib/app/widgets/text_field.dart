import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';

class EzTextField extends StatefulWidget {
  EzTextField({
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.value = '',
    this.title = '',
    this.isRequired = false,
    this.isSearch = false,
    this.hasClear = false,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.enabled = true,
    this.onChanged,
    this.textStyle,
    this.textAlignVertical,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.contextMenuBuilder,
    this.fillColor,
    this.onTap,
    this.cursorHeight,
    this.enableSuggestions = true,
    this.isDense,
    this.isCollapsed,
    this.hasLiesOnCard = false,
    this.onTapOutside,
    this.onEditingComplete,
    this.contentPadding = const EdgeInsets.only(
      left: Dimens.d16,
      right: Dimens.d16,
    ),
    this.textController,
    super.key,
  }) {
    // TODO(Hoang): review
  }

  EzTextField.number({
    super.key,
    this.focusNode,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.value = '',
    this.title = '',
    this.isRequired = false,
    this.isSearch = false,
    this.hasClear = false,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    List<TextInputFormatter>? inputFormatters,
    this.enabled = true,
    this.onChanged,
    this.textStyle,
    this.textAlignVertical,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.contextMenuBuilder,
    this.keyboardType = TextInputType.number,
    this.fillColor,
    this.onTap,
    this.cursorHeight,
    this.enableSuggestions = true,
    this.isDense,
    this.isCollapsed,
    this.hasLiesOnCard = false,
    this.onTapOutside,
    this.onEditingComplete,
    this.contentPadding = const EdgeInsets.only(
      left: Dimens.d16,
      right: Dimens.d16,
    ),
    this.textController,
  }) : inputFormatters = inputFormatters ?? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))];

  const EzTextField.text({
    super.key,
    this.focusNode,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.value = '',
    this.title = '',
    this.isRequired = false,
    this.isSearch = false,
    this.hasClear = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.enabled = true,
    this.onChanged,
    this.textAlignVertical,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.contextMenuBuilder,
    this.fillColor,
    this.onTap,
    this.cursorHeight,
    this.enableSuggestions = true,
    this.isDense,
    this.isCollapsed,
    this.hasLiesOnCard = false,
    this.onTapOutside,
    this.onEditingComplete,
    this.contentPadding = const EdgeInsets.only(
      left: Dimens.d16,
      right: Dimens.d16,
    ),
    this.textController,
  }) : keyboardType = TextInputType.text;

  final TextEditingController? textController;

  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final bool readOnly;
  final bool isSearch;
  final String value;
  final String title;
  final bool obscureText;
  final bool isRequired;
  final int maxLines;
  final int? minLines;

  final String? hint;

  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final EdgeInsetsGeometry contentPadding;
  final Color? fillColor;
  final GestureTapCallback? onTap;
  final double? cursorHeight;
  final bool enableSuggestions;
  final bool? isDense;
  final bool? isCollapsed;
  final bool hasClear;
  final bool hasLiesOnCard;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;

  @override
  State<EzTextField> createState() => _EzTextFieldState();
}

class _EzTextFieldState extends State<EzTextField> {
  late TextEditingController _controller;
  bool _isSearchChange = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.textController ?? TextEditingController(text: widget.value);
    _controller.addListener(_onControllerChanged);
    _isSearchChange = (widget.hasClear || widget.isSearch) && _controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant EzTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textController != widget.textController) {
      _controller.removeListener(_onControllerChanged);
      _controller = widget.textController ?? TextEditingController(text: widget.value);
      _controller.addListener(_onControllerChanged);
    }
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
    _isSearchChange = (widget.hasClear || widget.isSearch) && _controller.text.isNotEmpty;
  }

  void _onControllerChanged() {
    if (widget.hasClear || widget.isSearch) {
      _isSearchChange = _controller.text.isNotEmpty;
      widget.onChanged?.call(_controller.text);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.textController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = widget.hasLiesOnCard ? AppColors.current.secondaryBackgroundTextField : AppColors.current.backgroundTextField;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title.isNotEmpty) ...[
          Row(
            children: [
              Flexible(child: Text(widget.title, style: EzTextStyles.defaultPrimary.copyWith(fontWeight: FontWeight.w600))),
              const SizedBox(width: Dimens.d1),
              Text(widget.isRequired ? '*' : '', style: EzTextStyles.defaultPrimary.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: Dimens.d10),
        ],
        TextFormField(
          decoration: InputDecoration(
            isDense: widget.isDense,
            isCollapsed: widget.isCollapsed,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            fillColor: widget.fillColor ?? fillColor,
            filled: true,
            contentPadding: widget.contentPadding,
            counterText: '',
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon == null && widget.isSearch
                ? EzIconButton(
                    child: Assets.images.search.svg(),
                  )
                : widget.prefixIcon,
            suffixIcon: widget.suffixIcon == null && _isSearchChange
                ? EzIconButton(
                    onPressed: _controller.clear,
                    child: Assets.images.closeCircle.svg(height: Dimens.d18, width: Dimens.d18),
                  )
                : widget.suffixIcon,
            hintStyle: EzTextStyles.defaultPrimary.copyWith(
              color: AppColors.current.hintColor,
              decorationThickness: 0,
            ),
          ),
          onEditingComplete: widget.onEditingComplete,
          onTapOutside: widget.onTapOutside,
          controller: _controller,
          enableSuggestions: widget.enableSuggestions,
          autocorrect: false,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          textAlign: widget.textAlign,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          textAlignVertical: widget.textAlignVertical,
          style: widget.textStyle ?? EzTextStyles.defaultPrimary.copyWith(decorationThickness: 0),
          onTap: widget.onTap,
          cursorHeight: widget.cursorHeight,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/text_styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.initialValue,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.suffixIcon,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization,
    this.maxLength,
    this.autofocus = false,
    this.controller,
  });

  final String hintText;
  final String? initialValue;
  final bool readOnly;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool autofocus;
  final TextEditingController? controller;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      cursorColor: AppColors.contentSoftOnSoft(context),
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon != null
            ? Icon(
                widget.suffixIcon,
                size: Dimens.iconSizeS,
                color: AppColors.contentSoftOnSoft(context),
              )
            : null,
        fillColor: AppColors.bgSoft(context),
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(Dimens.radiusBase)),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyles.primaryRegularMedium.copyWith(color: AppColors.contentSoftOnSoft(context)),
      ),
      style: TextStyles.primaryRegularMedium.copyWith(color: AppColors.content(context)),
    );
  }
}

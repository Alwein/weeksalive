import 'package:flutter/material.dart';
import 'package:flutter_fast_template/core/styles/app_colors.dart';
import 'package:flutter_fast_template/core/styles/dimens.dart';
import 'package:flutter_fast_template/core/styles/margins.dart';
import 'package:flutter_fast_template/core/styles/text_styles.dart';

class FormTitle extends StatelessWidget {
  const FormTitle({super.key, required this.text, this.icon, this.textAlign = TextAlign.left});
  final String text;
  final IconData? icon;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: Dimens.iconSizeS,
              color: AppColors.textColor(context),
            ),
            const SizedBox(width: Margins.spacingS),
          ],
          Flexible(
            child: Text(
              text,
              textAlign: textAlign,
              style: TextStyles.primaryBold.copyWith(color: AppColors.textColor(context)),
            ),
          ),
        ],
      ),
    );
  }
}

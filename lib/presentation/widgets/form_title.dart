import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';

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
              color: AppColors.content(context),
            ),
            const SizedBox(width: Margins.spacingS),
          ],
          Flexible(
            child: Text(
              text,
              textAlign: textAlign,
              style: TextStyles.primaryBold.copyWith(color: AppColors.content(context)),
            ),
          ),
        ],
      ),
    );
  }
}

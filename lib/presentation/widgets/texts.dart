import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/text_styles.dart';

class Texts {
  static Widget xlBold(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.xlBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  static Widget hugeBold(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.hugeBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  static Widget primaryLargeBold(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryLargeBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  static Widget xlBoldSoft(
    BuildContext context,
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.xlBold,
      color: AppColors.contentSoft(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  static Widget primaryMediumBold(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryMediumBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  static Widget primaryBold(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  static Widget primaryMedium(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    Color? color,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryMediumMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
    );
  }

  static Widget primaryMediumSoft(
    BuildContext context,
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryMediumMedium,
      color: AppColors.contentSoft(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  static Widget primaryXsMediumSoft(
    BuildContext context,
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryXsMedium,
      color: AppColors.contentSoft(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  static Widget primaryRegular(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryRegular,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  static Widget primaryRegularSoft(
    BuildContext context,
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryRegular,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: AppColors.contentSoft(context),
    );
  }

  static Widget primaryRegularSoftOnSoft(
    BuildContext context,
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryRegular,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: AppColors.contentSoftOnSoft(context),
    );
  }

  static Widget primaryXsMedium(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    Color? color,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryXsMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
    );
  }

  static Widget primaryXsBold(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    Color? color,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryXsBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
    );
  }

  static Widget primaryMediumCounter(
    BuildContext context,
    String type,
    String? value, {
    TextAlign? textAlign,
    Color? softColor,
  }) {
    return _TypeValueText(
      context: context,
      type: type,
      value: value,
      textAlign: textAlign,
      softColor: softColor,
    );
  }
}

class _TypeValueText extends StatelessWidget {
  const _TypeValueText({
    required this.context,
    required this.type,
    required this.value,
    this.textAlign,
    this.softColor,
  });

  final BuildContext context;
  final String type;
  final String? value;
  final TextAlign? textAlign;
  final Color? softColor;

  @override
  Widget build(BuildContext ctx) {
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$type ',
            style: TextStyles.primaryRegularMedium.copyWith(color: softColor ?? AppColors.contentSoft(context)),
          ),
          if (value != null)
            TextSpan(
              text: value,
              style: TextStyles.primaryRegularMedium.copyWith(color: AppColors.content(context)),
            ),
        ],
      ),
    );
  }
}

class _StyledText extends StatelessWidget {
  const _StyledText({
    required this.text,
    required this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.color,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(color: color ?? AppColors.content(context)),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

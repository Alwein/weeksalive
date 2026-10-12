import 'package:easy_localization/easy_localization.dart';
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

  /// Onboarding titles — Inter.
  static Widget onboardingXlBold(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.onboardingXlBold,
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

  /// Onboarding titles — Inter.
  static Widget onboardingHugeBold(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.onboardingHugeBold,
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
    Color? color,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryLargeBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
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

  /// Onboarding titles — Inter.
  static Widget onboardingXlBoldSoft(
    BuildContext context,
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.onboardingXlBold,
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
    Color? color,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryMediumBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
    );
  }

  static Widget primaryBold(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    Color? color,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
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
      style: TextStyles.primarySmallMedium,
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
    Color? color,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryRegular,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
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
      style: TextStyles.primarySmallMedium,
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
      style: TextStyles.primarySmallBold,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
    );
  }

  static Widget primaryRegularMedium(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    Color? color,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryRegularMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      color: color,
    );
  }

  static Widget primaryXsCounter(
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

  /// Like [primaryXsCounter] for a unit label ("DAY", "WEEK"). Chinese,
  /// Japanese and Korean put the unit after the number ("285 / 365 天").
  static Widget primaryXsUnitCounter(
    BuildContext context,
    String unit,
    String value, {
    TextAlign? textAlign,
    Color? softColor,
  }) {
    return _TypeValueText(
      context: context,
      type: unit,
      value: value,
      textAlign: textAlign,
      softColor: softColor,
      typeAfterValue: _unitFollowsNumber.contains(context.locale.languageCode),
    );
  }

  static const _unitFollowsNumber = {'zh', 'ja', 'ko'};
}

class _TypeValueText extends StatelessWidget {
  const _TypeValueText({
    required this.context,
    required this.type,
    required this.value,
    this.textAlign,
    this.softColor,
    this.typeAfterValue = false,
  });

  final BuildContext context;
  final String type;
  final String? value;
  final TextAlign? textAlign;
  final Color? softColor;
  final bool typeAfterValue;

  @override
  Widget build(BuildContext ctx) {
    final typeSpan = TextSpan(
      text: typeAfterValue ? ' $type' : '$type ',
      style: TextStyles.primarySmallMedium.copyWith(color: softColor ?? AppColors.contentSoft(context)),
    );
    final valueSpan = value == null
        ? null
        : TextSpan(
            text: value,
            style: TextStyles.primarySmallMedium.copyWith(color: AppColors.content(context)),
          );
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: [
          if (typeAfterValue) ...[?valueSpan, typeSpan] else ...[typeSpan, ?valueSpan],
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

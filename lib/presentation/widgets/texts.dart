import 'package:flutter/material.dart';
import 'package:flutter_fast_template/core/styles/app_colors.dart';
import 'package:flutter_fast_template/core/styles/text_styles.dart';

class Texts {
  static Widget appTitle(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.appTitle,
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
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryMedium,
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

  static Widget primaryXsMedium(
    String text, {
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) {
    return _StyledText(
      text: text,
      style: TextStyles.primaryXsMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
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
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(color: AppColors.textColor(context)),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

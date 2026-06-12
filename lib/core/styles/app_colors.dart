import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors_extension.dart';

class AppColors {
  static Color content(BuildContext context) => context.appColors.tokens.content;
  static Color contentMuted(BuildContext context) => context.appColors.tokens.contentMuted;
  static Color contentSoft(BuildContext context) => context.appColors.tokens.contentSoft;
  static Color contentExtraSoft(BuildContext context) => context.appColors.tokens.contentExtraSoft;
  static Color contentSoftOnSoft(BuildContext context) => context.appColors.tokens.contentSoftOnSoft;
  static Color bg(BuildContext context) => context.appColors.tokens.bg;
  static Color bgSoft(BuildContext context) => context.appColors.tokens.bgSoft;
  static Color strokeColor(BuildContext context) => context.appColors.tokens.strokeColor;
  static Color redWarning(BuildContext context) => context.appColors.tokens.redWarning;
  static Color greenSuccess(BuildContext context) => context.appColors.tokens.greenSuccess;
  static Color blueInfo(BuildContext context) => context.appColors.tokens.blueInfo;
  static Color accentOrange(BuildContext context) => context.appColors.tokens.accentOrange;
  static Color accentMint(BuildContext context) => context.appColors.tokens.accentMint;
  static Color accentPurple(BuildContext context) => context.appColors.tokens.accentPurple;

  static Color widgetContent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
}

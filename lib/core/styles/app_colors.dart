import 'package:flutter/material.dart';

class AppColors {
  static content(BuildContext context) => context.isDarkMode ? contentDark : contentLight;
  static contentMuted(BuildContext context) => context.isDarkMode ? contentLight : contentDark;
  static const contentDark = Color(0xFFF5F5F5);
  static const contentLight = Color(0xFF272727);
  static const contentWhite = Color(0xFFFFFFFF);
  static const contentDisabled = Color(0xFFA2A2A2);

  static contentSoft(BuildContext context) => context.isDarkMode ? contentDarkSoft : contentLightSoft;
  static const contentDarkSoft = Color(0xFF8E8E8E);
  static const contentLightSoft = Color(0xFF767676);

  static contentSoftOnSoft(BuildContext context) => context.isDarkMode ? contentDarkSoftOnSoft : contentLightSoftOnSoft;
  static const contentDarkSoftOnSoft = Color(0xFFA3A3A3);
  static const contentLightSoftOnSoft = Color(0xFF6E6E6E);

  static bgSoft(BuildContext context) => context.isDarkMode ? bgDarkSoft : bgLightSoft;
  static const bgDarkSoft = Color(0xFF333333);
  static const bgLightSoft = Color(0xFFF2F2F2);

  static const redWarning = Color(0xFFFF5C5C);
  static const greenSuccess = Color(0xFF43C59E);
  static const amber = Color(0xFFEFE5D3);
  static const blueInfo = Color(0xFF007AFF);

  static final strokeColor = Colors.grey.withValues(alpha: 0.5);

  static const shimmerBaseColorLight = Color(0xFFE0E0E0);
  static const shimmerBaseColorDark = Color(0xFF616161);
  static shimmerBaseColor(BuildContext context) => context.isLightMode ? shimmerBaseColorLight : shimmerBaseColorDark;

  static const backgroundColorLight = Color(0xFFFFFFFF);

  static getBackgroundColor(BuildContext context) =>
      context.isLightMode ? backgroundColorLight : const Color(0xFF121212);

  static textColor(BuildContext context) => context.isLightMode ? content : Colors.white;
  static invertedTextColor(BuildContext context) => context.isLightMode ? Colors.white : content;
  static contentColor(BuildContext context) => context.isLightMode ? content : Colors.white;
  static dialogBackgroundColor(BuildContext context) => context.isLightMode ? Colors.white : content;
}

extension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
}

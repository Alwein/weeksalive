import 'package:flutter/material.dart';

class AppColors {
  static Color content(BuildContext context) => context.isDarkMode ? contentDark : contentLight;
  static Color contentMuted(BuildContext context) => context.isDarkMode ? contentLight : contentDark;
  static const contentDark = Color(0xFFFFFFFF);
  static const contentLight = Color(0xFF090909);

  static Color contentSoft(BuildContext context) => context.isDarkMode ? contentDarkSoft : contentLightSoft;
  static const contentDarkSoft = Color(0xFF8E8E8E);
  static const contentLightSoft = Color(0xFF767676);

  static Color contentSoftOnSoft(BuildContext context) =>
      context.isDarkMode ? contentDarkSoftOnSoft : contentLightSoftOnSoft;
  static const contentDarkSoftOnSoft = Color(0xFFA3A3A3);
  static const contentLightSoftOnSoft = Color(0xFF6E6E6E);

  static Color bg(BuildContext context) => context.isDarkMode ? bgDark : bgLight;
  static const bgDark = Color(0xFF090909);
  static const bgLight = Color(0xFFFFFFFF);

  static Color scaffoldBg(BuildContext context) => context.isDarkMode ? const Color(0xFF141414) : bgLightSoft;

  static Color bgSoft(BuildContext context) => context.isDarkMode ? bgDarkSoft : bgLightSoft;
  static const bgDarkSoft = Color(0xFF333333);
  static const bgLightSoft = Color(0xFFF2F2F2);

  static Color widgetBg(BuildContext context) => context.isDarkMode ? Colors.black : Colors.white;
  static Color widgetContent(Brightness brightness) => brightness == Brightness.dark ? Colors.white : Colors.black;
  // only used on widgets with bg images
  static Color widgetContentSoftBright() => const Color(0xFFCCCCCC);

  static const strokeColor = Color(0xFFF0F0F0);

  // Inf Colorormation
  static const redWarning = Color(0xFFFF5C5C);
  static const greenSuccess = Color(0xFF43C59E);
  static const blueInfo = Color(0xFF007AFF);
}

extension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

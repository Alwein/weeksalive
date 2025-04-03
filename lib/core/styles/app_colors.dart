import 'package:flutter/material.dart';

class AppColors {
  static const content = Color(0xFF272727);
  static const contentWhite = Color(0xFFFFFFFF);
  static const contentDisabled = Color(0xFFA2A2A2);

  static const redWarning = Color(0xFFFF5C5C);
  static const greenSuccess = Color(0xFF43C59E);
  static const amber = Color(0xFFEFE5D3);
  static const blueInfo = Color(0xFF007AFF);

  static final strokeColor = Colors.grey.withOpacity(0.5);

  static const shimmerBaseColorLight = Color(0xFFE0E0E0);
  static const shimmerBaseColorDark = Color(0xFF616161);
  static shimmerBaseColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? shimmerBaseColorLight : shimmerBaseColorDark;

  static const backgroundColorLight = Color(0xFFFFFFFF);

  static getBackgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? backgroundColorLight : const Color(0xFF121212);

  static textColor(BuildContext context) => Theme.of(context).brightness == Brightness.light ? content : Colors.white;
  static invertedTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? Colors.white : content;
  static contentColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? content : Colors.white;
  static dialogBackgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? Colors.white : content;
}

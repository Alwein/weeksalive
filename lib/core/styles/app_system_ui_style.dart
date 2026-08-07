import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/app_colors_extension.dart';

abstract final class AppSystemUiStyle {
  static SystemUiOverlayStyle forTokens(AppColorTokens tokens) {
    final isLightBackground = tokens.bg.computeLuminance() > 0.5;
    return SystemUiOverlayStyle(
      statusBarColor: tokens.bg,
      statusBarIconBrightness: isLightBackground ? Brightness.dark : Brightness.light,
      statusBarBrightness: isLightBackground ? Brightness.light : Brightness.dark,
    );
  }

  static SystemUiOverlayStyle forContext(BuildContext context) {
    return forTokens(context.appColors.tokens);
  }
}

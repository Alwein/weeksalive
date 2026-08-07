import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/app_colors_extension.dart';
import 'package:weeksalive/core/styles/app_system_ui_style.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';

class AppThemeConfig {
  const AppThemeConfig({
    required this.themeMode,
    required this.theme,
    required this.darkTheme,
  });

  final ThemeMode themeMode;
  final ThemeData theme;
  final ThemeData darkTheme;
}

abstract final class AppThemeBuilder {
  static AppThemeConfig build(AppThemeId id) {
    return switch (id) {
      AppThemeId.system => _dynamic(
        light: AppThemes.of(AppThemeId.system).lightTokens!,
        dark: AppThemes.of(AppThemeId.system).darkTokens!,
      ),
      AppThemeId.dark => _static(AppThemes.of(AppThemeId.dark)),
      AppThemeId.light => _static(AppThemes.of(AppThemeId.light)),
      _ => _static(AppThemes.of(id)),
    };
  }

  static AppThemeConfig _dynamic({
    required AppColorTokens light,
    required AppColorTokens dark,
  }) {
    return AppThemeConfig(
      themeMode: ThemeMode.system,
      theme: _themeData(light, Brightness.light),
      darkTheme: _themeData(dark, Brightness.dark),
    );
  }

  static AppThemeConfig _static(AppTheme appTheme) {
    final themeData = _themeData(appTheme.tokens!, appTheme.brightness!);
    final mode = appTheme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    return AppThemeConfig(
      themeMode: mode,
      theme: themeData,
      darkTheme: themeData,
    );
  }

  static ThemeData _themeData(AppColorTokens tokens, Brightness brightness) {
    final systemOverlayStyle = AppSystemUiStyle.forTokens(tokens);

    return ThemeData(
      brightness: brightness,
      useMaterial3: false,
      scaffoldBackgroundColor: tokens.bg,
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: systemOverlayStyle,
      ),
      extensions: [AppColorsExtension(tokens: tokens)],
    );
  }
}

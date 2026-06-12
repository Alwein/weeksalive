import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/themes/chromatic_theme_tokens.dart';
import 'package:weeksalive/core/styles/themes/default_theme_tokens.dart';

@immutable
class AppTheme {
  const AppTheme({
    required this.id,
    required this.previewColor,
    required this.isDynamic,
    this.brightness,
    this.tokens,
    this.lightTokens,
    this.darkTokens,
  });

  final AppThemeId id;
  final Color previewColor;
  final bool isDynamic;
  final Brightness? brightness;
  final AppColorTokens? tokens;
  final AppColorTokens? lightTokens;
  final AppColorTokens? darkTokens;
}

abstract final class AppThemes {
  static const system = AppTheme(
    id: AppThemeId.system,
    previewColor: Color(0xFF8E8E8E),
    isDynamic: true,
    lightTokens: DefaultThemeTokens.light,
    darkTokens: DefaultThemeTokens.dark,
  );

  static const dark = AppTheme(
    id: AppThemeId.dark,
    previewColor: Color(0xFF090909),
    isDynamic: false,
    brightness: Brightness.dark,
    tokens: DefaultThemeTokens.dark,
  );

  static const light = AppTheme(
    id: AppThemeId.light,
    previewColor: Color(0xFFFFFFFF),
    isDynamic: false,
    brightness: Brightness.light,
    tokens: DefaultThemeTokens.light,
  );

  static const petale = AppTheme(
    id: AppThemeId.petale,
    previewColor: Color(0xFFE8A0B0),
    isDynamic: false,
    brightness: Brightness.light,
    tokens: ChromaticThemeTokens.petale,
  );

  static const pivoine = AppTheme(
    id: AppThemeId.pivoine,
    previewColor: Color(0xFF8A3050),
    isDynamic: false,
    brightness: Brightness.dark,
    tokens: ChromaticThemeTokens.pivoine,
  );

  static const cafe = AppTheme(
    id: AppThemeId.cafe,
    previewColor: Color(0xFF6A4A38),
    isDynamic: false,
    brightness: Brightness.light,
    tokens: ChromaticThemeTokens.cafe,
  );

  static const matcha = AppTheme(
    id: AppThemeId.matcha,
    previewColor: Color(0xFF5A8A68),
    isDynamic: false,
    brightness: Brightness.dark,
    tokens: ChromaticThemeTokens.matcha,
  );

  static const lavande = AppTheme(
    id: AppThemeId.lavande,
    previewColor: Color(0xFFA87ED4),
    isDynamic: false,
    brightness: Brightness.light,
    tokens: ChromaticThemeTokens.lavande,
  );

  static const terracotta = AppTheme(
    id: AppThemeId.terracotta,
    previewColor: Color(0xFFC4614A),
    isDynamic: false,
    brightness: Brightness.dark,
    tokens: ChromaticThemeTokens.terracotta,
  );

  static const ardoise = AppTheme(
    id: AppThemeId.ardoise,
    previewColor: Color(0xFF4A7090),
    isDynamic: false,
    brightness: Brightness.dark,
    tokens: ChromaticThemeTokens.ardoise,
  );

  static const _byId = {
    AppThemeId.system: system,
    AppThemeId.dark: dark,
    AppThemeId.light: light,
    AppThemeId.petale: petale,
    AppThemeId.pivoine: pivoine,
    AppThemeId.cafe: cafe,
    AppThemeId.matcha: matcha,
    AppThemeId.lavande: lavande,
    AppThemeId.terracotta: terracotta,
    AppThemeId.ardoise: ardoise,
  };

  static AppTheme of(AppThemeId id) => _byId[id]!;

  static AppColorTokens resolveTokens(AppThemeId id, Brightness platformBrightness) {
    final theme = of(id);
    if (theme.isDynamic) {
      return platformBrightness == Brightness.dark ? theme.darkTokens! : theme.lightTokens!;
    }
    return theme.tokens!;
  }
}

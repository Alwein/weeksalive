import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';
import 'package:weeksalive/core/styles/themes/default_theme_tokens.dart';

void main() {
  group('AppThemes.resolveTokens', () {
    test('system uses light tokens in light mode', () {
      final tokens = AppThemes.resolveTokens(AppThemeId.system, Brightness.light);
      expect(tokens, DefaultThemeTokens.light);
    });

    test('system uses dark tokens in dark mode', () {
      final tokens = AppThemes.resolveTokens(AppThemeId.system, Brightness.dark);
      expect(tokens, DefaultThemeTokens.dark);
    });

    test('static themes always return the same tokens', () {
      final light = AppThemes.resolveTokens(AppThemeId.petale, Brightness.light);
      final dark = AppThemes.resolveTokens(AppThemeId.petale, Brightness.dark);
      expect(light, dark);
      expect(light, AppThemes.of(AppThemeId.petale).tokens);
    });
  });
}

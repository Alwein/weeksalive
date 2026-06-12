import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({required this.tokens});

  final AppColorTokens tokens;

  @override
  AppColorsExtension copyWith({AppColorTokens? tokens}) {
    return AppColorsExtension(tokens: tokens ?? this.tokens);
  }

  @override
  AppColorsExtension lerp(covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(tokens: tokens.lerp(other.tokens, t));
  }
}

extension AppColorsExtensionContext on BuildContext {
  AppColorsExtension get appColors => Theme.of(this).extension<AppColorsExtension>()!;
}

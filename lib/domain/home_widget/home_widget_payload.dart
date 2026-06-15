import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';

/// Serialises the data the native widgets need into JSON blobs that are written
/// to the shared store (iOS App Group / Android SharedPreferences) via
/// `home_widget`. The native side (SwiftUI / Jetpack Glance) decodes these and
/// draws the grids itself, so no PNG is ever rendered by Flutter.
///
/// Two blobs are produced:
/// - `life_grid_json` for the "Grille de vie" widget (year-scale + week-scale).
/// - `year_grid_json` for the "Grille année" widget (current civil year).
///
/// Each blob carries both a `light` and a `dark` color palette resolved from the
/// active theme tokens, so the native widget picks the one matching the system
/// appearance. For a fixed (non-dynamic) theme both palettes are identical.
abstract final class HomeWidgetPayload {
  static const lifeGridKey = 'life_grid_json';
  static const yearGridKey = 'year_grid_json';

  /// Builds the JSON string for the "Grille de vie" widget.
  static String lifeGrid({
    required int totalYears,
    required int livedYears,
    required int totalWeeks,
    required int livedWeeks,
    required HomeWidgetPalette light,
    required HomeWidgetPalette dark,
  }) {
    return jsonEncode(<String, dynamic>{
      'totalYears': totalYears,
      'livedYears': livedYears,
      'totalWeeks': totalWeeks,
      'livedWeeks': livedWeeks,
      'light': light.toJson(),
      'dark': dark.toJson(),
    });
  }

  /// Builds the JSON string for the "Grille année" widget.
  ///
  /// [fillSizes] follows the encoding used by the in-app year view:
  /// `-3` today w/o record, `-2` past w/o record, `-1` future w/o record,
  /// `[0, 4]` recorded size level. It is serialised as a comma-separated string
  /// to keep the blob compact (Android marshals it across a Binder transaction).
  ///
  /// [year] is the civil year being displayed and [livedDays] the number of
  /// elapsed days (including today), used by the native footer (e.g.
  /// `2026` / `166/365 days`).
  static String yearGrid({
    required int year,
    required int totalDays,
    required int livedDays,
    required List<int> fillSizes,
    required HomeWidgetPalette light,
    required HomeWidgetPalette dark,
  }) {
    return jsonEncode(<String, dynamic>{
      'year': year,
      'totalDays': totalDays,
      'livedDays': livedDays,
      'fillSizes': fillSizes.join(','),
      'light': light.toJson(),
      'dark': dark.toJson(),
    });
  }
}

/// The subset of theme color tokens the native widgets draw with, encoded as
/// `#AARRGGBB` hex strings.
@immutable
class HomeWidgetPalette {
  const HomeWidgetPalette({
    required this.content,
    required this.contentSoft,
    required this.bg,
    required this.bgSoft,
    required this.strokeColor,
    required this.accentOrange,
  });

  /// Resolves a palette from the theme [tokens].
  factory HomeWidgetPalette.fromTokens(AppColorTokens tokens) {
    return HomeWidgetPalette(
      content: _hex(tokens.content),
      contentSoft: _hex(tokens.contentSoft),
      bg: _hex(tokens.bg),
      bgSoft: _hex(tokens.bgSoft),
      strokeColor: _hex(tokens.strokeColor),
      accentOrange: _hex(tokens.accentOrange),
    );
  }

  /// Filled / active dots.
  final String content;

  /// Muted text used by the widget footer labels.
  final String contentSoft;

  /// Widget background.
  final String bg;

  /// Inactive dots and past days without a record.
  final String bgSoft;

  /// Outline for future (empty) dots.
  final String strokeColor;

  /// Today's dot when it has no record yet.
  final String accentOrange;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'content': content,
    'contentSoft': contentSoft,
    'bg': bg,
    'bgSoft': bgSoft,
    'strokeColor': strokeColor,
    'accentOrange': accentOrange,
  };

  /// Formats a [Color] as an `#AARRGGBB` hex string.
  static String _hex(Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}

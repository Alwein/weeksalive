import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/domain/home_widget/home_widget_payload.dart';

AppColorTokens _tokens({
  Color content = const Color(0xFF112233),
  Color contentMuted = const Color(0xFF445566),
  Color bg = const Color(0xFFFFFFFF),
  Color bgSoft = const Color(0xFFEEEEEE),
  Color strokeColor = const Color(0x80123456),
  Color accentOrange = const Color(0xFFFF8800),
}) {
  return AppColorTokens(
    content: content,
    contentMuted: contentMuted,
    contentSoft: content,
    contentExtraSoft: content,
    contentSoftOnSoft: content,
    bg: bg,
    bgSoft: bgSoft,
    strokeColor: strokeColor,
    redWarning: const Color(0xFFFF0000),
    greenSuccess: const Color(0xFF00FF00),
    blueInfo: const Color(0xFF0000FF),
    accentOrange: accentOrange,
    accentMint: const Color(0xFF00FFAA),
    accentPurple: const Color(0xFFAA00FF),
  );
}

void main() {
  group('HomeWidgetPalette.fromTokens', () {
    test('encodes colors as #AARRGGBB hex strings', () {
      final palette = HomeWidgetPalette.fromTokens(_tokens());

      expect(palette.content, '#FF112233');
      expect(palette.contentSoft, '#FF445566');
      expect(palette.bg, '#FFFFFFFF');
      expect(palette.bgSoft, '#FFEEEEEE');
      expect(palette.strokeColor, '#80123456', reason: 'preserves alpha');
      expect(palette.accentOrange, '#FFFF8800');
    });

    test('toJson exposes the drawn tokens', () {
      final json = HomeWidgetPalette.fromTokens(_tokens()).toJson();

      expect(
        json.keys,
        containsAll(['content', 'contentMuted', 'bg', 'bgSoft', 'strokeColor', 'accentOrange']),
      );
    });
  });

  group('HomeWidgetPayload.lifeGrid', () {
    test('serialises grid counts and both palettes', () {
      final light = HomeWidgetPalette.fromTokens(_tokens(bg: const Color(0xFFFFFFFF)));
      final dark = HomeWidgetPalette.fromTokens(_tokens(bg: const Color(0xFF000000)));

      final raw = HomeWidgetPayload.lifeGrid(
        totalYears: 85,
        livedYears: 30,
        totalWeeks: 4420,
        livedWeeks: 1560,
        light: light,
        dark: dark,
      );
      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      expect(decoded['totalYears'], 85);
      expect(decoded['livedYears'], 30);
      expect(decoded['totalWeeks'], 4420);
      expect(decoded['livedWeeks'], 1560);
      expect((decoded['light'] as Map)['bg'], '#FFFFFFFF');
      expect((decoded['dark'] as Map)['bg'], '#FF000000');
    });
  });

  group('HomeWidgetPayload.yearGrid', () {
    test('serialises totalDays and a compact comma-separated fillSizes', () {
      final palette = HomeWidgetPalette.fromTokens(_tokens());

      final raw = HomeWidgetPayload.yearGrid(
        year: 2026,
        totalDays: 5,
        livedDays: 3,
        fillSizes: const [-2, -2, -3, -1, 4],
        light: palette,
        dark: palette,
      );
      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      expect(decoded['year'], 2026);
      expect(decoded['totalDays'], 5);
      expect(decoded['livedDays'], 3);
      expect(decoded['fillSizes'], '-2,-2,-3,-1,4');
    });

    test('fillSizes round-trips back to the original list', () {
      final palette = HomeWidgetPalette.fromTokens(_tokens());
      const sizes = [-1, 0, 1, 2, 3, 4, -2, -3];

      final raw = HomeWidgetPayload.yearGrid(
        year: 2026,
        totalDays: sizes.length,
        livedDays: 1,
        fillSizes: sizes,
        light: palette,
        dark: palette,
      );
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final parsed = (decoded['fillSizes'] as String).split(',').map(int.parse).toList();

      expect(parsed, sizes);
    });
  });
}

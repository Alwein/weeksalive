import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/home_widget/home_widget_grid_data.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';

import '../../fixtures/user_fixtures.dart';

void main() {
  final user = userFixture(dateOfBirth: DateTime(1990, 6, 15), lifespan: 85);
  final now = DateTime(2026, 6, 15);

  group('WallpaperGridData.build', () {
    test('life grid matches HomeWidgetGridData week grid', () {
      final data = WallpaperGridData.build(
        gridType: WallpaperGridType.life,
        user: user,
        entries: const [],
        at: now,
      );
      final grid = HomeWidgetGridData.weekGrid(
        dateOfBirth: user.dateOfBirth,
        projectedLifespanYears: user.lifespan,
        at: now,
        weekStartDay: user.weekStartDay,
      );

      expect(data.totalWeeks, grid.totalWeeks);
      expect(data.livedWeeks, grid.livedWeeks);
      expect(data.gridType, WallpaperGridType.life);
      expect(data.userName, user.name);
    });

    test('year grid uses same fillSizes encoding as HomeWidgetGridData', () {
      final recorded = DayEntry(
        date: DateTime(2026, 6, 10),
        sizeLevel: 3,
      );
      final data = WallpaperGridData.build(
        gridType: WallpaperGridType.year,
        user: user,
        entries: [recorded],
        at: now,
      );
      final expected = HomeWidgetGridData.yearFillSizes(entries: [recorded], now: now);

      expect(data.yearFillSizes, expected);
      expect(data.year, now.year);
      expect(data.totalDays, HomeWidgetGridData.yearTotalDays(now));
    });

    test('defaults lifespan when user is null', () {
      final data = WallpaperGridData.build(
        gridType: WallpaperGridType.life,
        user: null,
        entries: const [],
        at: now,
      );

      expect(data.totalWeeks, greaterThan(0));
      expect(data.livedWeeks, 0);
      expect(data.userName, '');
    });
  });
}

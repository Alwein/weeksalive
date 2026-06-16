import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/domain/home_widget/home_widget_grid_data.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';

/// Immutable snapshot of the numbers a wallpaper render needs, derived from the
/// user profile and recorded days. Reuses [HomeWidgetGridData] so the wallpaper
/// and the home-screen widgets stay perfectly in sync.
class WallpaperGridData {
  const WallpaperGridData({
    required this.gridType,
    required this.totalWeeks,
    required this.livedWeeks,
    required this.year,
    required this.totalDays,
    required this.livedDays,
    required this.yearFillSizes,
  });

  final WallpaperGridType gridType;

  // Life grid.
  final int totalWeeks;
  final int livedWeeks;

  // Year grid.
  final int year;
  final int totalDays;
  final int livedDays;

  /// Per-day fill encoding for the year grid (same convention as the in-app
  /// year view / home widget): `-3` today w/o record, `-2` past w/o record,
  /// `-1` future w/o record, `[0, 4]` recorded size level.
  final List<int> yearFillSizes;

  static WallpaperGridData build({
    required WallpaperGridType gridType,
    required User? user,
    required Iterable<DayEntry> entries,
    required DateTime at,
  }) {
    final lifespan = user?.lifespan ?? 85;
    final grid = HomeWidgetGridData.weekGrid(
      dateOfBirth: user?.dateOfBirth,
      projectedLifespanYears: lifespan,
      at: at,
      weekStartDay: user?.weekStartDay ?? DateTime.monday,
    );
    final fillSizes = HomeWidgetGridData.yearFillSizes(entries: entries, now: at);
    final totalDays = HomeWidgetGridData.yearTotalDays(at);

    return WallpaperGridData(
      gridType: gridType,
      totalWeeks: grid.totalWeeks,
      livedWeeks: grid.livedWeeks,
      year: at.year,
      totalDays: totalDays,
      livedDays: dayOfYearIndex(DateTime(at.year, at.month, at.day)) + 1,
      yearFillSizes: fillSizes,
    );
  }
}

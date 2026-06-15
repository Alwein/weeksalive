import 'package:home_widget/home_widget.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/domain/home_widget/home_widget_grid_data.dart';
import 'package:weeksalive/domain/home_widget/home_widget_payload.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:flutter/material.dart' show Brightness;

/// Pushes the data the home-screen widgets need to the shared store
/// (iOS App Group / Android SharedPreferences) and triggers a native reload.
///
/// The widgets are rendered 100% natively (SwiftUI on iOS, Jetpack Glance on
/// Android): this service no longer produces PNGs, it only serialises grid data
/// plus the resolved theme colors (light + dark) as JSON blobs. Failures are
/// swallowed so a widget update problem never breaks the app.
class HomeWidgetService {
  HomeWidgetService();

  /// iOS App Group shared between Runner and the widget extension.
  static const appGroupId = 'group.com.weeksalive';

  /// iOS WidgetKit kinds.
  static const _iosLifeGridKind = 'LifeGridWidget';
  static const _iosYearGridKind = 'YearGridWidget';

  /// Android provider class names (must match the manifest declarations).
  static const _androidLifeGridProvider = 'com.weeksalive.LifeGridWidgetReceiver';
  static const _androidYearGridProvider = 'com.weeksalive.YearGridWidgetReceiver';

  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await HomeWidget.setAppGroupId(appGroupId);
    _initialized = true;
  }

  /// Serialises the current [user]/[entries]/[selectedTheme] into the shared
  /// store and asks the native widgets to reload.
  Future<void> updateAll({
    required User? user,
    required Iterable<DayEntry> entries,
    required AppThemeId selectedTheme,
  }) async {
    try {
      await _ensureInitialized();

      final now = DateTime.now();
      final lifespan = user?.lifespan ?? 85;
      final grid = HomeWidgetGridData.weekGrid(
        dateOfBirth: user?.dateOfBirth,
        projectedLifespanYears: lifespan,
        at: now,
        weekStartDay: user?.weekStartDay ?? DateTime.monday,
      );
      final livedYears = HomeWidgetGridData.livedYears(
        dateOfBirth: user?.dateOfBirth,
        projectedLifespanYears: lifespan,
        at: now,
      );
      final yearFillSizes = HomeWidgetGridData.yearFillSizes(entries: entries, now: now);
      final yearTotalDays = HomeWidgetGridData.yearTotalDays(now);

      final light = HomeWidgetPalette.fromTokens(
        AppThemes.resolveTokens(selectedTheme, Brightness.light),
      );
      final dark = HomeWidgetPalette.fromTokens(
        AppThemes.resolveTokens(selectedTheme, Brightness.dark),
      );

      await HomeWidget.saveWidgetData<String>(
        HomeWidgetPayload.lifeGridKey,
        HomeWidgetPayload.lifeGrid(
          totalYears: lifespan,
          livedYears: livedYears,
          totalWeeks: grid.totalWeeks,
          livedWeeks: grid.livedWeeks,
          light: light,
          dark: dark,
        ),
      );
      await HomeWidget.saveWidgetData<String>(
        HomeWidgetPayload.yearGridKey,
        HomeWidgetPayload.yearGrid(
          year: now.year,
          totalDays: yearTotalDays,
          livedDays: dayOfYearIndex(DateTime(now.year, now.month, now.day)) + 1,
          fillSizes: yearFillSizes,
          light: light,
          dark: dark,
        ),
      );

      await HomeWidget.updateWidget(
        iOSName: _iosLifeGridKind,
        qualifiedAndroidName: _androidLifeGridProvider,
      );
      await HomeWidget.updateWidget(
        iOSName: _iosYearGridKind,
        qualifiedAndroidName: _androidYearGridProvider,
      );
    } catch (_) {
      // Home widgets are best-effort; never propagate update failures.
    }
  }
}

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_background_mode.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';
import 'package:weeksalive/presentation/widgets/week_grid_painter.dart';
import 'package:weeksalive/presentation/widgets/year_grid_painter.dart';

/// Renders the wallpaper content (background layer + grid) for a fixed logical
/// [size]. It is intentionally `BuildContext`-free for colors (everything is
/// resolved from [tokens]) so the exact same widget can be mounted on screen
/// for the live preview and off-screen for the PNG capture, producing an
/// identical result.
class WallpaperView extends StatelessWidget {
  const WallpaperView({
    super.key,
    required this.config,
    required this.data,
    required this.tokens,
    required this.size,
  });

  final WallpaperConfig config;
  final WallpaperGridData data;
  final AppColorTokens tokens;

  /// Logical size (points) of the canvas. The grid is centered within safe
  /// insets so it stays clear of the clock / home indicator.
  final Size size;

  static const _lifeColumns = 52;
  static const _lifeDotSpacing = 2.0;
  static const _yearColumns = 15;
  static const _yearDotSpacing = 4.0;

  Color get _gridColor => config.gridColor ?? tokens.content;
  Color get _bgColor => config.backgroundColor ?? tokens.bg;
  Color get _bgColorSecondary => config.backgroundColorSecondary ?? tokens.bgSoft;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildGrid(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    switch (config.backgroundMode) {
      case WallpaperBackgroundMode.solid:
        return ColoredBox(color: _bgColor);
      case WallpaperBackgroundMode.gradient:
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_bgColor, _bgColorSecondary],
            ),
          ),
        );
      case WallpaperBackgroundMode.image:
        final path = config.backgroundImagePath;
        if (path == null || !File(path).existsSync()) {
          return ColoredBox(color: _bgColor);
        }
        Widget image = Image.file(
          File(path),
          fit: BoxFit.cover,
          width: size.width,
          height: size.height,
          opacity: AlwaysStoppedAnimation(config.backgroundImageOpacity.clamp(0.0, 1.0)),
        );
        if (config.backgroundBlur > 0) {
          image = ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: config.backgroundBlur,
              sigmaY: config.backgroundBlur,
            ),
            child: image,
          );
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: _bgColor),
            image,
          ],
        );
    }
  }

  Widget _buildGrid() {
    // Reserve generous top/bottom margins so the grid avoids the lock-screen
    // clock and the home indicator. Tuned as fractions of the canvas height.
    final topInset = size.height * 0.22;
    final bottomInset = size.height * 0.12;
    final horizontalInset = size.width * 0.12;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalInset, topInset, horizontalInset, bottomInset),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final painter = switch (data.gridType) {
            WallpaperGridType.life => _lifePainter(constraints.maxWidth),
            WallpaperGridType.year => _yearPainter(constraints.maxWidth),
          };
          final exactHeight = switch (data.gridType) {
            WallpaperGridType.life => WeekGridPainter.computeHeight(
              availableWidth: constraints.maxWidth,
              totalWeeks: data.totalWeeks,
              columns: _lifeColumns,
              dotSpacing: _lifeDotSpacing,
            ),
            WallpaperGridType.year => YearGridPainter.computeHeight(
              availableWidth: constraints.maxWidth,
              totalDays: data.totalDays,
              columns: _yearColumns,
              dotSpacing: _yearDotSpacing,
            ),
          };

          return Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: constraints.maxWidth,
              height: exactHeight.clamp(0, constraints.maxHeight),
              child: CustomPaint(painter: painter),
            ),
          );
        },
      ),
    );
  }

  WeekGridPainter _lifePainter(double width) {
    return WeekGridPainter(
      columns: _lifeColumns,
      totalWeeks: data.totalWeeks,
      livedWeeks: data.livedWeeks,
      dotSpacing: _lifeDotSpacing,
      activeColor: _gridColor,
      inactiveColor: tokens.bgSoft,
      padding: EdgeInsets.zero,
    );
  }

  YearGridPainter _yearPainter(double width) {
    return YearGridPainter(
      columns: _yearColumns,
      totalDays: data.totalDays,
      dotSpacing: _yearDotSpacing,
      emptyStrokeColor: tokens.strokeColor,
      fillColor: _gridColor,
      pastEmptyColor: tokens.bgSoft,
      todayEmptyColor: tokens.accentOrange,
      filledCount: data.totalDays,
      fillSizes: data.yearFillSizes,
      padding: EdgeInsets.zero,
    );
  }
}

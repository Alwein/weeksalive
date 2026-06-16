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
    this.gridTokens,
    required this.size,
  });

  final WallpaperConfig config;
  final WallpaperGridData data;

  /// Color tokens for the background layer.
  final AppColorTokens tokens;

  /// Color tokens for the grid. Falls back to [tokens] when null.
  final AppColorTokens? gridTokens;

  /// Logical size (points) of the canvas. The grid is centered within safe
  /// insets so it stays clear of the clock / home indicator.
  final Size size;

  static const _lifeColumns = 52;
  static const _lifeDotSpacing = 2.0;
  static const _yearColumns = 15;
  static const _yearDotSpacing = 4.0;

  Color get _gridColor => config.gridColor ?? _gridTokens.content;
  Color get _solidBgColor => config.backgroundColor ?? tokens.bg;
  Color get _bgColorSecondary => config.backgroundColorSecondary ?? tokens.bgSoft;

  /// Backdrop shown behind a background image (opacity reveals this color).
  Color get _imageBackdropColor => config.backgroundColor ?? const Color(0xFF000000);

  AppColorTokens get _gridTokens => gridTokens ?? tokens;

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
        return ColoredBox(color: _solidBgColor);
      case WallpaperBackgroundMode.gradient:
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_solidBgColor, _bgColorSecondary],
            ),
          ),
        );
      case WallpaperBackgroundMode.image:
        final path = config.backgroundImagePath;
        if (path == null || !File(path).existsSync()) {
          return ColoredBox(color: _solidBgColor);
        }
        return _buildImageBackground(path);
    }
  }

  /// Bleed beyond the canvas so the blur kernel can sample real image pixels
  /// at the edges instead of transparent/backdrop color (which causes halos).
  static double _blurBleed(double sigma) => sigma > 0 ? sigma * 3 : 0;

  Widget _buildImageBackground(String path) {
    final opacity = config.backgroundImageOpacity.clamp(0.0, 1.0);
    final blur = config.backgroundBlur;

    if (blur <= 0) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: _imageBackdropColor),
          Opacity(
            opacity: opacity,
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              width: size.width,
              height: size.height,
            ),
          ),
        ],
      );
    }

    final bleed = _blurBleed(blur);
    final expandedWidth = size.width + bleed * 2;
    final expandedHeight = size.height + bleed * 2;

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        ColoredBox(color: _imageBackdropColor),
        Positioned(
          left: -bleed,
          top: -bleed,
          width: expandedWidth,
          height: expandedHeight,
          child: Opacity(
            opacity: opacity,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
                tileMode: TileMode.clamp,
              ),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                width: expandedWidth,
                height: expandedHeight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static const _gridTopInsetFraction = 0.24;
  static const _gridBottomInsetFraction = 0.12;
  static const _gridHorizontalInsetFraction = 0.12;

  Widget _buildGrid() {
    // Reserve generous top/bottom margins so the grid avoids the lock-screen
    // clock and the home indicator. Tuned as fractions of the canvas height.
    final topInset = size.height * _gridTopInsetFraction;
    final bottomInset = size.height * _gridBottomInsetFraction;
    final horizontalInset = size.width * _gridHorizontalInsetFraction;

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
      inactiveColor: _gridTokens.bgSoft,
      padding: EdgeInsets.zero,
    );
  }

  YearGridPainter _yearPainter(double width) {
    return YearGridPainter(
      columns: _yearColumns,
      totalDays: data.totalDays,
      dotSpacing: _yearDotSpacing,
      emptyStrokeColor: _gridTokens.strokeColor,
      fillColor: _gridColor,
      pastEmptyColor: _gridTokens.bgSoft,
      todayEmptyColor: _gridTokens.accentOrange,
      filledCount: data.totalDays,
      fillSizes: data.yearFillSizes,
      padding: EdgeInsets.zero,
    );
  }
}

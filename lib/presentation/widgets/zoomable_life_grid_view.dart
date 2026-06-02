import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';
import 'package:weeksalive/presentation/widgets/life_grid_view.dart';
import 'package:weeksalive/presentation/widgets/year_grid_painter.dart';

/// Pinch-driven crossfade between the life-in-weeks grid and the current civil year (days).
class ZoomableLifeGridView extends StatefulWidget {
  const ZoomableLifeGridView({
    super.key,
    required this.grid,
    this.padding = EdgeInsets.zero,
    this.onYearModeCommitted,
  });

  final LifeWeekGrid grid;
  final EdgeInsets padding;

  /// Called when a pinch ends with the resolved mode (after snap target is chosen).
  /// [true] = year (days) view, [false] = life (weeks) view.
  final ValueChanged<bool>? onYearModeCommitted;

  /// Pinch scale delta multiplier (tuned on device).
  /// Higher = less finger spread needed to cross the full 0→1 range (~scale 1.4 at 2.5).
  static const pinchSensitivity = 2.5;

  /// Progress at or above snaps to year view on gesture end.
  static const snapThreshold = 0.5;

  static const snapDuration = Duration(milliseconds: 220);

  /// Layers ignore pointers when mostly faded to avoid blocking the active view.
  static const pointerFadeEpsilon = 0.03;

  static const yearGridColumns = 15;
  static const yearGridDotSpacing = 4.0;

  @override
  State<ZoomableLifeGridView> createState() => ZoomableLifeGridViewState();
}

class ZoomableLifeGridViewState extends State<ZoomableLifeGridView> with SingleTickerProviderStateMixin {
  double _zoomProgress = 0;
  double _scaleBaseProgress = 0;

  double _snapStart = 0;
  double _snapEnd = 0;

  late final AnimationController _snapController;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(vsync: this, duration: ZoomableLifeGridView.snapDuration)
      ..addListener(_onSnapTick);
  }

  void _onSnapTick() {
    final t = Curves.easeOutCubic.transform(_snapController.value);
    setState(() {
      _zoomProgress = _snapStart + (_snapEnd - _snapStart) * t;
    });
  }

  void _onScaleStart(ScaleStartDetails details) {
    _snapController.stop();
    _scaleBaseProgress = _zoomProgress;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoomProgress = (_scaleBaseProgress + (details.scale - 1) * ZoomableLifeGridView.pinchSensitivity).clamp(
        0.0,
        1.0,
      );
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final target = _zoomProgress >= ZoomableLifeGridView.snapThreshold ? 1.0 : 0.0;
    widget.onYearModeCommitted?.call(target == 1.0);
    _startSnapTo(target);
  }

  void _startSnapTo(double target) {
    _snapEnd = target;
    _snapStart = _zoomProgress;
    if ((_snapStart - _snapEnd).abs() < 1e-6) return;
    _snapController.forward(from: 0);
  }

  void animateToWeekView() {
    _snapController.stop();
    _startSnapTo(0.0);
  }

  void animateToYearView() {
    _snapController.stop();
    _startSnapTo(1.0);
  }

  @override
  void dispose() {
    _snapController.removeListener(_onSnapTick);
    _snapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _zoomProgress.clamp(0.0, 1.0);
    final weekOpacity = (1.0 - p).clamp(0.0, 1.0);
    final yearOpacity = p.clamp(0.0, 1.0);

    final weekScale = lerpDouble(1.0, 0.96, p)!;
    final yearScale = lerpDouble(0.96, 1.0, p)!;

    const eps = ZoomableLifeGridView.pointerFadeEpsilon;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            ignoring: p > 1.0 - eps,
            child: Opacity(
              opacity: weekOpacity,
              child: Transform.scale(
                scale: weekScale,
                alignment: Alignment.center,
                child: LifeGridView(grid: widget.grid, padding: widget.padding),
              ),
            ),
          ),
          IgnorePointer(
            ignoring: p < eps,
            child: Opacity(
              opacity: yearOpacity,
              child: Transform.scale(
                scale: yearScale,
                alignment: Alignment.center,
                child: _YearDayGridLayer(padding: widget.padding),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YearDayGridLayer extends StatelessWidget {
  const _YearDayGridLayer({required this.padding});

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.bg(context);
    final strokeColor = AppColors.strokeColor(context);
    final fillColor = AppColors.content(context);
    final pastEmptyColor = AppColors.bgSoft(context);
    final now = DateTime.now();
    final totalDays = daysInGregorianYear(now.year);

    return StoreConnector<AppState, DayState>(
      converter: (store) => store.state.dayState,
      builder: (context, dayState) {
        final fillSizes = _fillSizesForYear(dayState, now, totalDays);

        return LayoutBuilder(
          builder: (context, constraints) {
            final exactHeight = YearGridPainter.computeHeight(
              availableWidth: constraints.maxWidth,
              totalDays: totalDays,
              columns: ZoomableLifeGridView.yearGridColumns,
              dotSpacing: ZoomableLifeGridView.yearGridDotSpacing,
              padding: padding,
            );
            final needsScroll = exactHeight > constraints.maxHeight;

            final scrollContent = SingleChildScrollView(
              child: SizedBox(
                width: constraints.maxWidth,
                height: exactHeight,
                child: CustomPaint(
                  painter: YearGridPainter(
                    columns: ZoomableLifeGridView.yearGridColumns,
                    totalDays: totalDays,
                    dotSpacing: ZoomableLifeGridView.yearGridDotSpacing,
                    emptyStrokeColor: strokeColor,
                    fillColor: fillColor,
                    pastEmptyColor: pastEmptyColor,
                    filledCount: totalDays,
                    fillSizes: fillSizes,
                    padding: padding,
                  ),
                ),
              ),
            );

            if (!needsScroll) return scrollContent;

            return ShaderMask(
              shaderCallback: (rect) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.0, 0.90, 1.0],
                colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
              ).createShader(rect),
              blendMode: BlendMode.dstOut,
              child: scrollContent,
            );
          },
        );
      },
    );
  }

  /// One entry per day of the year.
  /// - `-2` means "past day with no record" (drawn filled with [AppColors.bgSoft]).
  /// - `-1` means "future day with no record" (drawn as an empty circle).
  /// - `[0, 4]` is the recorded size level.
  static List<int> _fillSizesForYear(DayState dayState, DateTime now, int totalDays) {
    final year = now.year;
    final todayIndex = DateTime(now.year, now.month, now.day).difference(DateTime(year, 1, 1)).inDays;
    final sizes = List<int>.generate(totalDays, (i) => i < todayIndex ? -2 : -1);
    for (final entry in dayState.entries.values) {
      if (entry.date.year != year) continue;
      final dayOfYear = entry.date.difference(DateTime(year, 1, 1)).inDays;
      if (dayOfYear < 0 || dayOfYear >= totalDays) continue;
      sizes[dayOfYear] = entry.sizeLevel;
    }
    return sizes;
  }
}

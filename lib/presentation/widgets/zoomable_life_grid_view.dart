import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
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
    this.onPastDayTap,
  });

  final LifeWeekGrid grid;
  final EdgeInsets padding;

  /// Called when a pinch ends with the resolved mode (after snap target is chosen).
  /// [true] = year (days) view, [false] = life (weeks) view.
  final ValueChanged<bool>? onYearModeCommitted;

  /// Called when a past day cell is tapped in the year view, with its date and
  /// the recorded entry (null when the day has no record).
  final void Function(DateTime date, DayEntry? entry)? onPastDayTap;

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

  /// Duration of the single-dot scale-in played when a day is saved.
  static const appearDuration = Duration(milliseconds: 2000);

  @override
  State<ZoomableLifeGridView> createState() => ZoomableLifeGridViewState();
}

class ZoomableLifeGridViewState extends State<ZoomableLifeGridView> with TickerProviderStateMixin {
  double _zoomProgress = 0;
  double _scaleBaseProgress = 0;

  double _snapStart = 0;
  double _snapEnd = 0;

  late final AnimationController _snapController;
  late final AnimationController _appearController;

  int _appearIndex = -1;
  double _appearProgress = 1.0;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(vsync: this, duration: ZoomableLifeGridView.snapDuration)
      ..addListener(_onSnapTick);
    _appearController = AnimationController(vsync: this, duration: ZoomableLifeGridView.appearDuration)
      ..addListener(_onAppearTick);
  }

  void _onAppearTick() {
    setState(() {
      _appearProgress = Curves.easeOutBack.transform(_appearController.value);
    });
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

  TickerFuture? _startSnapTo(double target) {
    _snapEnd = target;
    _snapStart = _zoomProgress;
    if ((_snapStart - _snapEnd).abs() < 1e-6) return null;
    return _snapController.forward(from: 0);
  }

  Future<void> animateToWeekView() async {
    _snapController.stop();
    await _startSnapTo(0.0);
  }

  Future<void> animateToYearView() async {
    _snapController.stop();
    final snap = _startSnapTo(1.0);
    if (snap != null) {
      await snap;
      return;
    }
    // Already in year view: yield a frame so any pending "hidden" state
    // (progress 0) is painted before a subsequent scale-in animation starts.
    await WidgetsBinding.instance.endOfFrame;
  }

  void jumpToYearView() {
    _snapController.stop();
    setState(() {
      _zoomProgress = 1.0;
    });
  }

  /// Computes the day-of-year index for [date], or -1 if it is not in the
  /// current civil year / out of range.
  int _dayIndexForDate(DateTime date) {
    final now = DateTime.now();
    final normalized = DateTime(date.year, date.month, date.day);
    if (normalized.year != now.year) return -1;
    final index = dayOfYearIndex(normalized);
    final totalDays = daysInGregorianYear(now.year);
    if (index < 0 || index >= totalDays) return -1;
    return index;
  }

  /// Immediately hides the dot for [date] (progress 0) so it does not show at
  /// full size before [animateDayAppear] runs. Safe to call before switching
  /// to the year view.
  void prepareDayAppear(DateTime date) {
    final index = _dayIndexForDate(date);
    if (index < 0) return;
    setState(() {
      _appearIndex = index;
      _appearProgress = 0.0;
    });
  }

  /// Scales in the dot for [date] from 0, firing a haptic whose strength
  /// matches [sizeLevel]. Completes when the scale-in finishes.
  Future<void> animateDayAppear(DateTime date, int sizeLevel) async {
    final index = _dayIndexForDate(date);
    if (index < 0) return;

    setState(() {
      _appearIndex = index;
      _appearProgress = 0.0;
    });

    SensorialFeedback.dayAppear(sizeLevel);

    await _appearController.forward(from: 0);

    if (!mounted) return;
    setState(() {
      _appearIndex = -1;
      _appearProgress = 1.0;
    });
  }

  @override
  void dispose() {
    _snapController.removeListener(_onSnapTick);
    _snapController.dispose();
    _appearController.removeListener(_onAppearTick);
    _appearController.dispose();
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
                child: _YearDayGridLayer(
                  padding: widget.padding,
                  appearIndex: _appearIndex,
                  appearProgress: _appearProgress,
                  onPastDayTap: widget.onPastDayTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YearDayGridLayer extends StatelessWidget {
  const _YearDayGridLayer({
    required this.padding,
    this.appearIndex = -1,
    this.appearProgress = 1.0,
    this.onPastDayTap,
  });

  final EdgeInsets padding;
  final int appearIndex;
  final double appearProgress;
  final void Function(DateTime date, DayEntry? entry)? onPastDayTap;

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
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) => _handleTap(
                    localPosition: details.localPosition,
                    size: Size(constraints.maxWidth, exactHeight),
                    totalDays: totalDays,
                    now: now,
                    dayState: dayState,
                  ),
                  child: CustomPaint(
                    painter: YearGridPainter(
                      columns: ZoomableLifeGridView.yearGridColumns,
                      totalDays: totalDays,
                      dotSpacing: ZoomableLifeGridView.yearGridDotSpacing,
                      emptyStrokeColor: strokeColor,
                      fillColor: fillColor,
                      pastEmptyColor: pastEmptyColor,
                      todayEmptyColor: AppColors.accentOrange,
                      filledCount: totalDays,
                      fillSizes: fillSizes,
                      padding: padding,
                      appearIndex: appearIndex,
                      appearProgress: appearProgress,
                    ),
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

  /// Resolves the tapped cell to a date and routes it to the right callback:
  /// past days open the resume sheet, today opens the form, future days are
  /// ignored.
  void _handleTap({
    required Offset localPosition,
    required Size size,
    required int totalDays,
    required DateTime now,
    required DayState dayState,
  }) {
    final index = YearGridPainter.dayIndexAtPosition(
      localPosition: localPosition,
      size: size,
      totalDays: totalDays,
      columns: ZoomableLifeGridView.yearGridColumns,
      dotSpacing: ZoomableLifeGridView.yearGridDotSpacing,
      padding: padding,
    );
    if (index < 0) return;

    final todayIndex = dayOfYearIndex(now);
    final date = dateForDayOfYear(now.year, index);

    if (index <= todayIndex) {
      onPastDayTap?.call(date, dayState.entryFor(date));
    }
    // Future days: do nothing.
  }

  /// One entry per day of the year.
  /// - `-3` means "today with no record" (drawn filled with [AppColors.accentOrange]).
  /// - `-2` means "past day with no record" (drawn filled with [AppColors.bgSoft]).
  /// - `-1` means "future day with no record" (drawn as an empty circle).
  /// - `[0, 4]` is the recorded size level.
  static List<int> _fillSizesForYear(DayState dayState, DateTime now, int totalDays) {
    final year = now.year;
    final todayIndex = dayOfYearIndex(now);
    final sizes = List<int>.generate(totalDays, (i) {
      if (i < todayIndex) return -2;
      if (i == todayIndex) return -3;
      return -1;
    });
    for (final entry in dayState.entries.values) {
      if (entry.date.year != year) continue;
      final dayOfYear = dayOfYearIndex(entry.date);
      if (dayOfYear < 0 || dayOfYear >= totalDays) continue;
      sizes[dayOfYear] = entry.sizeLevel;
    }
    return sizes;
  }
}

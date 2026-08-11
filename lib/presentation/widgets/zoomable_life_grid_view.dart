import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';
import 'package:weeksalive/presentation/widgets/life_grid_view.dart';
import 'package:weeksalive/presentation/widgets/year_grid_painter.dart';

/// Swipeable life-in-weeks grid and current civil year (days), synced with a [TabController].
class ZoomableLifeGridView extends StatefulWidget {
  const ZoomableLifeGridView({
    super.key,
    required this.grid,
    required this.tabController,
    this.padding = EdgeInsets.zero,
    this.onPastDayTap,
  });

  final LifeWeekGrid grid;
  final TabController tabController;
  final EdgeInsets padding;

  /// Called when a past day cell is tapped in the year view, with its date and
  /// the recorded entry (null when the day has no record).
  final void Function(DateTime date, DayEntry? entry)? onPastDayTap;

  static const yearGridColumns = 15;
  static const yearGridDotSpacing = 4.0;
  static const tabletShortestSide = 600.0;

  /// Duration of the single-dot scale-in played when a day is saved.
  static const appearDuration = Duration(milliseconds: 2000);

  @override
  State<ZoomableLifeGridView> createState() => ZoomableLifeGridViewState();
}

class ZoomableLifeGridViewState extends State<ZoomableLifeGridView> with TickerProviderStateMixin {
  late final AnimationController _appearController;

  int _appearIndex = -1;
  double _appearProgress = 1.0;

  @override
  void initState() {
    super.initState();
    _appearController = AnimationController(vsync: this, duration: ZoomableLifeGridView.appearDuration)
      ..addListener(_onAppearTick);
  }

  void _onAppearTick() {
    setState(() {
      _appearProgress = Curves.easeOutBack.transform(_appearController.value);
    });
  }

  Future<void> animateToWeekView() => _animateToTab(0);

  Future<void> animateToYearView() => _animateToTab(1);

  Future<void> _animateToTab(int index) async {
    if (widget.tabController.index == index && !widget.tabController.indexIsChanging) {
      await WidgetsBinding.instance.endOfFrame;
      return;
    }
    final animation = widget.tabController.animation;
    if (animation == null) {
      widget.tabController.animateTo(index);
      await WidgetsBinding.instance.endOfFrame;
      return;
    }

    final completer = Completer<void>();
    void onStatus(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animation.removeStatusListener(onStatus);
        completer.complete();
      }
    }

    animation.addStatusListener(onStatus);
    widget.tabController.animateTo(index);
    await completer.future;
  }

  void jumpToYearView() {
    widget.tabController.index = 1;
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
    _appearController.removeListener(_onAppearTick);
    _appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      children: [
        LifeGridView(grid: widget.grid, padding: widget.padding),
        _YearDayGridLayer(
          padding: widget.padding,
          appearIndex: _appearIndex,
          appearProgress: _appearProgress,
          onPastDayTap: widget.onPastDayTap,
        ),
      ],
    );
  }
}

class _YearGridViewModel {
  const _YearGridViewModel({required this.dayState, required this.motif});

  final DayState dayState;
  final GridMotifId motif;
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

    return StoreConnector<AppState, _YearGridViewModel>(
      converter: (store) => _YearGridViewModel(
        dayState: store.state.dayState,
        motif: store.state.gridMotifState.selectedMotif,
      ),
      builder: (context, viewModel) {
        final dayState = viewModel.dayState;
        final fillSizes = _fillSizesForYear(dayState, now, totalDays);

        return LayoutBuilder(
          builder: (context, constraints) {
            final isLargeScreen =
                MediaQuery.sizeOf(context).shortestSide >= ZoomableLifeGridView.tabletShortestSide;
            final paintWidth = isLargeScreen
                ? math.min(
                    constraints.maxWidth,
                    YearGridPainter.computeWidthForHeight(
                      availableHeight: constraints.maxHeight,
                      totalDays: totalDays,
                      columns: ZoomableLifeGridView.yearGridColumns,
                      dotSpacing: ZoomableLifeGridView.yearGridDotSpacing,
                      padding: padding,
                    ),
                  )
                : constraints.maxWidth;
            final exactHeight = YearGridPainter.computeHeight(
              availableWidth: paintWidth,
              totalDays: totalDays,
              columns: ZoomableLifeGridView.yearGridColumns,
              dotSpacing: ZoomableLifeGridView.yearGridDotSpacing,
              padding: padding,
            );

            final gridPaint = SizedBox(
              width: paintWidth,
              height: exactHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) => _handleTap(
                  localPosition: details.localPosition,
                  size: Size(paintWidth, exactHeight),
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
                    motif: viewModel.motif,
                    fillColor: fillColor,
                    pastEmptyColor: pastEmptyColor,
                    todayEmptyColor: AppColors.accentOrange(context),
                    filledCount: totalDays,
                    fillSizes: fillSizes,
                    padding: padding,
                    appearIndex: appearIndex,
                    appearProgress: appearProgress,
                  ),
                ),
              ),
            );

            if (isLargeScreen) {
              return Align(alignment: Alignment.center, child: gridPaint);
            }

            final needsScroll = exactHeight > constraints.maxHeight;
            final scrollContent = SingleChildScrollView(child: gridPaint);

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

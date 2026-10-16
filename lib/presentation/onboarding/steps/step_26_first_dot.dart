import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/domain/year_grid/year_grid_fill_sizes.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/circle.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/year_grid_painter.dart';
import 'package:weeksalive/presentation/widgets/zoomable_life_grid_view.dart';

/// When the next check-in is due, as the step after the onboarding check-in
/// announces it.
enum NextCheckIn {
  /// Today, at the reminder the user picked.
  todayAtReminder,

  /// Today, the reminder time having already passed.
  today,

  /// Tomorrow, at the reminder: today is already done.
  tomorrowAtReminder,
}

NextCheckIn nextCheckInAfterOnboarding({
  required DayEntry? checkIn,
  required DateTime now,
  required TimeOfDay reminder,
}) {
  if (checkIn != null && checkIn.date == normalizeDay(now)) return NextCheckIn.tomorrowAtReminder;
  final beforeReminder = now.hour * 60 + now.minute < reminder.hour * 60 + reminder.minute;
  return beforeReminder ? NextCheckIn.todayAtReminder : NextCheckIn.today;
}

/// Feedback on the check-in just done: the user's real year grid, where their
/// first dot appears the way a saved day does at home, what they answered, and
/// when the next check-in is due. Without a check-in, the same grid shows
/// today's slot waiting.
class Step26FirstDot extends OnboardingStep {
  const Step26FirstDot();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) => const _FirstDot();
}

class _FirstDot extends StatefulWidget {
  const _FirstDot();

  @override
  State<_FirstDot> createState() => _FirstDotState();
}

class _FirstDotState extends State<_FirstDot> with SingleTickerProviderStateMixin {
  /// Lets the page transition end before the dot appears.
  static const _appearDelay = Duration(milliseconds: 450);

  /// Height kept for the texts around the grid, so the whole step fits on a
  /// phone without scrolling.
  static const _reservedHeight = 280.0;
  static const _minGridHeight = 160.0;
  static const _maxGridHeight = 460.0;

  late final AnimationController _appear;
  DayEntry? _checkIn;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _appear = AnimationController(vsync: this, duration: ZoomableLifeGridView.appearDuration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    final checkIn = OnboardingScope.read(context).firstCheckIn;
    _checkIn = checkIn;
    if (checkIn == null) return;

    Future<void>.delayed(_appearDelay, () {
      if (!mounted) return;
      SensorialFeedback.dayAppear(checkIn.sizeLevel);
      _appear.forward();
    });
  }

  @override
  void dispose() {
    _appear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final checkIn = _checkIn;
    final now = DateTime.now();
    final reminder = controller.preferredReminderTime;

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridHeight = (constraints.maxHeight - _reservedHeight).clamp(_minGridHeight, _maxGridHeight);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Margins.spacingS),
              Texts.onboardingXlBold(
                checkIn != null ? Strings.onboardingFirstDotTitle : Strings.onboardingFirstDotTitleWaiting,
              ),
              const SizedBox(height: Margins.spacingS),
              Texts.primaryMediumSoft(context, Strings.onboardingFirstDotSubtitle),
              const SizedBox(height: Margins.spacingM),
              Center(
                child: _YearGrid(
                  height: gridHeight,
                  appear: _appear,
                  appearDate: checkIn?.date,
                  now: now,
                ),
              ),
              const SizedBox(height: Margins.spacingM),
              if (checkIn != null) ...[
                _RecordedDay(entry: checkIn, now: now),
                const SizedBox(height: Margins.spacingS),
              ],
              _NextCheckInRow(
                next: nextCheckInAfterOnboarding(checkIn: checkIn, now: now, reminder: reminder),
                time: TimeUtils.formatTime(context, reminder),
              ),
              const SizedBox(height: Margins.spacingM),
            ],
          ),
        );
      },
    );
  }
}

/// The year as the home screen draws it, sized to fit [height].
class _YearGrid extends StatelessWidget {
  const _YearGrid({
    required this.height,
    required this.appear,
    required this.appearDate,
    required this.now,
  });

  final double height;
  final Animation<double> appear;
  final DateTime? appearDate;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final totalDays = daysInGregorianYear(now.year);
    final appearDate = this.appearDate;
    final appearIndex = appearDate != null && appearDate.year == now.year ? dayOfYearIndex(appearDate) : -1;

    return StoreConnector<AppState, ({Map<DateTime, DayEntry> entries, GridMotifId motif})>(
      converter: (store) => (
        entries: store.state.dayState.entries,
        motif: store.state.gridMotifState.selectedMotif,
      ),
      distinct: true,
      builder: (context, state) {
        final fillSizes = yearGridFillSizes(entries: state.entries.values, now: now);

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = YearGridPainter.computeWidthForHeight(
              availableHeight: height,
              totalDays: totalDays,
              columns: ZoomableLifeGridView.yearGridColumns,
              dotSpacing: ZoomableLifeGridView.yearGridDotSpacing,
            ).clamp(0.0, constraints.maxWidth);
            final gridHeight = YearGridPainter.computeHeight(
              availableWidth: width,
              totalDays: totalDays,
              columns: ZoomableLifeGridView.yearGridColumns,
              dotSpacing: ZoomableLifeGridView.yearGridDotSpacing,
            );

            return SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Texts.primaryXsCounter(context, Strings.thisYearLabel, now.year.toString()),
                  const SizedBox(height: Margins.spacingS),
                  SizedBox(
                    width: width,
                    height: gridHeight,
                    child: AnimatedBuilder(
                      animation: appear,
                      builder: (context, _) => CustomPaint(
                        painter: YearGridPainter(
                          columns: ZoomableLifeGridView.yearGridColumns,
                          totalDays: totalDays,
                          dotSpacing: ZoomableLifeGridView.yearGridDotSpacing,
                          emptyStrokeColor: AppColors.strokeColor(context),
                          motif: state.motif,
                          fillColor: AppColors.content(context),
                          pastEmptyColor: AppColors.bgSoft(context),
                          todayEmptyColor: AppColors.accentOrange(context),
                          filledCount: totalDays,
                          fillSizes: fillSizes,
                          appearIndex: appearIndex,
                          appearProgress: Curves.easeOutBack.transform(appear.value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// The day just recorded and what the user answered.
class _RecordedDay extends StatelessWidget {
  const _RecordedDay({required this.entry, required this.now});

  final DayEntry entry;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final isToday = entry.date == normalizeDay(now);

    return _LegendRow(
      marker: Circle(color: AppColors.content(context), size: 6.0 + entry.sizeLevel * 2),
      label: isToday ? Strings.onboardingFirstDotToday : Strings.onboardingFirstDotYesterday,
      // A new experience already shows in the size of the dot.
      trailing: const Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Margins.spacingBase,
        runSpacing: Margins.spacingXs,
        children: [],
      ),
    );
  }
}

class _NextCheckInRow extends StatelessWidget {
  const _NextCheckInRow({required this.next, required this.time});

  final NextCheckIn next;
  final String time;

  @override
  Widget build(BuildContext context) {
    // Same marks as the grid: today's open slot in the accent color, a day
    // ahead as an empty circle.
    final marker = next == NextCheckIn.tomorrowAtReminder
        ? Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.strokeColor(context), width: Dimens.strokeWidthS),
            ),
          )
        : Circle(color: AppColors.accentOrange(context), size: 10);

    return _LegendRow(
      marker: marker,
      label: switch (next) {
        NextCheckIn.todayAtReminder => Strings.onboardingFirstDotTodayAt(time),
        NextCheckIn.today => Strings.onboardingFirstDotToday,
        NextCheckIn.tomorrowAtReminder => Strings.onboardingFirstDotTomorrowAt(time),
      },
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.marker, required this.label, this.trailing});

  final Widget marker;
  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: Dimens.iconSizeS,
          child: Center(child: marker),
        ),
        const SizedBox(width: Margins.spacingS),
        Text(label, style: TextStyles.primarySmallBold.copyWith(color: AppColors.content(context))),
        if (trailing != null) ...[
          const SizedBox(width: Margins.spacingBase),
          Expanded(child: trailing),
        ],
      ],
    );
  }
}

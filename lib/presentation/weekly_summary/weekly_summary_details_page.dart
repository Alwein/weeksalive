import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/home/widgets/day_summaries.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/widgets/edit_weekly_intent_bottom_sheet.dart';
import 'package:weeksalive/presentation/weekly_summary/weekly_summary_page_view_model.dart';
import 'package:weeksalive/presentation/weekly_summary/weekly_summary_sheet.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class WeeklySummaryDetailsPage extends StatelessWidget {
  const WeeklySummaryDetailsPage({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WeeklySummaryPageViewModel>(
      converter: (store) => WeeklySummaryPageViewModel.create(store),
      builder: (context, viewModel) {
        return SheetContentScaffold(
          backgroundColor: AppColors.bg(context),
          topBar: WeeklySummaryTopBar(onClose: onClose),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Texts.xlBold(Strings.weeklySummaryDetailsPageTitle),
                  const SizedBox(height: Margins.spacingM),
                  _LastWeekCard(viewModel: viewModel),
                  const SizedBox(height: Margins.spacingM),
                  PrimaryButton(
                    text: Strings.weeklySummaryPageSeeMore,
                    onPressed: () {
                      onClose();
                      EditWeeklyIntentBottomSheet.show(context);
                    },
                  ),
                  const SizedBox(height: Margins.spacingS),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LastWeekCard extends StatelessWidget {
  const _LastWeekCard({required this.viewModel});
  final WeeklySummaryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      child: Column(
        children: [
          _CardHeader(
            weekNumber: viewModel.weekNumber,
            weekDates: viewModel.weekDates,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacingBase),
            child: Column(
              children: [
                const SizedBox(height: Margins.spacingBase),
                _Regularity(viewModel),
                const SizedBox(height: Margins.spacingBase),
                const SmallDivider(width: double.infinity),
                const SizedBox(height: Margins.spacingBase),
                _AverageFeeling(viewModel),
                const SizedBox(height: Margins.spacingBase),
                const SmallDivider(width: double.infinity),
                const SizedBox(height: Margins.spacingBase),
                IntrinsicHeight(
                  child: Row(
                    spacing: Margins.spacingBase,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _MeaningScore(viewModel),
                      ),
                      Container(
                        color: AppColors.strokeColor(context),
                        width: Dimens.strokeWidthS,
                      ),
                      Expanded(
                        child: _NewExperiences(viewModel),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Margins.spacingBase),
                const SmallDivider(width: double.infinity),
                const SizedBox(height: Margins.spacingBase),
                _LivingIntentions(viewModel),
                const SizedBox(height: Margins.spacingBase),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  const _CardContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        border: Border.all(color: AppColors.strokeColor(context), width: Dimens.strokeWidthS),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.weekNumber, required this.weekDates});
  final int weekNumber;
  final String weekDates;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingBase, vertical: Margins.spacingS),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimens.radiusL - Dimens.strokeWidthS),
          topRight: Radius.circular(Dimens.radiusL - Dimens.strokeWidthS),
        ),
        color: AppColors.bgSoft(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Texts.primaryXsCounter(context, Strings.weekLabel, "#${weekNumber.toString()}"),
          const SizedBox(height: Margins.spacingXs),
          Texts.primaryLargeBold(weekDates),
        ],
      ),
    );
  }
}

class _AverageFeeling extends StatelessWidget {
  const _AverageFeeling(this.viewModel);
  final WeeklySummaryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Texts.primaryRegularMedium(
          Strings.weeklySummaryPageAverageFeeling,
          color: AppColors.contentSoft(context),
        ),
        const SizedBox(height: Margins.spacingS),
        Row(
          children: [
            Expanded(child: _feelingRow(context, viewModel.lastWeekAverageFeelingScore)),
            const SizedBox(width: Margins.spacingS),
            if (viewModel.lastWeekAverageFeeling != null) FeelingSummary(value: viewModel.lastWeekAverageFeeling!),
          ],
        ),
      ],
    );
  }

  Widget _feelingRow(BuildContext context, double value) {
    const totalCircles = 5;
    const size = 16.0;
    const spacing = Margins.spacingXs;

    final filledColor = AppColors.content(context);
    final emptyColor = AppColors.bgSoft(context);

    return Row(
      children: [
        for (var i = 0; i < totalCircles; i++) ...[
          if (i > 0) const SizedBox(width: spacing),
          _FeelingScoreCircle(
            fillFraction: (value - i).clamp(0.0, 1.0),
            size: size,
            filledColor: filledColor,
            emptyColor: emptyColor,
          ),
        ],
      ],
    );
  }
}

class _FeelingScoreCircle extends StatelessWidget {
  const _FeelingScoreCircle({
    required this.fillFraction,
    required this.size,
    required this.filledColor,
    required this.emptyColor,
  });

  final double fillFraction;
  final double size;
  final Color filledColor;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: emptyColor, shape: BoxShape.circle),
            child: const SizedBox.expand(),
          ),
          if (fillFraction > 0)
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: fillFraction,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: filledColor, shape: BoxShape.circle),
                  child: SizedBox(width: size, height: size),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MeaningScore extends StatelessWidget {
  const _MeaningScore(this.viewModel);
  final WeeklySummaryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Texts.primaryRegularMedium(
          Strings.weeklySummaryPageMeaningScore,
          color: AppColors.contentSoft(context),
        ),
        const SizedBox(height: Margins.spacingS),
        _MeaningScoreCircle(score: viewModel.lastWeekAverageMeaningScore),
      ],
    );
  }
}

class _MeaningScoreCircle extends StatelessWidget {
  const _MeaningScoreCircle({required this.score});

  final double score;

  static const _diameter = 50.0;
  static const _strokeWidth = 4.0;
  static const _maxScore = 5.0;

  @override
  Widget build(BuildContext context) {
    final progress = (score / _maxScore).clamp(0.0, 1.0);
    final filledColor = AppColors.content(context);
    final emptyColor = AppColors.bgSoft(context);

    return SizedBox(
      width: _diameter,
      height: _diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(_diameter, _diameter),
            painter: _ScoreRingPainter(
              progress: progress,
              filledColor: filledColor,
              emptyColor: emptyColor,
              strokeWidth: _strokeWidth,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 0,
            children: [
              Text(
                _formatScore(score),
                style: TextStyles.primaryBold.copyWith(
                  height: 1,
                  color: AppColors.content(context),
                ),
              ),
              Text(
                '/ 5',
                style: TextStyles.primarySmallBold.copyWith(
                  height: 1,
                  color: AppColors.contentSoft(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatScore(double value) {
    final rounded = (value * 10).round() / 10;
    return rounded == rounded.roundToDouble() ? rounded.toInt().toString() : rounded.toStringAsFixed(1);
  }
}

class _ScoreRingPainter extends CustomPainter {
  const _ScoreRingPainter({
    required this.progress,
    required this.filledColor,
    required this.emptyColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color filledColor;
  final Color emptyColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - strokeWidth / 2,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = emptyColor;

    canvas.drawArc(rect, 0, 2 * pi, false, paint);

    if (progress <= 0) return;

    final gapAngle = (1 - progress) * 2 * pi;
    final startAngle = -pi / 2 + gapAngle / 2;

    paint.color = filledColor;
    canvas.drawArc(rect, startAngle, progress * 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.filledColor != filledColor ||
        oldDelegate.emptyColor != emptyColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _NewExperiences extends StatelessWidget {
  const _NewExperiences(this.viewModel);
  final WeeklySummaryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Texts.primaryRegularMedium(
          Strings.weeklySummaryPageNewExperiences,
          color: AppColors.contentSoft(context),
        ),
        const SizedBox(height: Margins.spacingS),
        Texts.xlBold(viewModel.lastWeekNewExperiencesCount.toString()),
      ],
    );
  }
}

class _LivingIntentions extends StatelessWidget {
  const _LivingIntentions(this.viewModel);
  final WeeklySummaryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Texts.primaryRegularMedium(
          Strings.weeklySummaryPageLivingIntentions,
          color: AppColors.contentSoft(context),
        ),
        const SizedBox(height: Margins.spacingS),
        Wrap(
          spacing: Margins.spacingS,
          runSpacing: Margins.spacingS,
          children: [
            for (final (count, label) in viewModel.lastWeekLivingIntentions) _IntentChip(count: count, label: label),
          ],
        ),
      ],
    );
  }
}

class _IntentChip extends StatelessWidget {
  const _IntentChip({
    required this.count,
    required this.label,
  });

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final fgColor = AppColors.contentSoftOnSoft(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingBase, vertical: Margins.spacingS),
      decoration: BoxDecoration(
        color: AppColors.bgSoft(context),
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: TextStyles.primarySmallMedium.copyWith(color: fgColor),
          ),
          const SizedBox(width: Margins.spacingS),
          Text(
            label,
            style: TextStyles.primarySmallMedium.copyWith(color: fgColor),
          ),
        ],
      ),
    );
  }
}

class _Regularity extends StatelessWidget {
  const _Regularity(this.viewModel);
  final WeeklySummaryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Texts.primaryRegularMedium(
          Strings.weeklySummaryPageRegularity,
          color: AppColors.contentSoft(context),
        ),
        const SizedBox(height: Margins.spacingS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final (dayLabel, sizeLevel) in viewModel.lastWeekDaySizes)
              _RegularityDayCell(dayLabel: dayLabel, sizeLevel: sizeLevel),
          ],
        ),
      ],
    );
  }
}

class _RegularityDayCell extends StatelessWidget {
  const _RegularityDayCell({
    required this.dayLabel,
    required this.sizeLevel,
  });

  final String dayLabel;
  final int? sizeLevel;

  static const _cellSize = 32.0;
  static const _minDotSize = 8.0;

  double _dotSize(int level) {
    if (level <= 0) return _minDotSize;
    if (level >= 4) return _cellSize;
    return _minDotSize + (_cellSize - _minDotSize) * (level / 4);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _cellSize,
          height: _cellSize,
          child: Center(
            child: sizeLevel != null
                ? Container(
                    width: _dotSize(sizeLevel!),
                    height: _dotSize(sizeLevel!),
                    decoration: BoxDecoration(
                      color: AppColors.content(context),
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(
                    width: _cellSize,
                    height: _cellSize,
                    decoration: BoxDecoration(
                      color: AppColors.bgSoft(context),
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: Margins.spacingXs),
        Text(
          dayLabel,
          style: TextStyles.primaryXsBold.copyWith(color: AppColors.contentSoft(context)),
        ),
      ],
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/home/view_model/home_page_view_model.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/weekly_summary/weekly_summary_sheet.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/week_grid_painter.dart';

class WeeklySummaryCompletePage extends StatelessWidget {
  const WeeklySummaryCompletePage({
    super.key,
    required this.onClose,
    required this.onContinue,
  });

  final VoidCallback onClose;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SheetContentScaffold(
      backgroundColor: AppColors.bg(context),
      topBar: WeeklySummaryTopBar(onClose: onClose),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Texts.xlBold(Strings.weeklySummaryPageTitle, textAlign: TextAlign.center),
            const SizedBox(height: Margins.spacingS),
            Texts.primaryMediumSoft(context, Strings.weeklySummaryPageSubtitle, textAlign: TextAlign.center),
            const SizedBox(height: Margins.spacingHuge),
            const _DotsLine(),
            const SizedBox(height: Margins.spacingHuge),
            PrimaryButton(
              text: Strings.continueString,
              onPressed: () {
                SensorialFeedback.navigationChanged();
                onContinue();
              },
            ),
            const SizedBox(height: Margins.spacingS),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class _DotsLine extends StatelessWidget {
  const _DotsLine();

  static const _columns = 52;
  static const _dotSpacing = 2.0;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LifeWeekGrid>(
      converter: (store) => HomePageViewModel.create(store).lifeWeekGrid,
      builder: (context, grid) {
        if (grid.livedWeeks <= 0) return const SizedBox.shrink();

        final completedIndex = grid.livedWeeks - 1;
        final currentRow = completedIndex ~/ _columns;
        final rowStart = currentRow * _columns;
        final weeksInRow = math.min(_columns, grid.totalWeeks - rowStart);
        final livedInRow = math.min(weeksInRow, grid.livedWeeks - rowStart);
        final completedColumn = livedInRow - 1;

        final String year = DateTime.now().year.toString();

        final weekInYear = livedInRow;
        final weeksInYear = weeksInRow;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Texts.primaryXsCounter(context, Strings.yearLabel, year),
                Texts.primaryXsCounter(context, Strings.weekLabel, '$weekInYear/$weeksInYear'),
              ],
            ),
            const SizedBox(height: Margins.spacingS),
            LayoutBuilder(
              builder: (context, constraints) {
                final dotSize = (constraints.maxWidth - _dotSpacing * (weeksInRow - 1)) / weeksInRow;
                return SizedBox(
                  height: dotSize,
                  width: constraints.maxWidth,
                  child: CustomPaint(
                    painter: WeekGridPainter(
                      columns: weeksInRow,
                      totalWeeks: weeksInRow,
                      livedWeeks: livedInRow,
                      dotSpacing: _dotSpacing,
                      activeColor: AppColors.content(context),
                      inactiveColor: AppColors.bgSoft(context),
                      padding: EdgeInsets.zero,
                      highlightedDots: [completedColumn],
                      highlightColor: AppColors.accentOrange(context),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

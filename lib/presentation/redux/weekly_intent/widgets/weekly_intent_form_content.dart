import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/widgets/edit_all_intents_bottom_sheet.dart';

class WeeklyIntentFormContent extends StatelessWidget {
  const WeeklyIntentFormContent({
    super.key,
    required this.selectedIds,
    required this.onIntentToggled,
  });

  final Set<String> selectedIds;
  final ValueChanged<String> onIntentToggled;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<WeeklyIntent>>(
      converter: (store) => store.state.weeklyIntentState.availableIntents,
      builder: (context, intents) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: Margins.spacingS,
              runSpacing: Margins.spacingS,
              children: [
                for (final intent in intents)
                  _IntentChip(
                    label: intent.localizedLabel,
                    selected: selectedIds.contains(intent.id),
                    onTap: () {
                      SensorialFeedback.selectionChanged();
                      onIntentToggled(intent.id);
                    },
                  ),
              ],
            ),
            const SizedBox(height: Margins.spacingL),
            Center(
              child: TextButton(
                onPressed: () => EditAllIntentsSheet.show(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      MingCuteIcons.mgc_pencil_line,
                      size: Dimens.iconSizeXs,
                      color: AppColors.contentSoft(context),
                    ),
                    const SizedBox(width: Margins.spacingXs),
                    Text(
                      Strings.editList,
                      style: TextStyles.primarySmallBold.copyWith(color: AppColors.contentSoft(context)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _IntentChip extends StatelessWidget {
  const _IntentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? AppColors.content(context) : AppColors.bgSoft(context);
    final fgColor = selected ? AppColors.contentMuted(context) : AppColors.content(context);

    final Widget leading = selected
        ? _SelectedIntentDot(color: fgColor)
        : _DashedCircle(color: AppColors.contentSoftOnSoft(context), size: Dimens.iconSizeXs);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(Margins.spacingBase),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Dimens.radiusXl),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            const SizedBox(width: Margins.spacingS),
            Text(
              label,
              style: TextStyles.primarySmallMedium.copyWith(color: fgColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedIntentDot extends StatelessWidget {
  const _SelectedIntentDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.iconSizeXs,
      height: Dimens.iconSizeXs,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        MingCuteIcons.mgc_check_line,
        size: 12,
        color: AppColors.content(context),
      ),
    );
  }
}

class _DashedCircle extends StatelessWidget {
  const _DashedCircle({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DashedCirclePainter(color: color),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - paint.strokeWidth / 2;

    const dashCount = 8;
    const sweepPerDash = (2 * math.pi) / dashCount;
    const dashSweep = sweepPerDash * 0.55;

    for (int i = 0; i < dashCount; i++) {
      final start = i * sweepPerDash;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        dashSweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) => oldDelegate.color != color;
}

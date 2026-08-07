import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

class FeelingSummary extends StatelessWidget {
  const FeelingSummary({super.key, required this.value});

  final AverageFeeling value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          value.icon,
          size: Dimens.iconSizeXs,
          color: AppColors.content(context),
        ),
        const SizedBox(width: Margins.spacingS),
        Flexible(
          child: Text(
            value.label,
            style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class MeaningSummary extends StatelessWidget {
  const MeaningSummary({super.key, required this.value});

  final MeaningScore value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MeaningBars(filled: value.filledBars, color: AppColors.content(context), size: Dimens.iconSizeXs),
        const SizedBox(width: Margins.spacingS),
        Flexible(
          child: Text(
            value.label,
            style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class MeaningBars extends StatelessWidget {
  const MeaningBars({super.key, required this.filled, required this.color, this.size = Dimens.iconSizeBase});

  final int filled;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    const totalBars = 5;
    const baseHeight = 6.0;
    const heightStep = 4.0;

    return Transform.scale(
      scale: size / Dimens.iconSizeBase,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < totalBars; i++) ...[
            if (i < filled) ...[
              if (i > 0) const SizedBox(width: 3),
              Container(
                width: 3,
                height: baseHeight + heightStep * i,
                decoration: BoxDecoration(
                  color: i < filled ? color : color.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class NewExperienceSummary extends StatelessWidget {
  const NewExperienceSummary({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value ? Strings.newExperienceSectionValueYes : Strings.newExperienceSectionValueNo,
      style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.end,
    );
  }
}

class LivingIntentionsSummary extends StatelessWidget {
  const LivingIntentionsSummary({super.key, required this.selectedIds});

  final Set<String> selectedIds;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<WeeklyIntent>>(
      converter: (store) => store.state.weeklyIntentState.availableIntents,
      builder: (context, intents) {
        final labels = selectedIds.map((id) => intents.firstWhere((i) => i.id == id).label).join(', ');
        return Text(
          labels,
          style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
        );
      },
    );
  }
}

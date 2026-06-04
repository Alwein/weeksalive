import 'package:flutter/material.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/circle.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';

class DayResumeBottomSheet extends StatelessWidget {
  const DayResumeBottomSheet({super.key, required this.entry, required this.date});
  final DayEntry? entry;
  final DateTime date;

  static Future<void> show(BuildContext context, {required DateTime date, DayEntry? entry}) {
    return showCustomBottomSheet<void>(
      context,
      (sheetContext) => DayResumeBottomSheet(entry: entry, date: date),
    );
  }

  @override
  Widget build(BuildContext context) {
    return entry == null ? _EmptyDayContent(date: date) : const _FilledDayContent();
  }
}

class _EmptyDayContent extends StatelessWidget {
  const _EmptyDayContent({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Circle(color: AppColors.strokeColor(context), size: Dimens.iconSizeM),
          const SizedBox(height: Margins.spacingM),
          Text(
            TimeUtils.formatDate(context, date),
            textAlign: TextAlign.center,
            style: TextStyles.primarySemiBold.copyWith(
              color: AppColors.content(context),
            ),
          ),
          const SizedBox(height: Margins.spacingS),
          Text(
            Strings.dayResumeBottomSheetEmptySubtitle,
            textAlign: TextAlign.center,
            style: TextStyles.primaryRegularMedium.copyWith(
              color: AppColors.contentSoft(context),
            ),
          ),
          const SizedBox(height: Margins.spacingM),
          const SizedBox(
            height: 160,
            child: OverflowBox(
              maxHeight: 220,
              alignment: Alignment.bottomCenter,
              child: ParallaxRive(
                maxOffset: 0,
                assetPath: "assets/animations/outline_looking_up.riv",
              ),
            ),
          ),
          PrimaryButton(
            text: Strings.startTracking,
            onPressed: () {
              Navigator.of(context).pop();
              DayForm.showBottomSheet(context, date);
            },
          ),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}

class _FilledDayContent extends StatelessWidget {
  const _FilledDayContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Filled day content'),
      ],
    );
  }
}

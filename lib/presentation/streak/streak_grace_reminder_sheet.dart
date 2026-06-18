import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/home/widgets/day_resume_bottom_sheet/day_resume_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class StreakGraceReminderSheet extends StatelessWidget {
  const StreakGraceReminderSheet({super.key, required this.yesterday});

  final DateTime yesterday;

  static Future<void> show(BuildContext context) {
    final yesterday = normalizeDay(DateTime.now()).subtract(const Duration(days: 1));
    return showCustomBottomSheet<void>(
      context,
      (context) => StreakGraceReminderSheet(yesterday: yesterday),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            MingCuteIcons.mgc_hours_line,
            size: Dimens.iconSizeHuge,
            color: AppColors.content(context),
          ),
          const SizedBox(height: Margins.spacingM),
          Texts.xlBold(Strings.streakGraceReminderTitle),
          const SizedBox(height: Margins.spacingS),
          Texts.primaryMediumSoft(context, Strings.streakGraceReminderBody),
          const SizedBox(height: Margins.spacingM),
          PrimaryButton(
            text: Strings.streakGraceReminderLogYesterday,
            onPressed: () {
              Navigator.of(context).pop();
              DayResumeBottomSheet.show(context, date: yesterday);
            },
          ),
          const SizedBox(height: Margins.spacingS),
          SecondaryButton(
            text: Strings.streakGraceReminderDismiss,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}

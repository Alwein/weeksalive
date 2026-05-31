import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step21WeekBegin extends OnboardingStep {
  const Step21WeekBegin();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) => const _Step21Content();
}

enum _WeekBeginChoice { monday, birthday, custom }

class _Step21Content extends StatefulWidget {
  const _Step21Content();

  @override
  State<_Step21Content> createState() => _Step21ContentState();
}

class _Step21ContentState extends State<_Step21Content> {
  late _WeekBeginChoice _choice;

  @override
  void initState() {
    super.initState();
    _choice = _WeekBeginChoice.monday;
  }

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final dateOfBirth = controller.dateOfBirth;

    final birthdayWeekdayLabel = dateOfBirth != null ? _isoWeekdayName(dateOfBirth.weekday) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Texts.xlBold(Strings.onboardingWeekBeginTitle),
                const SizedBox(height: Margins.spacingS),
                Texts.primaryMediumSoft(context, Strings.onboardingWeekBeginSubtitle),
                const SizedBox(height: Margins.spacingL),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _WeekStartOption(
                          label: Strings.onboardingWeekBeginMonday,
                          selected: _choice == _WeekBeginChoice.monday,
                          onTap: () {
                            setState(() => _choice = _WeekBeginChoice.monday);
                            controller.setWeekStartDay(DateTime.monday);
                          },
                        ),
                        const SizedBox(height: Margins.spacingBase),
                        if (birthdayWeekdayLabel != null) ...[
                          _WeekStartOption(
                            label: Strings.onboardingWeekBeginBirthday(birthdayWeekdayLabel),
                            selected: _choice == _WeekBeginChoice.birthday,
                            onTap: () {
                              setState(() => _choice = _WeekBeginChoice.birthday);
                              controller.setWeekStartDay(dateOfBirth!.weekday);
                            },
                          ),
                          const SizedBox(height: Margins.spacingBase),
                        ],
                        _WeekStartOption(
                          label: Strings.onboardingWeekBeginCustom,
                          selected: _choice == _WeekBeginChoice.custom,
                          onTap: () {
                            setState(() => _choice = _WeekBeginChoice.custom);
                            final day = controller.weekStartDay;
                            final isPresetDay =
                                day == DateTime.monday ||
                                (dateOfBirth != null && day == dateOfBirth.weekday);
                            controller.setWeekStartDay(isPresetDay ? DateTime.monday : day);
                          },
                        ),
                        if (_choice == _WeekBeginChoice.custom) ...[
                          const SizedBox(height: Margins.spacingM),
                          _WeekdayPicker(
                            selectedDay: controller.weekStartDay,
                            onChanged: (day) => controller.setWeekStartDay(day),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SmallDivider(),
                const SizedBox(height: Margins.spacingM),
                Texts.primaryMediumSoft(context, Strings.onboardingWeekBeginFooter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _isoWeekdayName(int weekday) => Strings.weekdayFullNames[(weekday - 1).clamp(0, 6)];
}

class _WeekStartOption extends StatelessWidget {
  const _WeekStartOption({
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
    final fgColor = selected ? AppColors.contentMuted(context) : AppColors.contentSoftOnSoft(context);

    return GestureDetector(
      onTap: () {
        SensorialFeedback.selectionChanged();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: Margins.spacingM),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Margins.spacingBase),
        ),
        alignment: Alignment.center,
        child: Texts.primaryMedium(label, color: fgColor),
      ),
    );
  }
}

class _WeekdayPicker extends StatelessWidget {
  const _WeekdayPicker({
    required this.selectedDay,
    required this.onChanged,
  });

  final int selectedDay;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final days = Strings.weekdayShortNames;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < days.length; i++)
          _DayChip(
            label: days[i],
            selected: selectedDay == i + 1,
            onTap: () {
              SensorialFeedback.selectionChanged();
              onChanged(i + 1);
            },
          ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
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
    final fgColor = selected ? AppColors.contentMuted(context) : AppColors.contentSoftOnSoft(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Margins.spacingBase),
        ),
        alignment: Alignment.center,
        child: Texts.primaryXsMedium(label, color: fgColor),
      ),
    );
  }
}

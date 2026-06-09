import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

enum WeekBeginChoice { monday, birthday, custom }

class WeekBeginPicker extends StatefulWidget {
  const WeekBeginPicker({
    super.key,
    required this.dateOfBirth,
    required this.onWeekStartDaySelected,
    this.initialChoice,
    this.selectedWeekStartDay,
  });

  final DateTime? dateOfBirth;
  final ValueChanged<int> onWeekStartDaySelected;

  /// When null, no preset option is highlighted (profile flow).
  final WeekBeginChoice? initialChoice;

  /// ISO weekday (1 = Monday … 7 = Sunday) highlighted in the custom picker.
  final int? selectedWeekStartDay;

  @override
  State<WeekBeginPicker> createState() => _WeekBeginPickerState();
}

class _WeekBeginPickerState extends State<WeekBeginPicker> {
  WeekBeginChoice? _choice;
  int? _customDay;

  @override
  void initState() {
    super.initState();
    _choice = widget.initialChoice;
    _customDay = widget.selectedWeekStartDay;
  }

  @override
  void didUpdateWidget(WeekBeginPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedWeekStartDay != oldWidget.selectedWeekStartDay) {
      _customDay = widget.selectedWeekStartDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateOfBirth = widget.dateOfBirth;
    final birthdayWeekdayLabel = dateOfBirth != null ? _isoWeekdayName(dateOfBirth.weekday) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WeekStartOption(
          label: Strings.onboardingWeekBeginMonday,
          selected: _choice == WeekBeginChoice.monday,
          onTap: () {
            setState(() => _choice = WeekBeginChoice.monday);
            widget.onWeekStartDaySelected(DateTime.monday);
          },
        ),
        const SizedBox(height: Margins.spacingBase),
        if (birthdayWeekdayLabel != null) ...[
          _WeekStartOption(
            label: Strings.onboardingWeekBeginBirthday(birthdayWeekdayLabel),
            selected: _choice == WeekBeginChoice.birthday,
            onTap: () {
              setState(() => _choice = WeekBeginChoice.birthday);
              widget.onWeekStartDaySelected(dateOfBirth!.weekday);
            },
          ),
          const SizedBox(height: Margins.spacingBase),
        ],
        _WeekStartOption(
          label: Strings.onboardingWeekBeginCustom,
          selected: _choice == WeekBeginChoice.custom,
          onTap: () {
            setState(() {
              _choice = WeekBeginChoice.custom;
              final day = _customDay ?? widget.selectedWeekStartDay;
              final isPresetDay =
                  day == DateTime.monday || (dateOfBirth != null && day == dateOfBirth.weekday);
              _customDay = isPresetDay ? DateTime.monday : day;
            });
          },
        ),
        if (_choice == WeekBeginChoice.custom) ...[
          const SizedBox(height: Margins.spacingM),
          _WeekdayPicker(
            selectedDay: _customDay,
            onChanged: (day) {
              setState(() => _customDay = day);
              widget.onWeekStartDaySelected(day);
            },
          ),
        ],
      ],
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

  final int? selectedDay;
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

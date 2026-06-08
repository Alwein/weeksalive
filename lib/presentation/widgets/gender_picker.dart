import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class GenderPicker extends StatelessWidget {
  const GenderPicker({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  final Gender? selectedGender;
  final ValueChanged<Gender> onGenderSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Margins.spacingBase,
      children: [
        for (final g in Gender.values)
          Expanded(
            child: _GenderChip(
              label: g.titleCase,
              selected: selectedGender == g,
              onTap: () => onGenderSelected(g),
            ),
          ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
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
        child: Texts.primaryMedium(
          label,
          color: fgColor,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class SegmentedChipPicker extends StatelessWidget {
  const SegmentedChipPicker({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Margins.spacingBase,
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: _SegmentedChip(
              label: labels[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
          ),
      ],
    );
  }
}

class _SegmentedChip extends StatelessWidget {
  const _SegmentedChip({
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

import 'package:flutter/material.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/widgets/segmented_chip_picker.dart';

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
    final selectedIndex = selectedGender != null ? Gender.values.indexOf(selectedGender!) : -1;

    return SegmentedChipPicker(
      labels: [for (final g in Gender.values) g.titleCase],
      selectedIndex: selectedIndex,
      onSelected: (index) => onGenderSelected(Gender.values[index]),
    );
  }
}

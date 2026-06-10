import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/theme_picker.dart';

class ThemePickerPage extends StatelessWidget {
  const ThemePickerPage({super.key});

  static Future<void> show(BuildContext context) {
    return showCustomBottomSheet<void>(
      context,
      (sheetContext) => const ThemePickerPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Texts.xlBold(Strings.profilePageTheme),
          const SizedBox(height: Margins.spacingBase),
          const ThemePicker(showTitle: false),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/theme_picker.dart';

class ThemePickerPage extends StatelessWidget {
  const ThemePickerPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (context) => const ThemePickerPage(),
    );
  }

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        backgroundColor: AppColors.bg(context),
        appBar: PrimaryAppBar(title: Strings.profilePageTheme),
        body: const SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: Margins.spacingM),
          child: ThemePicker(),
        ),
      ),
    );
  }
}

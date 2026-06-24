import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/profile/pages/grid_motif_picker/grid_motif_picker.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';

class GridMotifPickerPage extends StatelessWidget {
  const GridMotifPickerPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (context) => const GridMotifPickerPage(),
    );
  }

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.profilePageGridMotif),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: Margins.spacingM),
        child: GridMotifPicker(),
      ),
    );
  }
}

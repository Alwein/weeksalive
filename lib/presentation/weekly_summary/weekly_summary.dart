import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';

class WeeklySummaryPage extends StatelessWidget {
  const WeeklySummaryPage({super.key});

  static show(BuildContext context) {
    return showCustomBottomSheet<void>(
      context,
      (context) => const WeeklySummaryPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Placeholder(),
    );
  }
}

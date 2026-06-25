import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/weekly_summary/weekly_summary_sheet.dart';

class WeeklySummaryPage {
  WeeklySummaryPage._();

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onDismissed,
  }) {
    return showWeeklySummarySheet(context, onDismissed: onDismissed);
  }
}

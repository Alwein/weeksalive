import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TimeUtils {
  static String formatDate(BuildContext context, DateTime date) {
    return DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date);
  }

  static String formatTime(BuildContext context, TimeOfDay time, {int minutesOffset = 0}) {
    return DateFormat.Hm(
      Localizations.localeOf(context).toString(),
    ).format(DateTime(0, 0, 0, time.hour, time.minute + minutesOffset));
  }
}

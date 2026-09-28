import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TimeUtils {
  static String formatDate(BuildContext context, DateTime date) {
    return DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date);
  }

  /// Locale clock (12-hour for en-US, 24-hour for fr-FR), unless the device
  /// itself is set to a 24-hour clock.
  static bool prefers24HourFormat(BuildContext context) {
    if (MediaQuery.alwaysUse24HourFormatOf(context)) {
      return true;
    }
    return switch (MaterialLocalizations.of(context).timeOfDayFormat()) {
      TimeOfDayFormat.h_colon_mm_space_a || TimeOfDayFormat.a_space_h_colon_mm => false,
      TimeOfDayFormat.H_colon_mm ||
      TimeOfDayFormat.HH_colon_mm ||
      TimeOfDayFormat.HH_dot_mm ||
      TimeOfDayFormat.frenchCanadian => true,
    };
  }

  static String formatTime(BuildContext context, TimeOfDay time, {int minutesOffset = 0}) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      _withMinutesOffset(time, minutesOffset),
      alwaysUse24HourFormat: prefers24HourFormat(context),
    );
  }

  static TimeOfDay _withMinutesOffset(TimeOfDay time, int minutesOffset) {
    if (minutesOffset == 0) return time;
    const minutesInDay = 24 * 60;
    final totalMinutes = time.hour * 60 + time.minute + minutesOffset;
    final normalized = ((totalMinutes % minutesInDay) + minutesInDay) % minutesInDay;
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }
}

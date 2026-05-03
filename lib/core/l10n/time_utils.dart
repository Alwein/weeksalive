import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class TimeUtils {
  static String formatDate(BuildContext context, DateTime date) {
    return DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date);
  }
}

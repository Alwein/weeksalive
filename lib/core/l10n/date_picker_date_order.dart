import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

DatePickerDateOrder datePickerDateOrderForLocale(Locale locale) {
  try {
    final format = DateFormat.yMd(locale.toString());
    final pattern = format.pattern;
    if (pattern == null || pattern.isEmpty) {
      return DatePickerDateOrder.dmy;
    }
    final order = _yearMonthDayOrderFromIcuPattern(pattern);
    return switch (order) {
      _YmdOrder.ymd => DatePickerDateOrder.ymd,
      _YmdOrder.mdy => DatePickerDateOrder.mdy,
      _YmdOrder.dmy => DatePickerDateOrder.dmy,
    };
  } catch (_) {
    return DatePickerDateOrder.dmy;
  }
}

enum _YmdOrder { ymd, mdy, dmy }

_YmdOrder _yearMonthDayOrderFromIcuPattern(String pattern) {
  var i = 0;
  var sawYear = false;
  var sawMonth = false;
  var sawDay = false;
  final appearance = <_YmdToken>[];

  while (i < pattern.length) {
    final unit = pattern.codeUnitAt(i);
    if (unit == 0x27) {
      i++;
      if (i < pattern.length && pattern.codeUnitAt(i) == 0x27) {
        i += 2;
        continue;
      }
      while (i < pattern.length && pattern.codeUnitAt(i) != 0x27) {
        i++;
      }
      if (i < pattern.length) i++;
      continue;
    }

    final ch = pattern[i];
    if (ch == 'y' || ch == 'Y') {
      if (!sawYear) {
        sawYear = true;
        appearance.add(_YmdToken.year);
      }
    } else if (ch == 'M' || ch == 'L') {
      if (!sawMonth) {
        sawMonth = true;
        appearance.add(_YmdToken.month);
      }
    } else if (ch == 'd') {
      if (!sawDay) {
        sawDay = true;
        appearance.add(_YmdToken.day);
      }
    }
    i++;
  }

  if (!sawYear || !sawMonth || !sawDay) {
    return _YmdOrder.dmy;
  }

  return switch (appearance.first) {
    _YmdToken.year => _YmdOrder.ymd,
    _YmdToken.month => _YmdOrder.mdy,
    _YmdToken.day => _YmdOrder.dmy,
  };
}

enum _YmdToken { year, month, day }

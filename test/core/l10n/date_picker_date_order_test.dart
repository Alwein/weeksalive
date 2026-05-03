import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weeksalive/core/l10n/date_picker_date_order.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('datePickerDateOrderForLocale', () {
    test('en_US follows month-day-year (MDY)', () {
      expect(
        datePickerDateOrderForLocale(const Locale('en', 'US')),
        DatePickerDateOrder.mdy,
      );
    });

    test('en_GB follows day-month-year (DMY)', () {
      expect(
        datePickerDateOrderForLocale(const Locale('en', 'GB')),
        DatePickerDateOrder.dmy,
      );
    });

    test('fr_FR follows day-month-year (DMY)', () {
      expect(
        datePickerDateOrderForLocale(const Locale('fr', 'FR')),
        DatePickerDateOrder.dmy,
      );
    });

    test('de_DE follows day-month-year (DMY)', () {
      expect(
        datePickerDateOrderForLocale(const Locale('de', 'DE')),
        DatePickerDateOrder.dmy,
      );
    });

    test('ja_JP follows year-month-day (YMD)', () {
      expect(
        datePickerDateOrderForLocale(const Locale('ja', 'JP')),
        DatePickerDateOrder.ymd,
      );
    });

    test('ko_KR follows year-month-day (YMD)', () {
      expect(
        datePickerDateOrderForLocale(const Locale('ko', 'KR')),
        DatePickerDateOrder.ymd,
      );
    });

    test('zh_CN follows year-month-day (YMD)', () {
      expect(
        datePickerDateOrderForLocale(const Locale('zh', 'CN')),
        DatePickerDateOrder.ymd,
      );
    });

    test('falls back to DMY when locale data is unusable', () {
      expect(
        datePickerDateOrderForLocale(const Locale('xx', 'YY')),
        DatePickerDateOrder.dmy,
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/year_grid/year_grid_fill_sizes.dart';

void main() {
  final now = DateTime(2026, 10, 16, 15);

  test('marks past, today and future days with no record', () {
    final sizes = yearGridFillSizes(entries: const [], now: now);

    expect(sizes, hasLength(365));
    expect(sizes.first, yearGridPastEmpty);
    expect(sizes[288], yearGridTodayEmpty); // Oct 16 is day 289 of 2026.
    expect(sizes.last, yearGridFuture);
  });

  test('draws a recorded day at its size, today included', () {
    final sizes = yearGridFillSizes(
      entries: [
        DayEntry(date: DateTime(2026, 10, 15), averageFeeling: AverageFeeling.great, sizeLevel: 3),
        DayEntry(date: DateTime(2026, 10, 16), sizeLevel: 0),
      ],
      now: now,
    );

    expect(sizes[287], 3);
    expect(sizes[288], 0);
  });

  test('ignores entries from another year', () {
    final sizes = yearGridFillSizes(
      entries: [DayEntry(date: DateTime(2025, 12, 31), sizeLevel: 4)],
      now: now,
    );

    expect(sizes.where((size) => size >= 0), isEmpty);
  });
}

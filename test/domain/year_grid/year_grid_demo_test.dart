import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/year_grid/year_grid_demo.dart';

void main() {
  group('yearGridDemoFilledCount', () {
    test('fills two thirds of a common year', () {
      expect(yearGridDemoFilledCount(365), 243);
    });

    test('fills two thirds of a leap year', () {
      expect(yearGridDemoFilledCount(366), 244);
    });
  });

  group('weightedYearGridFillSizes', () {
    test('uses the onboarding weight distribution and seed', () {
      final sizes = weightedYearGridFillSizes(
        count: 8,
        weightDistribution: yearGridDemoWeightDistribution,
      );
      expect(sizes, hasLength(8));
      expect(sizes.every((level) => level >= 0 && level <= 4), isTrue);
      expect(
        sizes,
        weightedYearGridFillSizes(
          count: 8,
          weightDistribution: yearGridDemoWeightDistribution,
        ),
      );
    });

    test('returns an empty list for a non-positive count', () {
      expect(weightedYearGridFillSizes(count: 0), isEmpty);
    });
  });

  group('yearGridDemoFillSizes', () {
    test('fills two thirds then leaves the rest empty', () {
      const totalDays = 365;
      final sizes = yearGridDemoFillSizes(totalDays: totalDays);
      final filledCount = yearGridDemoFilledCount(totalDays);

      expect(sizes, hasLength(totalDays));
      expect(
        sizes.take(filledCount).every((level) => level >= 0 && level <= 4),
        isTrue,
      );
      expect(sizes.skip(filledCount).every((level) => level == -1), isTrue);
      expect(
        sizes.take(filledCount),
        weightedYearGridFillSizes(count: filledCount),
      );
    });
  });
}

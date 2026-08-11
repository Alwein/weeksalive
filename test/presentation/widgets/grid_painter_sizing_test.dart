import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/widgets/week_grid_painter.dart';
import 'package:weeksalive/presentation/widgets/year_grid_painter.dart';

void main() {
  group('WeekGridPainter.computeWidthForHeight', () {
    const columns = 52;
    const dotSpacing = 2.0;
    const totalWeeks = 52 * 85;
    const padding = EdgeInsets.only(left: 32, right: 32);

    test('round-trips with computeHeight', () {
      const availableWidth = 390.0;
      final height = WeekGridPainter.computeHeight(
        availableWidth: availableWidth,
        totalWeeks: totalWeeks,
        columns: columns,
        dotSpacing: dotSpacing,
        padding: padding,
      );
      final width = WeekGridPainter.computeWidthForHeight(
        availableHeight: height,
        totalWeeks: totalWeeks,
        columns: columns,
        dotSpacing: dotSpacing,
        padding: padding,
      );
      expect(width, closeTo(availableWidth, 0.001));
    });

    test('height from constrained width stays within available height', () {
      const maxWidth = 820.0;
      const maxHeight = 700.0;
      final paintWidth = WeekGridPainter.computeWidthForHeight(
        availableHeight: maxHeight,
        totalWeeks: totalWeeks,
        columns: columns,
        dotSpacing: dotSpacing,
        padding: padding,
      ).clamp(0.0, maxWidth);
      final exactHeight = WeekGridPainter.computeHeight(
        availableWidth: paintWidth,
        totalWeeks: totalWeeks,
        columns: columns,
        dotSpacing: dotSpacing,
        padding: padding,
      );
      expect(exactHeight, lessThanOrEqualTo(maxHeight + 0.001));
      expect(paintWidth, lessThan(maxWidth));
    });
  });

  group('YearGridPainter.computeWidthForHeight', () {
    const columns = 15;
    const dotSpacing = 4.0;
    const totalDays = 365;
    const padding = EdgeInsets.only(left: 32, right: 32);

    test('round-trips with computeHeight', () {
      const availableWidth = 390.0;
      final height = YearGridPainter.computeHeight(
        availableWidth: availableWidth,
        totalDays: totalDays,
        columns: columns,
        dotSpacing: dotSpacing,
        padding: padding,
      );
      final width = YearGridPainter.computeWidthForHeight(
        availableHeight: height,
        totalDays: totalDays,
        columns: columns,
        dotSpacing: dotSpacing,
        padding: padding,
      );
      expect(width, closeTo(availableWidth, 0.001));
    });

    test('height from constrained width stays within available height', () {
      const maxWidth = 820.0;
      const maxHeight = 400.0;
      final paintWidth = YearGridPainter.computeWidthForHeight(
        availableHeight: maxHeight,
        totalDays: totalDays,
        columns: columns,
        dotSpacing: dotSpacing,
        padding: padding,
      ).clamp(0.0, maxWidth);
      final exactHeight = YearGridPainter.computeHeight(
        availableWidth: paintWidth,
        totalDays: totalDays,
        columns: columns,
        dotSpacing: dotSpacing,
        padding: padding,
      );
      expect(exactHeight, lessThanOrEqualTo(maxHeight + 0.001));
      expect(paintWidth, lessThan(maxWidth));
    });
  });
}

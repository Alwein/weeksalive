import 'dart:math';

/// Weighted size levels used by onboarding year-grid illustrations.
const yearGridDemoWeightDistribution = [0, 1, 2, 2, 3, 3, 4, 4, 4];

/// Deterministic seed so the demo grid looks the same every time.
const yearGridDemoRandomSeed = 42;

/// Fraction of the year to fill in demo mode.
const yearGridDemoFilledFraction = 2 / 3;

int yearGridDemoFilledCount(int totalDays) =>
    (totalDays * yearGridDemoFilledFraction).round();

/// Random size levels matching [YearGridIllustration] (onboarding).
List<int> weightedYearGridFillSizes({
  required int count,
  List<int> weightDistribution = yearGridDemoWeightDistribution,
  int seed = yearGridDemoRandomSeed,
}) {
  final rng = Random(seed);
  if (weightDistribution.isEmpty || count <= 0) return const [];
  return List.generate(
    count,
    (_) => weightDistribution[rng.nextInt(weightDistribution.length)],
  );
}

/// Per-day fill sizes for a year grid filled to two thirds, same encoding as
/// the home year view (`0..4` recorded, `-1` empty future).
List<int> yearGridDemoFillSizes({required int totalDays}) {
  final filledCount = yearGridDemoFilledCount(totalDays).clamp(0, totalDays);
  final filled = weightedYearGridFillSizes(count: filledCount);
  if (filledCount >= totalDays) return filled;
  return [...filled, ...List<int>.filled(totalDays - filledCount, -1)];
}

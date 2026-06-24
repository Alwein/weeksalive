enum GridCellVariant {
  lifeLived,
  lifeRemaining,
  yearNote1,
  yearNote2,
  yearNote3,
  yearNote4,
  yearNote5,
  yearEmptyPast,
  yearFuture,
  yearTodayEmpty,
}

GridCellVariant gridCellVariantForLifeWeek({required bool isLived}) {
  return isLived ? GridCellVariant.lifeLived : GridCellVariant.lifeRemaining;
}

/// Maps [YearGridPainter] fill-size codes to a [GridCellVariant].
///
/// - `-3` today without entry
/// - `-2` past without entry
/// - `-1` future without entry
/// - `[0, 4]` note size level
GridCellVariant gridCellVariantForYearFillSize(int fillSize) {
  return switch (fillSize) {
    -3 => GridCellVariant.yearTodayEmpty,
    -2 => GridCellVariant.yearEmptyPast,
    -1 => GridCellVariant.yearFuture,
    0 => GridCellVariant.yearNote1,
    1 => GridCellVariant.yearNote2,
    2 => GridCellVariant.yearNote3,
    3 => GridCellVariant.yearNote4,
    4 => GridCellVariant.yearNote5,
    _ => GridCellVariant.yearFuture,
  };
}

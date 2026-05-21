import 'package:weeksalive/core/texts/strings.dart';

enum AverageFeeling {
  rough,
  low,
  okey,
  good,
  great;

  String get label => switch (this) {
    rough => Strings.feelingSectionValueRough,
    low => Strings.feelingSectionValueLow,
    okey => Strings.feelingSectionValueOkay,
    good => Strings.feelingSectionValueGood,
    great => Strings.feelingSectionValueGreat,
  };
}

enum MeaningScore {
  none,
  little,
  some,
  much,
  deep;

  String get label => switch (this) {
    none => Strings.meaningSectionValueNone,
    little => Strings.meaningSectionValueLittle,
    some => Strings.meaningSectionValueSome,
    much => Strings.meaningSectionValueMuch,
    deep => Strings.meaningSectionValueDeep,
  };

  /// Number of "filled" bars (1..5) for the visual meter representation.
  int get filledBars => switch (this) {
    none => 1,
    little => 2,
    some => 3,
    much => 4,
    deep => 5,
  };
}

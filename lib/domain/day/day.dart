import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/texts/strings.dart';

class LeaveATrace {
  const LeaveATrace({this.text = '', this.imagePaths = const []});

  final String text;
  final List<String> imagePaths;

  static const int maxImages = 3;

  bool get isAnswered => text.isNotEmpty || imagePaths.isNotEmpty;

  LeaveATrace copyWith({String? text, List<String>? imagePaths}) {
    return LeaveATrace(
      text: text ?? this.text,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}

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

  IconData get icon => switch (this) {
    rough => MingCuteIcons.mgc_sad_line,
    low => MingCuteIcons.mgc_confused_line,
    okey => MingCuteIcons.mgc_meh_line,
    good => MingCuteIcons.mgc_emoji_line,
    great => MingCuteIcons.mgc_happy_line,
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

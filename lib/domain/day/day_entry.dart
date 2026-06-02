import 'package:weeksalive/domain/day/day.dart';

class DayEntry {
  DayEntry({
    required DateTime date,
    this.averageFeeling,
    this.meaningScore,
    this.hasNewExperience,
    this.livingIntentionIds = const [],
    this.leaveATrace = const LeaveATrace(),
    int? sizeLevel,
  }) : date = normalizeDay(date),
       sizeLevel =
           sizeLevel ??
           dayScoreLevel(
             averageFeeling: averageFeeling,
             meaningScore: meaningScore,
             hasNewExperience: hasNewExperience,
             livingIntentionIds: livingIntentionIds,
           );

  final DateTime date;
  final AverageFeeling? averageFeeling;
  final MeaningScore? meaningScore;
  final bool? hasNewExperience;
  final List<String> livingIntentionIds;
  final LeaveATrace leaveATrace;

  final int sizeLevel;

  DayEntry copyWith({
    DateTime? date,
    AverageFeeling? averageFeeling,
    MeaningScore? meaningScore,
    bool? hasNewExperience,
    List<String>? livingIntentionIds,
    LeaveATrace? leaveATrace,
  }) {
    return DayEntry(
      date: date ?? this.date,
      averageFeeling: averageFeeling ?? this.averageFeeling,
      meaningScore: meaningScore ?? this.meaningScore,
      hasNewExperience: hasNewExperience ?? this.hasNewExperience,
      livingIntentionIds: livingIntentionIds ?? this.livingIntentionIds,
      leaveATrace: leaveATrace ?? this.leaveATrace,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'averageFeeling': averageFeeling?.name,
    'meaningScore': meaningScore?.name,
    'hasNewExperience': hasNewExperience,
    'livingIntentionIds': livingIntentionIds,
    'leaveATraceText': leaveATrace.text,
    'leaveATraceImagePaths': leaveATrace.imagePaths,
    'sizeLevel': sizeLevel,
  };

  static DayEntry fromJson(Map<String, dynamic> json) => DayEntry(
    date: DateTime.parse(json['date'] as String),
    averageFeeling: _enumByName(AverageFeeling.values, json['averageFeeling'] as String?),
    meaningScore: _enumByName(MeaningScore.values, json['meaningScore'] as String?),
    hasNewExperience: json['hasNewExperience'] as bool?,
    livingIntentionIds: (json['livingIntentionIds'] as List<dynamic>? ?? const []).map((e) => e as String).toList(),
    leaveATrace: LeaveATrace(
      text: json['leaveATraceText'] as String? ?? '',
      imagePaths: (json['leaveATraceImagePaths'] as List<dynamic>? ?? const []).map((e) => e as String).toList(),
    ),
    sizeLevel: json['sizeLevel'] as int?,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DayEntry && runtimeType == other.runtimeType && date == other.date;

  @override
  int get hashCode => date.hashCode;
}

T? _enumByName<T extends Enum>(List<T> values, String? name) {
  if (name == null) return null;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}

DateTime normalizeDay(DateTime date) => DateTime(date.year, date.month, date.day);

int dayScoreLevel({
  AverageFeeling? averageFeeling,
  MeaningScore? meaningScore,
  bool? hasNewExperience,
  List<String> livingIntentionIds = const [],
}) {
  double fraction(int index, int valueCount) => valueCount <= 1 ? 0.0 : index / (valueCount - 1);

  final feeling = averageFeeling != null ? fraction(averageFeeling.index, AverageFeeling.values.length) : 0.0;
  final meaning = meaningScore != null ? fraction(meaningScore.index, MeaningScore.values.length) : 0.0;
  final experience = hasNewExperience == true ? 1.0 : 0.0;
  final intention = livingIntentionIds.isNotEmpty ? 1.0 : 0.0;

  final normalized = (feeling + meaning + experience + intention) / 4;
  return (normalized * 4).round().clamp(0, 4);
}

int computeStreak(Set<DateTime> recordedDays, DateTime today) {
  final normalized = recordedDays.map(normalizeDay).toSet();
  var cursor = normalizeDay(today);
  var count = 0;
  while (normalized.contains(cursor)) {
    count++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return count;
}

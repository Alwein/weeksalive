import 'package:weeksalive/domain/day/day.dart';

class DayEntry {
  DayEntry({
    required DateTime date,
    this.averageFeeling,
    this.meaningScore,
    this.hasNewExperience,
    this.livingIntentionIds = const [],
    this.leaveATrace = const LeaveATrace(),
    // from 0 to 4
    int? sizeLevel,
    DateTime? savedAt,
  }) : date = normalizeDay(date),
       savedAt = savedAt ?? DateTime.now(),
       sizeLevel =
           sizeLevel ??
           dayScoreLevel(
             averageFeeling: averageFeeling,
             meaningScore: meaningScore,
             hasNewExperience: hasNewExperience,
             livingIntentionIds: livingIntentionIds,
           );

  final DateTime date;
  final DateTime savedAt;
  final AverageFeeling? averageFeeling;
  final MeaningScore? meaningScore;
  final bool? hasNewExperience;
  final List<String> livingIntentionIds;
  final LeaveATrace leaveATrace;

  final int sizeLevel;

  DayEntry copyWith({
    DateTime? date,
    DateTime? savedAt,
    AverageFeeling? averageFeeling,
    MeaningScore? meaningScore,
    bool? hasNewExperience,
    List<String>? livingIntentionIds,
    LeaveATrace? leaveATrace,
    int? sizeLevel,
  }) {
    return DayEntry(
      date: date ?? this.date,
      savedAt: savedAt ?? this.savedAt,
      averageFeeling: averageFeeling ?? this.averageFeeling,
      meaningScore: meaningScore ?? this.meaningScore,
      hasNewExperience: hasNewExperience ?? this.hasNewExperience,
      livingIntentionIds: livingIntentionIds ?? this.livingIntentionIds,
      leaveATrace: leaveATrace ?? this.leaveATrace,
      sizeLevel: sizeLevel ?? this.sizeLevel,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'savedAt': savedAt.toIso8601String(),
    'averageFeeling': averageFeeling?.name,
    'meaningScore': meaningScore?.name,
    'hasNewExperience': hasNewExperience,
    'livingIntentionIds': livingIntentionIds,
    'leaveATraceText': leaveATrace.text,
    'leaveATraceImagePaths': leaveATrace.imagePaths,
    'sizeLevel': sizeLevel,
  };

  static DayEntry fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date'] as String);
    final normalizedDate = normalizeDay(date);
    return DayEntry(
      date: normalizedDate,
      savedAt: json['savedAt'] != null
          ? DateTime.parse(json['savedAt'] as String)
          : DateTime(normalizedDate.year, normalizedDate.month, normalizedDate.day, 12),
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
  }

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

/// Last instant when a save for calendar day [day] still counts toward the streak.
///
/// A day can be logged from [day] 00:00 through the end of the following
/// calendar day (24h grace).
DateTime streakEligibilityWindowEnd(DateTime day) {
  final normalized = normalizeDay(day);
  final nextDay = normalized.add(const Duration(days: 1));
  return DateTime(nextDay.year, nextDay.month, nextDay.day, 23, 59, 59, 999);
}

/// Whether [savedAt] falls in the streak eligibility window for [entryDate].
bool isStreakEligible({
  required DateTime entryDate,
  required DateTime savedAt,
}) {
  final day = normalizeDay(entryDate);
  final windowStart = day;
  final windowEnd = streakEligibilityWindowEnd(day);
  return !savedAt.isBefore(windowStart) && !savedAt.isAfter(windowEnd);
}

/// Whether calendar day [day] can still be logged for streak purposes at [now].
bool isWithinStreakGraceWindow(DateTime day, DateTime now) {
  return !now.isAfter(streakEligibilityWindowEnd(day));
}

/// Whether [yesterday] was missed but can still be logged for streak purposes.
///
/// Only applies when there is an active streak at risk — i.e. the day before
/// yesterday was logged. A distant past entry alone is not enough.
bool isYesterdayGracePeriod({
  required Set<DateTime> recordedDays,
  required DateTime now,
}) {
  if (recordedDays.isEmpty) return false;

  final yesterday = normalizeDay(now).subtract(const Duration(days: 1));
  if (recordedDays.contains(yesterday)) return false;
  if (!isWithinStreakGraceWindow(yesterday, now)) return false;

  final dayBeforeYesterday = yesterday.subtract(const Duration(days: 1));
  return recordedDays.contains(dayBeforeYesterday);
}

/// Counts consecutive streak-eligible days walking back from [now].
///
/// Days without an entry but still inside their grace window are skipped
/// without breaking the chain.
int computeStreak(Iterable<DayEntry> entries, DateTime now) {
  final eligibleDates = <DateTime>{
    for (final entry in entries)
      if (isStreakEligible(entryDate: entry.date, savedAt: entry.savedAt)) normalizeDay(entry.date),
  };

  var cursor = normalizeDay(now);
  var count = 0;

  while (true) {
    if (eligibleDates.contains(cursor)) {
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    } else if (isWithinStreakGraceWindow(cursor, now)) {
      cursor = cursor.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }

  return count;
}

/// Longest run of consecutive streak-eligible calendar days in [entries].
///
/// Unlike [computeStreak], this is a historical record and does not depend
/// on [DateTime.now].
int computeBestStreak(Iterable<DayEntry> entries) {
  final eligibleDates = <DateTime>{
    for (final entry in entries)
      if (isStreakEligible(entryDate: entry.date, savedAt: entry.savedAt)) normalizeDay(entry.date),
  };

  if (eligibleDates.isEmpty) return 0;

  final sorted = eligibleDates.toList()..sort((a, b) => a.compareTo(b));

  var best = 1;
  var current = 1;

  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i].difference(sorted[i - 1]).inDays == 1) {
      current++;
      if (current > best) best = current;
    } else {
      current = 1;
    }
  }

  return best;
}

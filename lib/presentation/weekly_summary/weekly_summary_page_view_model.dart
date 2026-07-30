import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/domain/weekly_calendar.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'weekly_summary_page_view_model.freezed.dart';

@freezed
abstract class WeeklySummaryPageViewModel with _$WeeklySummaryPageViewModel {
  const factory WeeklySummaryPageViewModel({
    required int weekNumber,
    required String weekDates,
    required AverageFeeling? lastWeekAverageFeeling,
    required double lastWeekAverageFeelingScore,
    required double lastWeekAverageMeaningScore,
    required int lastWeekNewExperiencesCount,
    required List<(int, String)> lastWeekLivingIntentions,
    required List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes,
    required List<String> lastWeekImagePaths,
  }) = _WeeklySummaryPageViewModel;

  factory WeeklySummaryPageViewModel.create(Store<AppState> store, {DateTime? at}) {
    final now = at ?? DateTime.now();
    final user = switch (store.state.userState) {
      UserStateSuccess(:final user) => user,
      _ => null,
    };
    final weekStartDay = user?.weekStartDay ?? DateTime.monday;
    final previousWeekDays = WeeklyCalendar.previousWeekDays(now, weekStartDay);
    final weekEntries = _entriesForDays(store, previousWeekDays);
    final weekStart = previousWeekDays.first;
    final weekEnd = previousWeekDays.last;

    return WeeklySummaryPageViewModel(
      weekNumber: _weekNumber(user, weekEnd, weekStartDay),
      weekDates: _formatWeekDateRange(weekStart, weekEnd),
      lastWeekAverageFeeling: _averageFeeling(weekEntries),
      lastWeekAverageFeelingScore: _averageFeelingScore(weekEntries),
      lastWeekAverageMeaningScore: _averageMeaningScore(weekEntries),
      lastWeekNewExperiencesCount: _newExperiencesCount(weekEntries),
      lastWeekLivingIntentions: _livingIntentions(store, weekEntries),
      lastWeekDaySizes: _weekDaySizes(store, previousWeekDays),
      lastWeekImagePaths: _imagePaths(weekEntries),
    );
  }
}

List<DayEntry> _entriesForDays(Store<AppState> store, List<DateTime> days) {
  final entries = <DayEntry>[];
  for (final day in days) {
    final entry = store.state.dayState.entryFor(day);
    if (entry != null) {
      entries.add(entry);
    }
  }
  return entries;
}

int _weekNumber(User? user, DateTime weekEnd, int weekStartDay) {
  if (user == null) return 0;
  return weeksSinceBirth(
    dateOfBirth: user.dateOfBirth,
    at: weekEnd,
    weekStartDay: weekStartDay,
  );
}

String _formatWeekDateRange(DateTime start, DateTime end) {
  final monthNames = Strings.monthNames;

  final startMonth = monthNames[start.month - 1];
  final endMonth = monthNames[end.month - 1];

  if (start.month == end.month && start.year == end.year) {
    return '${start.day}-${end.day} $startMonth ${start.year}';
  }

  if (start.year == end.year) {
    return '${start.day} $startMonth - ${end.day} $endMonth ${start.year}';
  }

  return '${start.day} $startMonth ${start.year} - ${end.day} $endMonth ${end.year}';
}

AverageFeeling? _averageFeeling(List<DayEntry> entries) {
  final feelings = entries.map((entry) => entry.averageFeeling).whereType<AverageFeeling>().toList();
  if (feelings.isEmpty) return null;

  final averageIndex = feelings.map((feeling) => feeling.index).reduce((a, b) => a + b) / feelings.length;
  return AverageFeeling.values[averageIndex.round().clamp(0, AverageFeeling.values.length - 1)];
}

double _averageFeelingScore(List<DayEntry> entries) {
  final feelings = entries.map((entry) => entry.averageFeeling).whereType<AverageFeeling>().toList();
  if (feelings.isEmpty) return 0;

  return feelings.map((feeling) => feeling.index + 1).reduce((a, b) => a + b) / feelings.length;
}

double _averageMeaningScore(List<DayEntry> entries) {
  final scores = entries.map((entry) => entry.meaningScore).whereType<MeaningScore>().toList();
  if (scores.isEmpty) return 0;

  return scores.map((score) => score.index + 1).reduce((a, b) => a + b) / scores.length;
}

int _newExperiencesCount(List<DayEntry> entries) {
  return entries.where((entry) => entry.hasNewExperience == true).length;
}

List<(int, String)> _livingIntentions(Store<AppState> store, List<DayEntry> entries) {
  final weeklyIntentState = store.state.weeklyIntentState;
  final labelsById = {for (final intent in weeklyIntentState.availableIntents) intent.id: intent.localizedLabel};
  final counts = {for (final id in weeklyIntentState.selectedIds) id: 0};

  for (final entry in entries) {
    for (final id in entry.livingIntentionIds) {
      if (counts.containsKey(id)) {
        counts[id] = counts[id]! + 1;
      }
    }
  }

  return weeklyIntentState.selectedIds.map((id) => (counts[id] ?? 0, labelsById[id] ?? '')).toList()
    ..sort((a, b) => b.$1.compareTo(a.$1));
}

List<(String, int?)> _weekDaySizes(Store<AppState> store, List<DateTime> days) {
  return [
    for (final day in days) (Strings.homePageDayLabels[day.weekday - 1], store.state.dayState.entryFor(day)?.sizeLevel),
  ];
}

List<String> _imagePaths(List<DayEntry> entries) {
  return [
    for (final entry in entries)
      for (final path in entry.leaveATrace.imagePaths) path,
  ];
}

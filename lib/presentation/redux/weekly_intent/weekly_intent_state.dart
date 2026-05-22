import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';

class WeeklyIntentState {
  final List<WeeklyIntent> availableIntents;
  final List<String> selectedIds;
  final String currentWeekKey;

  const WeeklyIntentState({
    required this.availableIntents,
    required this.selectedIds,
    required this.currentWeekKey,
  });

  factory WeeklyIntentState.initial() => WeeklyIntentState(
    availableIntents: List.unmodifiable(kDefaultWeeklyIntents),
    selectedIds: const [],
    currentWeekKey: '',
  );

  WeeklyIntentState copyWith({
    List<WeeklyIntent>? availableIntents,
    List<String>? selectedIds,
    String? currentWeekKey,
  }) {
    return WeeklyIntentState(
      availableIntents: availableIntents ?? this.availableIntents,
      selectedIds: selectedIds ?? this.selectedIds,
      currentWeekKey: currentWeekKey ?? this.currentWeekKey,
    );
  }
}

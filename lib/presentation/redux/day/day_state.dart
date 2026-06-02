import 'package:weeksalive/domain/day/day_entry.dart';

class DayState {
  /// Recorded days keyed by their normalized (midnight) date.
  final Map<DateTime, DayEntry> entries;

  const DayState({this.entries = const {}});

  factory DayState.initial() => const DayState();

  DayEntry? entryFor(DateTime date) => entries[normalizeDay(date)];

  DayState copyWith({Map<DateTime, DayEntry>? entries}) {
    return DayState(entries: entries ?? this.entries);
  }
}

import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';

DayState dayReducer(DayState state, dynamic action) {
  if (action is DaysLoadedAction) {
    return state.copyWith(
      entries: {for (final entry in action.entries) entry.date: entry},
    );
  }

  if (action is SaveDayAction) {
    final entry = action.entry;
    return state.copyWith(
      entries: {...state.entries, normalizeDay(entry.date): entry},
    );
  }

  if (action is DeleteDayAction) {
    final updated = Map<DateTime, DayEntry>.from(state.entries)..remove(normalizeDay(action.date));
    return state.copyWith(entries: updated);
  }

  return state;
}

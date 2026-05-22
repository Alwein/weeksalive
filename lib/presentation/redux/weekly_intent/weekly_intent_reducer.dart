import 'package:uuid/uuid.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_state.dart';

const _uuid = Uuid();

WeeklyIntentState weeklyIntentReducer(WeeklyIntentState state, dynamic action) {
  if (action is WeeklyIntentLoadedAction) {
    return action.state;
  }

  if (action is ToggleWeeklyIntentAction) {
    return _handleToggle(state, action.id);
  }

  if (action is AddWeeklyIntentAction) {
    return _handleAdd(state, action.label);
  }

  if (action is RemoveWeeklyIntentAction) {
    return _handleRemove(state, action.id);
  }

  if (action is SetWeekKeyAction) {
    return state.copyWith(currentWeekKey: action.weekKey);
  }

  return state;
}

WeeklyIntentState _handleToggle(WeeklyIntentState state, String id) {
  final isSelected = state.selectedIds.contains(id);

  List<String> newSelectedIds;
  if (isSelected) {
    newSelectedIds = state.selectedIds.where((s) => s != id).toList();
  } else {
    if (state.selectedIds.length >= 3) return state;
    newSelectedIds = [...state.selectedIds, id];
  }

  final now = DateTime.now();
  final updatedIntents =
      state.availableIntents.map((intent) {
        if (intent.id == id && !isSelected) {
          return intent.copyWith(lastSelectedAt: now);
        }
        return intent;
      }).toList()..sort((a, b) {
        if (a.lastSelectedAt == null && b.lastSelectedAt == null) return 0;
        if (a.lastSelectedAt == null) return 1;
        if (b.lastSelectedAt == null) return -1;
        return b.lastSelectedAt!.compareTo(a.lastSelectedAt!);
      });

  return state.copyWith(
    availableIntents: updatedIntents,
    selectedIds: newSelectedIds,
  );
}

WeeklyIntentState _handleAdd(WeeklyIntentState state, String label) {
  final trimmed = label.trim();
  if (trimmed.isEmpty) return state;

  final newIntent = WeeklyIntent(id: _uuid.v4(), label: trimmed.toUpperCase());
  return state.copyWith(
    availableIntents: [newIntent, ...state.availableIntents],
  );
}

WeeklyIntentState _handleRemove(WeeklyIntentState state, String id) {
  return state.copyWith(
    availableIntents: state.availableIntents.where((i) => i.id != id).toList(),
    selectedIds: state.selectedIds.where((s) => s != id).toList(),
  );
}

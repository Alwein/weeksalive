import 'package:redux/redux.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_state.dart';

class WeeklyIntentMiddleware extends MiddlewareClass<AppState> {
  final WeeklyIntentRepository weeklyIntentRepository;

  WeeklyIntentMiddleware({required this.weeklyIntentRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      await _load(store);
    }

    if (action is SetWeeklyIntentSelectionAction ||
        action is AddWeeklyIntentAction ||
        action is RemoveWeeklyIntentAction) {
      await _persist(store);
    }

    if (action is SetWeekKeyAction) {
      await weeklyIntentRepository.setWeekKey(action.weekKey);
    }
  }

  Future<void> _load(Store<AppState> store) async {
    final results = await Future.wait([
      weeklyIntentRepository.getIntents(),
      weeklyIntentRepository.getSelection(),
      weeklyIntentRepository.getWeekKey(),
    ]);

    final savedIntents = results[0] as List<WeeklyIntent>?;
    final selectedIds = results[1] as List<String>;
    final weekKey = results[2] as String?;

    final rawIntents = savedIntents ?? defaultWeeklyIntents();
    final intents = normalizeWeeklyIntents(rawIntents);
    final migratedSelectedIds = migrateWeeklyIntentSelectionIds(selectedIds, rawIntents);
    final intentsChanged = _intentsChanged(rawIntents, intents);
    final selectionChanged = !_selectionIdsEquivalent(selectedIds, migratedSelectedIds);
    final shouldPersist = savedIntents == null || intentsChanged || selectionChanged;

    try {
      store.dispatch(
        WeeklyIntentLoadedAction(
          WeeklyIntentState(
            availableIntents: intents,
            selectedIds: migratedSelectedIds,
            currentWeekKey: weekKey ?? '',
          ),
        ),
      );
    } catch (_) {
      return;
    }

    if (shouldPersist) {
      await weeklyIntentRepository.setIntents(intents);
      await weeklyIntentRepository.setSelection(migratedSelectedIds);
    }
  }

  Future<void> _persist(Store<AppState> store) async {
    final state = store.state.weeklyIntentState;
    await weeklyIntentRepository.setIntents(state.availableIntents);
    await weeklyIntentRepository.setSelection(state.selectedIds);
  }
}

bool _intentsChanged(List<WeeklyIntent> before, List<WeeklyIntent> after) {
  if (before.length != after.length) return true;
  for (var i = 0; i < before.length; i++) {
    final previous = before[i];
    final next = after[i];
    if (previous.id != next.id || previous.label != next.label) return true;
  }
  return false;
}

bool _selectionIdsEquivalent(List<String> before, List<String> after) {
  if (before.length != after.length) return false;
  for (var i = 0; i < before.length; i++) {
    if (before[i] != after[i]) return false;
  }
  return true;
}

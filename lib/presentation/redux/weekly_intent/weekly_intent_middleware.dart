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

    if (action is ToggleWeeklyIntentAction || action is AddWeeklyIntentAction || action is RemoveWeeklyIntentAction) {
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

    final intents = savedIntents ?? List<WeeklyIntent>.from(kDefaultWeeklyIntents);

    // Dispatch first so the UI reflects state as early as possible.
    // Guard against the store being torn down before this async callback
    // completes (e.g. in tests).
    try {
      store.dispatch(
        WeeklyIntentLoadedAction(
          WeeklyIntentState(
            availableIntents: intents,
            selectedIds: selectedIds,
            currentWeekKey: weekKey ?? '',
          ),
        ),
      );
    } catch (_) {
      return;
    }

    // Persist defaults on first launch (fire-and-forget after dispatch).
    if (savedIntents == null) {
      await weeklyIntentRepository.setIntents(intents);
    }
  }

  Future<void> _persist(Store<AppState> store) async {
    final state = store.state.weeklyIntentState;
    await weeklyIntentRepository.setIntents(state.availableIntents);
    await weeklyIntentRepository.setSelection(state.selectedIds);
  }
}

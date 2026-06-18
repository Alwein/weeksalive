import 'package:redux/redux.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';

class DayMiddleware extends MiddlewareClass<AppState> {
  final DayRepository dayRepository;

  DayMiddleware({required this.dayRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      final entries = await dayRepository.getAll();
      try {
        store.dispatch(DaysLoadedAction(entries));
        _refreshStreak(store);
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }

    if (action is SaveDayAction) {
      final normalized = normalizeDay(action.entry.date);
      final entry = store.state.dayState.entries[normalized] ?? action.entry;
      await dayRepository.upsert(entry);
      _refreshStreak(store);
    }

    if (action is DeleteDayAction) {
      await dayRepository.delete(action.date);
      _refreshStreak(store);
    }
  }

  void _refreshStreak(Store<AppState> store) {
    final entries = store.state.dayState.entries.values;
    final now = DateTime.now();
    try {
      store.dispatch(
        StreakRecalculatedAction(
          count: computeStreak(entries, now),
          bestEver: computeBestStreak(entries),
        ),
      );
    } catch (_) {
      // The store may have been torn down (e.g. in tests) between the async
      // gap and this dispatch; ignore the resulting "stream closed" error.
    }
  }
}

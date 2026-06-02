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
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }

    if (action is SaveDayAction) {
      await dayRepository.upsert(action.entry);
      _refreshStreak(store);
    }
  }

  void _refreshStreak(Store<AppState> store) {
    final dates = store.state.dayState.entries.keys.toSet();
    final count = computeStreak(dates, DateTime.now());
    try {
      store.dispatch(SetStreakCountAction(count));
    } catch (_) {
      // The store may have been torn down (e.g. in tests) between the async
      // gap and this dispatch; ignore the resulting "stream closed" error.
    }
  }
}

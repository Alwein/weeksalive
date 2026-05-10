import 'package:redux/redux.dart';
import 'package:weeksalive/data/streak/streak_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';

class StreakMiddleware extends MiddlewareClass<AppState> {
  final StreakRepository streakRepository;

  StreakMiddleware({required this.streakRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final count = await streakRepository.getStreakCount();
      store.dispatch(StreakCountLoadedAction(count));
    }

    if (action is SetStreakCountAction) {
      await streakRepository.setStreakCount(action.count);
      store.dispatch(StreakCountLoadedAction(action.count));
    }
  }
}

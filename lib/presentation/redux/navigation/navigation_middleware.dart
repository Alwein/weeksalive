import 'package:redux/redux.dart';
import 'package:weeksalive/data/navigation/navigation_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/navigation/navigation_actions.dart';

class NavigationMiddleware extends MiddlewareClass<AppState> {
  final NavigationRepository navigationRepository;

  NavigationMiddleware({required this.navigationRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final index = await navigationRepository.getHomeTabIndex();
      store.dispatch(HomeTabIndexLoadedAction(index));
    }

    if (action is SetHomeTabIndexAction) {
      await navigationRepository.setHomeTabIndex(action.index);
      store.dispatch(HomeTabIndexLoadedAction(action.index));
    }
  }
}

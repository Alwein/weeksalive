import 'package:redux/redux.dart';
import 'package:weeksalive/data/demo_mode/demo_mode_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/demo_mode/demo_mode_actions.dart';

class DemoModeMiddleware extends MiddlewareClass<AppState> {
  DemoModeMiddleware({required this.demoModeRepository});

  final DemoModeRepository demoModeRepository;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final enabled = demoModeRepository.isEnabled();
      try {
        store.dispatch(DemoModeLoadedAction(enabled));
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }

    if (action is SetDemoModeAction) {
      await demoModeRepository.setEnabled(action.enabled);
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/demo_mode/demo_mode_actions.dart';
import 'package:weeksalive/presentation/redux/demo_mode/demo_mode_middleware.dart';

import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

void main() {
  group('DemoModeMiddleware', () {
    late MockDemoModeRepository demoModeRepository;
    late Store<AppState> store;

    setUp(() {
      demoModeRepository = MockDemoModeRepository();
      store = Store<AppState>(
        appReducer,
        initialState: initialAppState(),
        middleware: [
          DemoModeMiddleware(demoModeRepository: demoModeRepository).call,
        ],
      );
    });

    tearDown(() {
      store.teardown();
    });

    test('loads persisted demo mode on bootstrap', () async {
      when(() => demoModeRepository.isEnabled()).thenReturn(true);

      await store.dispatch(BootstrapAction());
      await pumpEventQueue();

      expect(store.state.demoModeState.enabled, isTrue);
    });

    test('persists demo mode when toggled', () async {
      await store.dispatch(const SetDemoModeAction(true));
      await pumpEventQueue();

      expect(store.state.demoModeState.enabled, isTrue);
      verify(() => demoModeRepository.setEnabled(true)).called(1);
    });
  });
}

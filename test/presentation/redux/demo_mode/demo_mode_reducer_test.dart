import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/redux/demo_mode/demo_mode_actions.dart';
import 'package:weeksalive/presentation/redux/demo_mode/demo_mode_reducer.dart';
import 'package:weeksalive/presentation/redux/demo_mode/demo_mode_state.dart';

void main() {
  group('demoModeReducer', () {
    const initial = DemoModeState();

    test('SetDemoModeAction updates enabled', () {
      final next = demoModeReducer(initial, const SetDemoModeAction(true));
      expect(next.enabled, isTrue);
    });

    test('DemoModeLoadedAction updates enabled', () {
      const enabled = DemoModeState(enabled: true);
      final next = demoModeReducer(enabled, const DemoModeLoadedAction(false));
      expect(next.enabled, isFalse);
    });

    test('unknown actions leave state unchanged', () {
      final next = demoModeReducer(initial, Object());
      expect(next, same(initial));
    });
  });
}

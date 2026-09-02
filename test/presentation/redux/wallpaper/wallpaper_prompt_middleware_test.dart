import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_state.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_state.dart';

import '../../../helpers/test_app_state.dart';
import '../../../helpers/test_store_factory.dart';
import '../../../mocks.dart';

Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 50));

void main() {
  group('WallpaperMiddleware — wallpaper prompt', () {
    late TestStoreFactory factory;

    setUp(() {
      factory = TestStoreFactory();
    });

    test('CheckWallpaperPromptAction requests the nudge on the second launch', () async {
      factory.wallpaperPromptStore = FakeWallpaperPromptStore(launchCount: 2);
      final store = factory.initializeReduxStore(initialAppState());

      store.dispatch(const CheckWallpaperPromptAction());
      await _settle();

      expect(store.state.wallpaperState.promptPending, isTrue);
      store.teardown();
    });

    test('does nothing before the second launch', () async {
      factory.wallpaperPromptStore = FakeWallpaperPromptStore(launchCount: 1);
      final store = factory.initializeReduxStore(initialAppState());

      store.dispatch(const CheckWallpaperPromptAction());
      await _settle();

      expect(store.state.wallpaperState.promptPending, isFalse);
      store.teardown();
    });

    test('does nothing when the nudge was already shown', () async {
      factory.wallpaperPromptStore = FakeWallpaperPromptStore(launchCount: 5, hasBeenShown: true);
      final store = factory.initializeReduxStore(initialAppState());

      store.dispatch(const CheckWallpaperPromptAction());
      await _settle();

      expect(store.state.wallpaperState.promptPending, isFalse);
      store.teardown();
    });

    test('does nothing when a wallpaper is already configured', () async {
      factory.wallpaperPromptStore = FakeWallpaperPromptStore(launchCount: 2);
      final store = factory.initializeReduxStore(
        initialAppState().copyWith(
          wallpaperState: const WallpaperState(config: WallpaperConfig(enabled: true)),
        ),
      );

      store.dispatch(const CheckWallpaperPromptAction());
      await _settle();

      expect(store.state.wallpaperState.promptPending, isFalse);
      store.teardown();
    });

    test('yields to a pending weekly summary', () async {
      factory.wallpaperPromptStore = FakeWallpaperPromptStore(launchCount: 2);
      final store = factory.initializeReduxStore(
        initialAppState().copyWith(
          weeklySummaryState: const WeeklySummaryState(pendingShow: true),
        ),
      );

      store.dispatch(const CheckWallpaperPromptAction());
      await _settle();

      expect(store.state.wallpaperState.promptPending, isFalse);
      store.teardown();
    });

    test('yields to a pending notification navigation', () async {
      factory.wallpaperPromptStore = FakeWallpaperPromptStore(launchCount: 2);
      final store = factory.initializeReduxStore(
        initialAppState().copyWith(
          pushNotificationState: initialAppState().pushNotificationState.copyWith(
            pendingNavigation: PendingNotificationTarget.dayForm,
          ),
        ),
      );

      store.dispatch(const CheckWallpaperPromptAction());
      await _settle();

      expect(store.state.wallpaperState.promptPending, isFalse);
      store.teardown();
    });

    test('BootstrapAction records the launch', () async {
      final promptStore = FakeWallpaperPromptStore(launchCount: 1);
      factory.wallpaperPromptStore = promptStore;
      final store = factory.initializeReduxStore(initialAppState());

      store.dispatch(BootstrapAction());
      await _settle();

      expect(promptStore.launchCount, 2);
      store.teardown();
    });

    test('WallpaperPromptResolvedAction marks the nudge as shown', () async {
      final promptStore = FakeWallpaperPromptStore(launchCount: 2);
      factory.wallpaperPromptStore = promptStore;
      final store = factory.initializeReduxStore(initialAppState());

      store.dispatch(const WallpaperPromptResolvedAction(accepted: true));
      await _settle();

      expect(promptStore.hasBeenShown, isTrue);
      store.teardown();
    });
  });
}

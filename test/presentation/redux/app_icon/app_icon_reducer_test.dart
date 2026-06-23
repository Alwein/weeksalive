import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_actions.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_reducer.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_state.dart';

void main() {
  group('appIconReducer', () {
    test('rejects selecting a locked icon', () {
      const state = AppIconState(selectedIcon: AppIconId.composer);

      final next = appIconReducer(state, const SetAppIconAction(AppIconId.gold));

      expect(next.selectedIcon, AppIconId.composer);
    });

    test('updates selected icon when unlocked', () {
      const state = AppIconState(
        selectedIcon: AppIconId.composer,
        unlockedIcons: {AppIconId.composer, AppIconId.dark, AppIconId.gold},
      );

      final next = appIconReducer(state, const SetAppIconAction(AppIconId.gold));

      expect(next.selectedIcon, AppIconId.gold);
    });

    test('merges always unlocked icons on unlock action', () {
      const state = AppIconState(
        selectedIcon: AppIconId.draw,
        unlockedIcons: {AppIconId.composer, AppIconId.dark, AppIconId.draw},
      );

      final next = appIconReducer(
        state,
        const AppIconsUnlockedAction({AppIconId.draw}),
      );

      expect(next.unlockedIcons, containsAll(AppIconId.alwaysUnlocked));
      expect(next.selectedIcon, AppIconId.draw);
    });

    test('resets to composer when selected icon becomes locked', () {
      const state = AppIconState(
        selectedIcon: AppIconId.gold,
        unlockedIcons: {AppIconId.composer, AppIconId.dark, AppIconId.gold},
      );

      final next = appIconReducer(
        state,
        const AppIconsUnlockedAction({AppIconId.composer, AppIconId.dark}),
      );

      expect(next.selectedIcon, AppIconId.composer);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/wallpaper_prompt/wallpaper_prompt_repository.dart';

void main() {
  group('WallpaperPromptRepository', () {
    late SharedPreferences preferences;
    late WallpaperPromptRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      repository = WallpaperPromptRepository(preferences: preferences);
    });

    test('starts with zero launches and no shown flag', () {
      expect(repository.launchCount, 0);
      expect(repository.hasBeenShown, isFalse);
    });

    test('incrementLaunchCount increases and persists the counter', () async {
      final first = await repository.incrementLaunchCount();
      final second = await repository.incrementLaunchCount();

      expect(first, 1);
      expect(second, 2);
      expect(repository.launchCount, 2);
      expect(
        WallpaperPromptRepository(preferences: preferences).launchCount,
        2,
      );
    });

    test('markShown persists the flag', () async {
      await repository.markShown();

      expect(repository.hasBeenShown, isTrue);
      expect(
        WallpaperPromptRepository(preferences: preferences).hasBeenShown,
        isTrue,
      );
    });

    test('nudge becomes eligible on the second launch', () {
      expect(WallpaperPromptRepository.triggerAtLaunch, 2);
    });
  });
}

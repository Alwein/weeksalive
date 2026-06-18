import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/rewards/rewards_repository.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';

void main() {
  group('RewardsRepository', () {
    late SharedPreferences preferences;
    late RewardsRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      repository = RewardsRepository(preferences: preferences);
    });

    test('persists unlocked rewards as a union', () async {
      await repository.unlock({RewardId.themeMatcha});
      await repository.unlock({RewardId.themePivoine});

      expect(await repository.getUnlocked(), {
        RewardId.themeMatcha,
        RewardId.themePivoine,
      });
    });
  });
}

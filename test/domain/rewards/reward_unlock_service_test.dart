import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/domain/rewards/reward_unlock_service.dart';

void main() {
  group('RewardUnlockService', () {
    const service = RewardUnlockService();

    test('returns empty when no milestones are met', () {
      expect(
        service.evaluateEligible(bestStreak: 0, totalDaysLogged: 0),
        isEmpty,
      );
    });

    test('unlocks theme rewards when best streak milestones are met', () {
      final eligible = service.evaluateEligible(bestStreak: 120, totalDaysLogged: 5);

      expect(eligible, containsAll([
        RewardId.themeMatcha,
        RewardId.themePivoine,
      ]));
      expect(eligible, isNot(contains(RewardId.themeArdoise)));
    });

    test('unlocks app icon rewards when best streak milestones are met', () {
      final eligible = service.evaluateEligible(bestStreak: 180, totalDaysLogged: 5);

      expect(eligible, containsAll([
        RewardId.appIconDraw,
        RewardId.appIconOutline,
        RewardId.appIconSisyphus,
      ]));
      expect(eligible, isNot(contains(RewardId.appIconGold)));
    });

    test('unlocks grid motif rewards when best streak milestones are met', () {
      final eligible = service.evaluateEligible(bestStreak: 240, totalDaysLogged: 5);

      expect(eligible, containsAll([
        RewardId.gridMotifFlowers,
        RewardId.gridMotifDraw,
        RewardId.gridMotifEmoji,
        RewardId.gridMotifMoons,
      ]));
    });

    test('mergeUnlocked keeps previously stored rewards', () {
      final merged = service.mergeUnlocked(
        {RewardId.themeMatcha},
        {RewardId.themePivoine},
      );

      expect(merged, {RewardId.themeMatcha, RewardId.themePivoine});
    });

    test('mergeUnlocked is monotonic when eligible shrinks', () {
      final stored = {RewardId.themeMatcha, RewardId.themeArdoise};
      final merged = service.mergeUnlocked(stored, {RewardId.themeMatcha});

      expect(merged, stored);
    });
  });
}

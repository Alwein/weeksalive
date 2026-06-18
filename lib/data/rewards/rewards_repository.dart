import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';

class RewardsRepository {
  RewardsRepository({
    required SharedPreferences preferences,
  }) : _preferences = preferences;

  final SharedPreferences _preferences;

  static const String unlockedKey = 'unlocked_rewards_v1';

  Future<Set<RewardId>> getUnlocked() async {
    final stored = _preferences.getStringList(unlockedKey);
    if (stored == null) return {};
    return stored.map(RewardId.fromStorageKey).whereType<RewardId>().toSet();
  }

  Future<void> unlock(Set<RewardId> ids) async {
    if (ids.isEmpty) return;
    final merged = {...await getUnlocked(), ...ids};
    await _persist(merged);
  }

  Future<void> _persist(Set<RewardId> ids) async {
    final values = ids.map((id) => id.storageKey).toList()..sort();
    await _preferences.setStringList(unlockedKey, values);
  }
}

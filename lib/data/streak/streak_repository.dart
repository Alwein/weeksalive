import 'package:shared_preferences/shared_preferences.dart';

class StreakRepository {
  final SharedPreferences _preferences;

  StreakRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _streakCountKey = 'streak_count';

  Future<int> getStreakCount() async {
    return _preferences.getInt(_streakCountKey) ?? 0;
  }

  Future<void> setStreakCount(int count) async {
    await _preferences.setInt(_streakCountKey, count);
  }
}

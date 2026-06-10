import 'package:shared_preferences/shared_preferences.dart';

class WeeklySummaryRepository {
  WeeklySummaryRepository({required SharedPreferences preferences}) : _preferences = preferences;

  final SharedPreferences _preferences;

  static const String _lastCompletedWeekKeyKey = 'weekly_summary_last_completed_week_key';

  Future<String?> getLastCompletedWeekKey() async {
    return _preferences.getString(_lastCompletedWeekKeyKey);
  }

  Future<void> setLastCompletedWeekKey(String weekKey) async {
    await _preferences.setString(_lastCompletedWeekKeyKey, weekKey);
  }
}

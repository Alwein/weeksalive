import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/review/review_prompt_store.dart';

class ReviewPromptRepository implements ReviewPromptStore {
  ReviewPromptRepository({required SharedPreferences preferences}) : _preferences = preferences;

  final SharedPreferences _preferences;

  static const String _hasRequestedKey = 'review_prompt_requested';
  static const String _checkInCountKey = 'review_prompt_check_in_count';
  static const int triggerAtCheckIn = 3;

  @override
  bool get hasRequested => _preferences.getBool(_hasRequestedKey) ?? false;

  @override
  int get checkInCount => _preferences.getInt(_checkInCountKey) ?? 0;

  @override
  Future<int> incrementCheckInCount() async {
    final next = checkInCount + 1;
    await _preferences.setInt(_checkInCountKey, next);
    return next;
  }

  @override
  Future<void> markRequested() async {
    await _preferences.setBool(_hasRequestedKey, true);
  }
}

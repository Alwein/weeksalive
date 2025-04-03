import 'package:shared_preferences/shared_preferences.dart';

class AppOpenCountRepository {
  final SharedPreferences _preferences;

  AppOpenCountRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _openCountKey = 'app_open_count';

  int? _cachedOpenCount;

  Future<int> getAppOpenCount() async {
    if (_cachedOpenCount != null) {
      return _cachedOpenCount!;
    }

    _cachedOpenCount = _preferences.getInt(_openCountKey) ?? 0;
    return _cachedOpenCount!;
  }

  Future<void> incrementAppOpenCount() async {
    final currentCount = await getAppOpenCount();
    await _preferences.setInt(_openCountKey, currentCount + 1);
  }
}

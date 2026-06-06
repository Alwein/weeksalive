import 'package:shared_preferences/shared_preferences.dart';

class NavigationRepository {
  final SharedPreferences _preferences;

  NavigationRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _homeTabIndexKey = 'home_tab_index';

  Future<int> getHomeTabIndex() async {
    return _preferences.getInt(_homeTabIndexKey) ?? 0;
  }

  Future<void> setHomeTabIndex(int index) async {
    await _preferences.setInt(_homeTabIndexKey, index);
  }
}

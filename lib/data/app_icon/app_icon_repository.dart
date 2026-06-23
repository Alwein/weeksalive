import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';

class AppIconRepository {
  final SharedPreferences _preferences;

  AppIconRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _appIconKey = 'app_icon_v1';

  Future<AppIconId> getSelectedIcon() async {
    final value = _preferences.getString(_appIconKey);
    if (value == null) return AppIconId.composer;
    return _parseIconId(value) ?? AppIconId.composer;
  }

  Future<void> setSelectedIcon(AppIconId iconId) async {
    await _preferences.setString(_appIconKey, iconId.storageKey);
  }

  AppIconId? _parseIconId(String value) {
    for (final id in AppIconId.all) {
      if (id.storageKey == value) return id;
    }
    return null;
  }
}

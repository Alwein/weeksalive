import 'package:shared_preferences/shared_preferences.dart';

class DemoModeRepository {
  DemoModeRepository({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  static const String _enabledKey = 'demo_mode_enabled';

  bool isEnabled() => _preferences.getBool(_enabledKey) ?? false;

  Future<void> setEnabled(bool enabled) async {
    await _preferences.setBool(_enabledKey, enabled);
  }
}

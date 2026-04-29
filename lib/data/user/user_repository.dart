import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/domain/user/user.dart';

class UserRepository {
  final SharedPreferences _preferences;

  UserRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _userKey = 'user_key';

  Future<User?> getUser() async {
    final userJson = _preferences.getString(_userKey);
    return userJson != null ? UserExtension.fromJson(jsonDecode(userJson)) : null;
  }

  Future<void> setUser(User user) async {
    await _preferences.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> clearUser() async {
    await _preferences.remove(_userKey);
  }
}

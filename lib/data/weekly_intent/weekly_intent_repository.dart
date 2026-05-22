import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';

class WeeklyIntentRepository {
  final SharedPreferences _preferences;

  WeeklyIntentRepository({required SharedPreferences preferences}) : _preferences = preferences;

  static const String _intentsListKey = 'weekly_intents_list';
  static const String _selectedIdsKey = 'weekly_intents_selected';
  static const String _weekKey = 'weekly_intents_week';

  Future<List<WeeklyIntent>?> getIntents() async {
    final raw = _preferences.getString(_intentsListKey);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => WeeklyIntent.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> setIntents(List<WeeklyIntent> intents) async {
    await _preferences.setString(
      _intentsListKey,
      jsonEncode(intents.map((i) => i.toJson()).toList()),
    );
  }

  Future<List<String>> getSelection() async {
    return _preferences.getStringList(_selectedIdsKey) ?? [];
  }

  Future<void> setSelection(List<String> selectedIds) async {
    await _preferences.setStringList(_selectedIdsKey, selectedIds);
  }

  Future<String?> getWeekKey() async {
    return _preferences.getString(_weekKey);
  }

  Future<void> setWeekKey(String weekKey) async {
    await _preferences.setString(_weekKey, weekKey);
  }
}

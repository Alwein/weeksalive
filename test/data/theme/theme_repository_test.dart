import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';

void main() {
  group('ThemeRepository', () {
    late SharedPreferences preferences;
    late ThemeRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      repository = ThemeRepository(preferences: preferences);
    });

    test('migrates legacy theme_mode to app_theme', () async {
      await preferences.setString('theme_mode', 'dark');
      expect(await repository.getSelectedTheme(), AppThemeId.dark);
      expect(preferences.getString('app_theme'), 'dark');
    });

    test('persists selected theme', () async {
      await repository.setSelectedTheme(AppThemeId.petale);

      expect(await repository.getSelectedTheme(), AppThemeId.petale);
    });
  });
}

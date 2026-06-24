import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/data/app_icon/app_icon_repository.dart';

void main() {
  group('AppIconRepository', () {
    late SharedPreferences preferences;
    late AppIconRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      repository = AppIconRepository(preferences: preferences);
    });

    test('returns composer by default', () async {
      expect(await repository.getSelectedIcon(), AppIconId.defaultIcon);
    });

    test('persists and reads selected icon', () async {
      await repository.setSelectedIcon(AppIconId.gold);
      expect(await repository.getSelectedIcon(), AppIconId.gold);
    });

    test('falls back to composer for unknown stored value', () async {
      await preferences.setString('app_icon_v1', 'unknown');
      expect(await repository.getSelectedIcon(), AppIconId.defaultIcon);
    });
  });
}

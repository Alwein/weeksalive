import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/demo_mode/demo_mode_repository.dart';

void main() {
  group('DemoModeRepository', () {
    late SharedPreferences preferences;
    late DemoModeRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      repository = DemoModeRepository(preferences: preferences);
    });

    test('is disabled by default', () {
      expect(repository.isEnabled(), isFalse);
    });

    test('persists enabled state', () async {
      await repository.setEnabled(true);

      expect(repository.isEnabled(), isTrue);
      expect(DemoModeRepository(preferences: preferences).isEnabled(), isTrue);
    });
  });
}

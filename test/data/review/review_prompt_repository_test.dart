import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/review/review_prompt_repository.dart';

void main() {
  group('ReviewPromptRepository', () {
    late SharedPreferences preferences;
    late ReviewPromptRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      repository = ReviewPromptRepository(preferences: preferences);
    });

    test('starts with zero check-ins and no request flag', () {
      expect(repository.checkInCount, 0);
      expect(repository.hasRequested, isFalse);
    });

    test('incrementCheckInCount increases the counter', () async {
      final first = await repository.incrementCheckInCount();
      final second = await repository.incrementCheckInCount();

      expect(first, 1);
      expect(second, 2);
      expect(repository.checkInCount, 2);
    });

    test('markRequested persists the flag', () async {
      await repository.markRequested();

      expect(repository.hasRequested, isTrue);
    });
  });
}

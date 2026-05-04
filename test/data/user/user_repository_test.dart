import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/domain/user/user.dart';

void main() {
  late UserRepository repository;

  final testUser = User(
    id: 'test-id',
    name: 'Alice',
    dateOfBirth: DateTime(1990, 6, 15),
    gender: Gender.female,
    lifespan: 90,
    notificationTimes: const [TimeOfDay(hour: 9, minute: 0)],
    createdAt: DateTime(2024, 1, 1),
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = UserRepository(preferences: prefs);
  });

  group('UserRepository', () {
    test('getUser returns null when no user is stored', () async {
      final user = await repository.getUser();
      expect(user, isNull);
    });

    test('setUser then getUser returns the same user', () async {
      await repository.setUser(testUser);
      final user = await repository.getUser();

      expect(user, isNotNull);
      expect(user!.id, testUser.id);
      expect(user.name, testUser.name);
      expect(user.gender, testUser.gender);
      expect(user.lifespan, testUser.lifespan);
      expect(user.dateOfBirth, testUser.dateOfBirth);
      expect(user.createdAt, testUser.createdAt);
      expect(user.notificationTimes, testUser.notificationTimes);
    });

    test('setUser overwrites a previously stored user', () async {
      await repository.setUser(testUser);

      final updatedUser = testUser.copyWith(name: 'Bob', lifespan: 80);
      await repository.setUser(updatedUser);

      final user = await repository.getUser();
      expect(user!.name, 'Bob');
      expect(user.lifespan, 80);
    });
  });
}

import 'package:weeksalive/data/auth/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/mocks.dart';

void main() {
  late MockCrashlyticsRepository crashlyticsRepository;
  late MockFirebaseAuth firebaseAuth;
  late MockUserRepository userRepository;

  late AuthRepository authRepository;

  setUp(() {
    crashlyticsRepository = MockCrashlyticsRepository();
    firebaseAuth = MockFirebaseAuth();
    userRepository = MockUserRepository();

    authRepository = AuthRepository(
      crashlyticsRepository: crashlyticsRepository,
      firebaseAuth: firebaseAuth,
    );
  });

  group('AuthRepository', () {
    group('signInAnonymously', () {
      test('should create user on sign in success', () async {
        // Given
        firebaseAuth.withSignInAnonymouslySuccess(FakeFirebaseUser(givenId: 'testUserId'));
        userRepository.withCreateUserSuccess();

        // When
        await authRepository.signInAnonymously();

        // Then
        verify(() => userRepository.createUser("testUserId")).called(1);
      });

      test('should not create user on sign in error', () async {
        // Given
        firebaseAuth.withSignInAnonymouslySuccess(null);
        userRepository.withCreateUserSuccess();

        // When
        await authRepository.signInAnonymously();

        // Then
        verifyNever(() => userRepository.createUser("testUserId")).called(0);
      });
    });
  });
}

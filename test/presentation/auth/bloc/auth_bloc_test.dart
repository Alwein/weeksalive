import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_fast_template/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/mocks.dart';

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('AuthBloc', () {
    group('_authCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should sign in anonymously when user is null',
        build: () => AuthBloc(authRepository),
        setUp: () {
          authRepository.withCurrentUser(null);
          authRepository.withAuthStateChanges([null]);
        },
        act: (bloc) => bloc.add(const AuthEvent.authCheckRequested()),
        expect: () => const <AuthState>[AuthState.unauthenticated()],
        verify: (bloc) => verify(() => authRepository.signInAnonymously()).called(1),
      );

      blocTest<AuthBloc, AuthState>(
        'should emit authenticated state when user is not null',
        build: () => AuthBloc(authRepository),
        setUp: () {
          authRepository.withCurrentUser(FakeFirebaseUser());
          authRepository.withAuthStateChanges([FakeFirebaseUser()]);
        },
        act: (bloc) => bloc.add(const AuthEvent.authCheckRequested()),
        expect: () => const <AuthState>[
          AuthState.authenticated(userId: '123', isAnonymous: false),
        ],
        verify: (bloc) => verifyNever(() => authRepository.signInAnonymously()).called(0),
      );
    });

    group('_userChanged', () {
      blocTest<AuthBloc, AuthState>(
        'should emit unauthenticated state when user changed to null',
        build: () => AuthBloc(authRepository),
        setUp: () {
          authRepository.withAuthStateChanges([null]);
        },
        expect: () => const <AuthState>[AuthState.unauthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'should emit unauthenticated state when user changed to null',
        build: () => AuthBloc(authRepository),
        setUp: () {
          authRepository.withAuthStateChanges([FakeFirebaseUser()]);
        },
        expect: () => const <AuthState>[
          AuthState.authenticated(userId: '123', isAnonymous: false),
        ],
      );
    });
  });
}

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_fast_template/data/app_open_count/app_open_count_repository.dart';
import 'package:flutter_fast_template/data/auth/auth_repository.dart';
import 'package:flutter_fast_template/data/crashlytics/crashlytics_repository.dart';
import 'package:flutter_fast_template/data/device/configuration_repository.dart';
import 'package:flutter_fast_template/data/remote_config/remote_config_repository.dart';
import 'package:flutter_fast_template/data/services/firestore_user_queries.dart';
import 'package:flutter_fast_template/data/user/user_repository.dart';
import 'package:flutter_fast_template/domain/remote_config/remote_config.dart';
import 'package:flutter_fast_template/domain/user/user.dart';
import 'package:mocktail/mocktail.dart';

class FakeFirebaseUser extends Fake implements auth.User {
  FakeFirebaseUser({
    this.givenId = '123',
    this.givenIsAnonymous = false,
  });

  final String givenId;

  final bool givenIsAnonymous;

  @override
  String get uid => givenId;

  @override
  bool get isAnonymous => givenIsAnonymous;
}

class MockAuthRepository extends Mock implements AuthRepository {
  MockAuthRepository() {
    registerFallbackValue(FakeFirebaseUser());
    when(() => signInAnonymously()).thenAnswer((_) async {});
    when(() => signOut()).thenAnswer((_) async {});
  }

  void withCurrentUser(auth.User? user) {
    when(() => currentUser).thenReturn(user);
  }

  void withAuthStateChanges(List<auth.User?> changes) {
    when(() => authStateChanges()).thenAnswer((_) => Stream<auth.User?>.fromIterable(changes));
  }
}

class MockFirestoreUserQueries extends Mock implements FirestoreUserQueries {
  void withSetUserDocumentSuccess() {
    when(() => setUserDocument(userId: any(named: 'userId'), data: any(named: 'data'))).thenAnswer((_) async {});
  }

  void withSetUserDocumentError() {
    when(() => setUserDocument(userId: any(named: 'userId'), data: any(named: 'data')))
        .thenThrow(Exception('Firestore error'));
  }
}

class FakeStackTrace extends Fake implements StackTrace {}

class MockCrashlyticsRepository extends Mock implements CrashlyticsRepository {
  MockCrashlyticsRepository() {
    registerFallbackValue(FakeStackTrace());
    when(() => recordError(any(), any())).thenAnswer((_) async {});
  }
}

class FakeUserCredential extends Fake implements auth.UserCredential {
  FakeUserCredential({this.givenUser});

  final auth.User? givenUser;

  @override
  auth.User? get user => givenUser;
}

class MockFirebaseAuth extends Mock implements auth.FirebaseAuth {
  void withSignInAnonymouslySuccess(FakeFirebaseUser? user) {
    when(() => signInAnonymously()).thenAnswer((_) async => FakeUserCredential(givenUser: user));
  }
}

class MockUserRepository extends Mock implements UserRepository {
  void withCreateUserSuccess() {
    when(() => createUser(any())).thenAnswer(
      (_) async => User(
        id: 'testUserId',
        premiumPlan: null,
        createdAt: DateTime(2025),
      ),
    );
  }
}

class MockRemoteConfigRepository extends Mock implements RemoteConfigRepository {
  void withRemoteConfig(AppRemoteConfig remoteConfig) {
    when(() => getRemoteConfig()).thenAnswer((_) async => remoteConfig);
  }
}

class MockConfigurationRepository extends Mock implements ConfigurationRepository {
  void withAppVersion(String version) {
    when(() => getAppVersion()).thenAnswer((_) async => version);
  }
}

class MockAppOpenCountRepository extends Mock implements AppOpenCountRepository {
  MockAppOpenCountRepository() {
    when(() => getAppOpenCount()).thenAnswer((_) async => 0);
    when(() => incrementAppOpenCount()).thenAnswer((_) async {});
  }
  void withAppOpenCount(int count) {
    when(() => getAppOpenCount()).thenAnswer((_) async => count);
  }

  void withIncrementAppOpenCount() {
    when(() => incrementAppOpenCount()).thenAnswer((_) async {});
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fast_template/data/crashlytics/crashlytics_repository.dart';

class AuthRepository {
  final CrashlyticsRepository _crashlyticsRepository;
  final FirebaseAuth _firebaseAuth;

  AuthRepository({
    required CrashlyticsRepository crashlyticsRepository,
    FirebaseAuth? firebaseAuth,
  }) : _crashlyticsRepository = crashlyticsRepository,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } catch (e, s) {
      _crashlyticsRepository.recordError(e, s);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e, s) {
      _crashlyticsRepository.recordError(e, s);
      rethrow;
    }
  }

  Future<AuthResult> linkAnonymousUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || !user.isAnonymous) {
        return NotAnonymousUser();
      }
      final credential = EmailAuthProvider.credential(email: email, password: password);
      await _firebaseAuth.currentUser!.linkWithCredential(credential);
      return AuthSuccess();
    } on FirebaseAuthException catch (e) {
      return e.toAuthError;
    } catch (e, s) {
      _crashlyticsRepository.recordError(e, s);
      return AuthInternalError();
    }
  }

  Future<AuthResult> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return AuthSuccess();
    } on FirebaseAuthException catch (e) {
      return e.toAuthError;
    } catch (e, s) {
      _crashlyticsRepository.recordError(e, s);
      return AuthInternalError();
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;
}

sealed class AuthResult {}

class AuthSuccess extends AuthResult {}

sealed class AuthError extends AuthResult {}

class NotAnonymousUser extends AuthError {}

class AuthInternalError extends AuthError {}

class UserNotFound extends AuthError {}

class InvalidEmail extends AuthError {}

class UserMismatch extends AuthError {}

class InvalidCredential extends AuthError {}

class WrongPassword extends AuthError {}

class WeakPassword extends AuthError {}

class EmailAlreadyInUse extends AuthError {}

class OperationNotAllowed extends AuthError {}

class UserDisabled extends AuthError {}

class ProviderAlreadyLinked extends AuthError {}

class CredentialAlreadyInUse extends AuthError {}

class AuthGenericError extends AuthError {}

extension on FirebaseAuthException {
  AuthError get toAuthError {
    return switch (code) {
      'auth/user-not-found' || 'user-not-found' => UserNotFound(),
      'auth/invalid-email' || 'invalid-email' => InvalidEmail(),
      'user-mismatch' => UserMismatch(),
      'invalid-credential' => InvalidCredential(),
      'wrong-password' => WrongPassword(),
      'weak-password' => WeakPassword(),
      'email-already-in-use' => EmailAlreadyInUse(),
      'operation-not-allowed' => OperationNotAllowed(),
      'user-disabled' => UserDisabled(),
      'provider-already-linked' => ProviderAlreadyLinked(),
      'credential-already-in-use' || 'account-exists-with-different-credential' => CredentialAlreadyInUse(),
      _ => AuthGenericError(),
    };
  }
}

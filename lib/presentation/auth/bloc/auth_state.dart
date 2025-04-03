part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.authenticated({required String userId, required bool isAnonymous}) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
}

extension AuthStateExt on AuthState {
  bool get isUserAnonymous => maybeMap(
        authenticated: (state) => state.isAnonymous,
        orElse: () => false,
      );

  String? userIdOrNull() => maybeMap(
        authenticated: (state) => state.userId,
        orElse: () => null,
      );
}

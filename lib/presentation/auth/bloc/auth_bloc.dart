import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fast_template/data/auth/auth_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(const AuthState.unauthenticated()) {
    _userSubscription = authRepository.authStateChanges().listen((user) {
      add(AuthEvent.userChanged(user: user));
    });

    on<AuthEvent>(
      (event, emit) => event.map(
        authCheckRequested: (event) => _authCheckRequested(event, emit),
        userChanged: (event) => _userChanged(event, emit),
      ),
    );
  }

  final AuthRepository authRepository;
  late final StreamSubscription<User?> _userSubscription;

  Future<void> _authCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await authRepository.signInAnonymously();
    } else {
      emit(AuthState.authenticated(userId: user.uid, isAnonymous: user.isAnonymous));
    }
  }

  FutureOr<void> _userChanged(UserChanged event, Emitter<AuthState> emit) {
    emit(event.user == null
        ? const AuthState.unauthenticated()
        : AuthState.authenticated(userId: event.user!.uid, isAnonymous: event.user!.isAnonymous));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

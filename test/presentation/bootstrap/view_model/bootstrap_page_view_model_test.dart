import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/bootstrap/view_model/bootstrap_page_view_model.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

import '../../../helpers/test_app_state.dart';
import '../../../helpers/test_store_factory.dart';

void main() {
  group('BootstrapPageViewModel', () {
    BootstrapPageViewModel buildViewModel({required UserState userState}) {
      final store = TestStoreFactory().initializeReduxStore(
        initialAppState().copyWith(userState: userState),
      );
      return BootstrapPageViewModel.create(store);
    }

    test('redirects to splash when user is loading', () {
      final viewModel = buildViewModel(userState: const UserState.loading());

      expect(viewModel.redirect, BootstrapPageRedirect.splash);
    });

    test('redirects to splash when user state is an error', () {
      final viewModel = buildViewModel(userState: const UserState.error('error'));

      expect(viewModel.redirect, BootstrapPageRedirect.splash);
    });

    test('redirects to onboarding when no user is found', () {
      final viewModel = buildViewModel(userState: const UserState.success(null));

      expect(viewModel.redirect, BootstrapPageRedirect.onboarding);
    });

    test('redirects to home when user is found', () {
      final user = User(
        id: '1',
        name: 'Adrien',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: Gender.male,
        lifespan: 90,
        notificationTime: const TimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime(2024, 1, 1),
      );
      final viewModel = buildViewModel(userState: UserState.success(user));

      expect(viewModel.redirect, BootstrapPageRedirect.home);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/day_form/day_form_view_model.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

import '../../helpers/test_app_state.dart';
import '../../helpers/test_store_factory.dart';

void main() {
  group('DayFormViewModel', () {
    DayFormViewModel buildViewModel({required UserState userState, required DateTime date}) {
      final store = TestStoreFactory().initializeReduxStore(
        initialAppState().copyWith(userState: userState),
      );
      return DayFormViewModel.create(store, date);
    }

    User makeUser({required DateTime dateOfBirth}) => User(
          id: '1',
          name: 'Adrien',
          dateOfBirth: dateOfBirth,
          gender: Gender.male,
          lifespan: 90,
          createdAt: DateTime(2024, 1, 1),
        );

    test('day count is 1 on the date of birth', () {
      final dob = DateTime(1990, 6, 15);
      final vm = buildViewModel(
        userState: UserState.success(makeUser(dateOfBirth: dob)),
        date: dob,
      );

      expect(vm.dayCount, '1');
    });

    test('day count is 2 the day after birth', () {
      final dob = DateTime(1990, 6, 15);
      final vm = buildViewModel(
        userState: UserState.success(makeUser(dateOfBirth: dob)),
        date: DateTime(1990, 6, 16),
      );

      expect(vm.dayCount, '2');
    });

    test('day count increases by 1 per day regardless of time', () {
      final dob = DateTime(1990, 1, 1);
      final date = DateTime(1990, 1, 1, 23, 59, 59);
      final vm = buildViewModel(
        userState: UserState.success(makeUser(dateOfBirth: dob)),
        date: date,
      );

      expect(vm.dayCount, '1');
    });

    test('day count is correct for a past date', () {
      final dob = DateTime(1990, 1, 1);
      final date = DateTime(1990, 1, 11);
      final vm = buildViewModel(
        userState: UserState.success(makeUser(dateOfBirth: dob)),
        date: date,
      );

      expect(vm.dayCount, '11');
    });

    test('day count is 1 when user is not loaded', () {
      final vm = buildViewModel(
        userState: const UserState.loading(),
        date: DateTime(2024, 5, 21),
      );

      expect(vm.dayCount, '1');
    });

    test('day count is 1 when no user is found', () {
      final vm = buildViewModel(
        userState: const UserState.success(null),
        date: DateTime(2024, 5, 21),
      );

      expect(vm.dayCount, '1');
    });

    test('day count is 1 when date is before date of birth', () {
      final dob = DateTime(1990, 6, 15);
      final vm = buildViewModel(
        userState: UserState.success(makeUser(dateOfBirth: dob)),
        date: DateTime(1990, 1, 1),
      );

      expect(vm.dayCount, '1');
    });
  });
}
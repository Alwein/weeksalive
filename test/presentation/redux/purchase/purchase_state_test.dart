import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

import '../../../fixtures/purchase_fixtures.dart';
import '../../../helpers/matchers.dart';
import '../../../helpers/store_tester.dart';
import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

class _FakeCustomerInfo extends Fake implements CustomerInfo {}

class _FakePackage extends Fake implements Package {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeCustomerInfo());
    registerFallbackValue(_FakePackage());
  });

  group('PurchaseState types', () {
    test('each variant is typed correctly', () {
      expect(const PurchaseState.initial(), isA<PurchaseStateInitial>());
      expect(const PurchaseState.loading(), isA<PurchaseStateLoading>());
      expect(const PurchaseState.idle(offering: null, isPro: false), isA<PurchaseStateIdle>());
      expect(const PurchaseState.error(message: 'err', isPro: false), isA<PurchaseStateError>());
    });

    test('isPro extension returns false unless idle/error with isPro:true', () {
      expect(const PurchaseState.initial().isPro, isFalse);
      expect(const PurchaseState.loading().isPro, isFalse);
      expect(const PurchaseState.idle(offering: null, isPro: false).isPro, isFalse);
      expect(const PurchaseState.idle(offering: null, isPro: true).isPro, isTrue);
      expect(const PurchaseState.error(message: 'e', isPro: false).isPro, isFalse);
      expect(const PurchaseState.error(message: 'e', isPro: true).isPro, isTrue);
    });

    test('isLoading extension returns true only for loading variant', () {
      expect(const PurchaseState.initial().isLoading, isFalse);
      expect(const PurchaseState.loading().isLoading, isTrue);
      expect(const PurchaseState.idle(offering: null, isPro: false).isLoading, isFalse);
    });

    test('offering extension propagates through all stateful variants', () {
      final offering = offeringFixture();
      expect(const PurchaseState.initial().offering, isNull);
      expect(PurchaseState.loading(offering: offering).offering, offering);
      expect(PurchaseState.idle(offering: offering, isPro: false).offering, offering);
      expect(PurchaseState.error(message: 'e', offering: offering, isPro: false).offering, offering);
    });
  });

  group('bootstrap', () {
    late StoreTester storeTester;
    final purchaseRepo = MockPurchaseRepository();

    setUp(() => storeTester = StoreTester());

    test('transitions initial → idle(isPro:false) when user has no subscription', () {
      when(() => purchaseRepo.fetchCurrentOffering()).thenAnswer((_) async => null);
      when(() => purchaseRepo.getCustomerInfo()).thenAnswer((_) async => customerInfoFixture());
      when(() => purchaseRepo.isPro(any())).thenReturn(false);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = purchaseRepo;
        },
      );

      storeTester.whenDispatching(() => BootstrapAction());

      storeTester.thenExpectStatesInOrder([
        stateWith(
          (s) => s.purchaseState,
          isA<PurchaseStateIdle>().where((s) => s.isPro, isFalse).where((s) => s.offering, isNull),
        ),
      ]);
    });

    test('transitions initial → idle(isPro:true) when user is already subscribed', () {
      final customerInfo = customerInfoFixture(isPro: true);
      when(() => purchaseRepo.fetchCurrentOffering()).thenAnswer((_) async => null);
      when(() => purchaseRepo.getCustomerInfo()).thenAnswer((_) async => customerInfo);
      when(() => purchaseRepo.isPro(any())).thenReturn(true);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = purchaseRepo;
        },
      );

      storeTester.whenDispatching(() => BootstrapAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.purchaseState, isA<PurchaseStateIdle>().where((s) => s.isPro, isTrue)),
      ]);
    });

    test('loads the offering and exposes it on idle state', () {
      final offering = offeringFixture(id: 'trial_14d', trialDays: 14);
      when(() => purchaseRepo.fetchCurrentOffering()).thenAnswer((_) async => offering);
      when(() => purchaseRepo.getCustomerInfo()).thenAnswer((_) async => customerInfoFixture());
      when(() => purchaseRepo.isPro(any())).thenReturn(false);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = purchaseRepo;
        },
      );

      storeTester.whenDispatching(() => BootstrapAction());

      storeTester.thenExpectStatesInOrder([
        stateWith(
          (s) => s.purchaseState,
          isA<PurchaseStateIdle>()
              .where((s) => s.offering?.identifier, 'trial_14d')
              .where((s) => s.offering?.metadata['trial_days'], 14),
        ),
      ]);
    });

    test('stays idle with null offering when fetchCurrentOffering throws', () {
      when(() => purchaseRepo.fetchCurrentOffering()).thenThrow(Exception('network error'));
      when(() => purchaseRepo.getCustomerInfo()).thenAnswer((_) async => customerInfoFixture());
      when(() => purchaseRepo.isPro(any())).thenReturn(false);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = purchaseRepo;
        },
      );

      storeTester.whenDispatching(() => BootstrapAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.purchaseState, isA<PurchaseStateIdle>().where((s) => s.offering, isNull)),
      ]);
    });
  });

  group('FetchOfferingAction', () {
    late StoreTester storeTester;
    final repository = MockPurchaseRepository();

    setUp(() => storeTester = StoreTester());

    test('refreshes the offering independently of bootstrap', () {
      final offering = offeringFixture(id: 'trial_30d', trialDays: 30);
      when(() => repository.fetchCurrentOffering()).thenAnswer((_) async => offering);
      when(() => repository.getCustomerInfo()).thenAnswer((_) async => customerInfoFixture());
      when(() => repository.isPro(any())).thenReturn(false);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = repository;
        },
      );

      storeTester.whenDispatching(() => const FetchOfferingAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.purchaseState, isA<PurchaseStateLoading>()),
        stateWith(
          (s) => s.purchaseState,
          isA<PurchaseStateIdle>()
              .where((s) => s.offering?.identifier, 'trial_30d')
              .where((s) => s.offering?.metadata['trial_days'], 30),
        ),
      ]);
    });
  });

  group('PurchasePackageAction', () {
    late StoreTester storeTester;
    final repository = MockPurchaseRepository();
    final package = packageFixture();

    setUp(() => storeTester = StoreTester());

    test('transitions to loading then idle(isPro:true) on success', () {
      final customerInfo = customerInfoFixture(isPro: true);
      when(() => repository.purchasePackage(any())).thenAnswer((_) async => customerInfo);
      when(() => repository.isPro(any())).thenReturn(true);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = repository;
        },
      );

      storeTester.whenDispatching(() => PurchasePackageAction(package));

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.purchaseState, isA<PurchaseStateLoading>()),
        stateWith((s) => s.purchaseState, isA<PurchaseStateIdle>().where((s) => s.isPro, isTrue)),
      ]);
    });

    test('transitions to error state when purchase throws a non-cancel error', () {
      when(() => repository.purchasePackage(any())).thenThrow(Exception('payment declined'));
      when(() => repository.isPro(any())).thenReturn(false);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = repository;
        },
      );

      storeTester.whenDispatching(() => PurchasePackageAction(package));

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.purchaseState, isA<PurchaseStateLoading>()),
        stateWith((s) => s.purchaseState, isA<PurchaseStateError>().where((s) => s.isPro, isFalse)),
      ]);
    });

    test('does not emit error state when purchase is cancelled by user', () {
      when(() => repository.purchasePackage(any())).thenThrow(PurchasesErrorCode.purchaseCancelledError);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = repository;
        },
      );

      storeTester.whenDispatching(() => PurchasePackageAction(package));

      storeTester.thenExpectNever(
        stateWith((s) => s.purchaseState, isA<PurchaseStateError>()),
      );
    });
  });

  group('RestorePurchasesAction', () {
    late StoreTester storeTester;
    final repository = MockPurchaseRepository();

    setUp(() => storeTester = StoreTester());

    test('transitions to idle(isPro:true) when active subscription is found', () {
      final customerInfo = customerInfoFixture(isPro: true);
      when(() => repository.restorePurchases()).thenAnswer((_) async => customerInfo);
      when(() => repository.isPro(any())).thenReturn(true);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = repository;
        },
      );

      storeTester.whenDispatching(() => const RestorePurchasesAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.purchaseState, isA<PurchaseStateLoading>()),
        stateWith((s) => s.purchaseState, isA<PurchaseStateIdle>().where((s) => s.isPro, isTrue)),
      ]);
    });

    test('transitions to idle(isPro:false) when no active subscription found', () {
      when(() => repository.restorePurchases()).thenAnswer((_) async => customerInfoFixture());
      when(() => repository.isPro(any())).thenReturn(false);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = repository;
        },
      );

      storeTester.whenDispatching(() => const RestorePurchasesAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.purchaseState, isA<PurchaseStateLoading>()),
        stateWith((s) => s.purchaseState, isA<PurchaseStateIdle>().where((s) => s.isPro, isFalse)),
      ]);
    });

    test('transitions to error state when restore throws', () {
      when(() => repository.restorePurchases()).thenThrow(Exception('network error'));

      storeTester.givenStore(
        initialAppState(),
        configure: (f) {
          f.purchaseRepository = repository;
        },
      );

      storeTester.whenDispatching(() => const RestorePurchasesAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.purchaseState, isA<PurchaseStateLoading>()),
        stateWith((s) => s.purchaseState, isA<PurchaseStateError>()),
      ]);
    });
  });

  group('ClearPurchaseErrorAction', () {
    late StoreTester storeTester;
    final repository = MockPurchaseRepository();

    setUp(() => storeTester = StoreTester());

    test('clears error and returns to idle, preserving offering and isPro', () {
      final offering = offeringFixture();
      when(() => repository.restorePurchases()).thenThrow(Exception('oops'));

      storeTester.givenStore(
        initialAppState().copyWith(
          purchaseState: PurchaseState.error(
            message: 'previous error',
            offering: offering,
            isPro: false,
          ),
        ),
        configure: (f) => f.purchaseRepository = repository,
      );

      storeTester.whenDispatching(() => const ClearPurchaseErrorAction());

      storeTester.thenExpectStatesInOrder([
        stateWith(
          (s) => s.purchaseState,
          isA<PurchaseStateIdle>().where((s) => s.isPro, isFalse).where((s) => s.offering, offering),
        ),
      ]);
    });
  });
}

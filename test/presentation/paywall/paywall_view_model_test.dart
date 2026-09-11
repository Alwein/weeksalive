import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/paywall/paywall_view_model.dart';

import '../../fixtures/purchase_fixtures.dart';

void main() {
  group('PaywallViewModel.trialDaysFromOffering', () {
    test('uses offering metadata when StoreKit has no intro price', () {
      final offering = offeringFixture(id: 'trial_14d', trialDays: 14);

      expect(PaywallViewModel.trialDaysFromOffering(offering), 14);
      expect(PaywallViewModel.trialWeeksFromOffering(offering), 2);
    });

    test('keeps 14-day metadata even if StoreKit still reports a 1-month intro', () {
      final offering = offeringFixture(
        id: 'trial_14d',
        trialDays: 14,
        introPrice: introPriceFixture(period: 'P1M', periodUnit: 'MONTH', periodNumberOfUnits: 1),
      );

      expect(PaywallViewModel.trialDaysFromOffering(offering), 14);
      expect(PaywallViewModel.trialWeeksFromOffering(offering), 2);
    });

    test('falls back to StoreKit ISO period when metadata is missing', () {
      final offering = offeringFixture(
        id: 'trial_14d',
        includeTrialMetadata: false,
        introPrice: introPriceFixture(period: 'P2W', periodUnit: 'MONTH', periodNumberOfUnits: 1),
      );

      expect(PaywallViewModel.trialDaysFromOffering(offering), 14);
      expect(PaywallViewModel.trialWeeksFromOffering(offering), 2);
    });

    test('keeps 30-day metadata for the alternate offering', () {
      final offering = offeringFixture(
        id: 'trial_30d',
        trialDays: 30,
        introPrice: introPriceFixture(period: 'P1M', periodUnit: 'MONTH', periodNumberOfUnits: 1),
      );

      expect(PaywallViewModel.trialDaysFromOffering(offering), 30);
      expect(PaywallViewModel.trialWeeksFromOffering(offering), 4);
    });

    test('returns null when offering is null', () {
      expect(PaywallViewModel.trialDaysFromOffering(null), isNull);
      expect(PaywallViewModel.trialWeeksFromOffering(null), isNull);
    });
  });

  group('PaywallPlanData.fromOffering', () {
    test('exposes metadata trial length on the plan', () {
      final offering = offeringFixture(
        id: 'trial_14d',
        trialDays: 14,
        introPrice: introPriceFixture(period: 'P1M', periodUnit: 'MONTH', periodNumberOfUnits: 1),
      );

      final plan = PaywallPlanData.fromOffering(offering);
      expect(plan?.trialDays, 14);
      expect(plan?.trialWeeks, 2);
      expect(plan?.offeringId, 'trial_14d');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/paywall/paywall_view_model.dart';

import '../../fixtures/purchase_fixtures.dart';

void main() {
  group('PaywallViewModel.trialWeeksFromOffering', () {
    test('rounds the trial length to weeks', () {
      expect(
        PaywallViewModel.trialWeeksFromOffering(
          offeringFixture(id: 'trial_14d', trialDays: 14),
        ),
        2,
      );
      expect(
        PaywallViewModel.trialWeeksFromOffering(
          offeringFixture(id: 'trial_30d', trialDays: 30),
        ),
        4,
      );
    });

    test('returns null when offering is null', () {
      expect(PaywallViewModel.trialWeeksFromOffering(null), isNull);
    });
  });

  group('PaywallPlanData.fromOffering', () {
    test('exposes metadata trial length on the plan', () {
      final offering = offeringFixture(
        id: 'trial_14d',
        trialDays: 14,
        introPrice: introPriceFixture(
          period: 'P1M',
          periodUnit: 'MONTH',
          periodNumberOfUnits: 1,
        ),
      );

      final plan = PaywallPlanData.fromOffering(offering);
      expect(plan?.trialDays, 14);
      expect(plan?.trialWeeks, 2);
      expect(plan?.offeringId, 'trial_14d');
    });
  });

  group('PaywallViewModel.plansFromOffering', () {
    test('lists annual, weekly and lifetime with no trial', () {
      final plans = PaywallViewModel.plansFromOffering(plansOfferingFixture());

      expect(plans.map((plan) => plan.kind).toList(), [
        PaywallPlanKind.annual,
        PaywallPlanKind.weekly,
        PaywallPlanKind.lifetime,
      ]);
      expect(plans[0].price, r'$49.99');
      expect(plans[0].equivalentWeeklyPrice, isNotNull);
      expect(plans[0].savingsPercent, 76);
      expect(plans[1].price, r'$3.99');
      expect(plans[1].equivalentWeeklyPrice, isNull);
      expect(plans[2].price, r'$119.99');
    });

    test('returns an empty list when the plans offering is missing', () {
      expect(PaywallViewModel.plansFromOffering(null), isEmpty);
    });
  });

  group('PaywallViewModel.weeklyPrice', () {
    test('formats the weekly equivalent for the device locale', () {
      final annual = packageFixture(price: 49.99, currencyCode: 'EUR');

      final price = PaywallViewModel.weeklyPrice(annual, locale: 'fr_FR');

      expect(price, contains('0,96'));
      expect(price, contains('€'));
      expect(price, isNot(startsWith('€')));
    });

    test('drops the minor unit for currencies that have none', () {
      final annual = packageFixture(price: 5000, currencyCode: 'JPY');

      expect(PaywallViewModel.weeklyPrice(annual, locale: 'en_US'), '¥96');
    });

    test('falls back to the default locale when the locale is unknown', () {
      final annual = packageFixture(price: 49.99);

      expect(PaywallViewModel.weeklyPrice(annual, locale: 'xx_XX'), r'$0.96');
    });
  });

  group('PaywallViewModel equality', () {
    test('two view models built from the same state are equal', () {
      PaywallViewModel build() => PaywallViewModel(
        primaryPlan: PaywallPlanData.fromOffering(offeringFixture()),
        alternatePlan: null,
        plans: PaywallViewModel.plansFromOffering(plansOfferingFixture()),
        isLoading: false,
        isPro: false,
        errorMessage: null,
      );

      expect(build(), build());
    });
  });

  group('PaywallViewModel.savingsPercent', () {
    test('rounds the discount versus a year of weekly payments', () {
      expect(
        PaywallViewModel.savingsPercent(annualPrice: 49.99, weeklyPrice: 3.99),
        76,
      );
    });

    test('hides the badge when the annual plan is not cheaper', () {
      expect(
        PaywallViewModel.savingsPercent(annualPrice: 220, weeklyPrice: 3.99),
        isNull,
      );
      expect(
        PaywallViewModel.savingsPercent(annualPrice: 49.99, weeklyPrice: 0),
        isNull,
      );
    });
  });
}

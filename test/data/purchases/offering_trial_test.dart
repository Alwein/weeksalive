import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/data/purchases/offering_trial.dart';

import '../../fixtures/purchase_fixtures.dart';

void main() {
  group('OfferingTrialX.trialDays', () {
    test('uses offering metadata when StoreKit has no intro price', () {
      final offering = offeringFixture(id: 'trial_14d', trialDays: 14);

      expect(offering.trialDays, 14);
    });

    test(
      'keeps 14-day metadata even if StoreKit still reports a 1-month intro',
      () {
        final offering = offeringFixture(
          id: 'trial_14d',
          trialDays: 14,
          introPrice: introPriceFixture(
            period: 'P1M',
            periodUnit: 'MONTH',
            periodNumberOfUnits: 1,
          ),
        );

        expect(offering.trialDays, 14);
      },
    );

    test('falls back to StoreKit ISO period when metadata is missing', () {
      final offering = offeringFixture(
        id: 'trial_14d',
        includeTrialMetadata: false,
        introPrice: introPriceFixture(
          period: 'P2W',
          periodUnit: 'MONTH',
          periodNumberOfUnits: 1,
        ),
      );

      expect(offering.trialDays, 14);
    });

    test('is null without metadata nor intro offer', () {
      final offering = offeringFixture(
        id: 'no_trial',
        includeTrialMetadata: false,
      );

      expect(offering.trialDays, isNull);
    });
  });
}

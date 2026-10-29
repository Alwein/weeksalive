import 'package:flutter_test/flutter_test.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:weeksalive/data/purchases/offering_trial.dart';

import '../../fixtures/purchase_fixtures.dart';

void main() {
  group('OfferingTrialX.trialDays', () {
    test('reads the intro offer of the annual product', () {
      final offering = offeringFixture(
        id: 'trial_14d',
        introPrice: introPriceFixture(
          period: 'P2W',
          periodUnit: 'WEEK',
          periodNumberOfUnits: 2,
        ),
      );

      expect(offering.trialDays, 14);
    });

    test('ignores the trial_days metadata older builds relied on', () {
      final annual = packageFixture(
        offeringId: 'trial_14d',
        introPrice: introPriceFixture(
          period: 'P1M',
          periodUnit: 'MONTH',
          periodNumberOfUnits: 1,
        ),
      );
      final offering = Offering(
        'trial_14d',
        'Standard offering',
        const {'trial_days': 14},
        [annual],
        annual: annual,
      );

      expect(offering.trialDays, 30);
    });

    test('prefers the ISO period over the period unit', () {
      final offering = offeringFixture(
        id: 'trial_14d',
        introPrice: introPriceFixture(
          period: 'P2W',
          periodUnit: 'MONTH',
          periodNumberOfUnits: 1,
        ),
      );

      expect(offering.trialDays, 14);
    });

    test('is null without an intro offer', () {
      final offering = offeringFixture(id: 'no_trial', trialDays: null);

      expect(offering.trialDays, isNull);
    });
  });
}

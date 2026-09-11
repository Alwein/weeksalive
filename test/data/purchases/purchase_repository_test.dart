import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';

import '../../fixtures/purchase_fixtures.dart';

void main() {
  late PurchaseRepository repository;

  setUp(() {
    final dotenv = DotEnv()..testLoad(fileInput: '');
    repository = PurchaseRepository(dotenv: dotenv);
  });

  group('alternateOffering', () {
    test('skips offerings that have no annual package', () {
      final current = offeringFixture(id: 'trial_14d');
      final emptyDefault = offeringFixture(id: 'default', includeAnnual: false);
      final other = offeringFixture(id: 'trial_30d', trialDays: 30);
      final offerings = Offerings({
        'default': emptyDefault,
        'trial_14d': current,
        'trial_30d': other,
      }, current: current);

      expect(repository.alternateOffering(offerings, current)?.identifier, 'trial_30d');
    });

    test('returns null when the only other offering has no products', () {
      final current = offeringFixture(id: 'trial_14d');
      final emptyDefault = offeringFixture(id: 'default', includeAnnual: false);
      final offerings = Offerings({
        'default': emptyDefault,
        'trial_14d': current,
      }, current: current);

      expect(repository.alternateOffering(offerings, current), isNull);
    });

    test('returns null when there is no current offering', () {
      final trial = offeringFixture(id: 'trial_14d');
      final offerings = Offerings({'trial_14d': trial}, current: trial);

      expect(repository.alternateOffering(offerings, null), isNull);
    });
  });
}

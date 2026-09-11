import 'package:purchases_flutter/purchases_flutter.dart';

CustomerInfo customerInfoFixture({bool isPro = false}) {
  final entitlementJson = isPro
      ? {
          'WeeksAlive Pro': {
            'identifier': 'WeeksAlive Pro',
            'isActive': true,
            'willRenew': true,
            'latestPurchaseDate': '2026-01-01T00:00:00Z',
            'originalPurchaseDate': '2026-01-01T00:00:00Z',
            'productIdentifier': 'yearly',
            'isSandbox': true,
            'billingIssueDetectedAt': null,
            'unsubscribeDetectedAt': null,
            'ownershipType': 'PURCHASED',
            'store': 'APP_STORE',
            'periodType': 'NORMAL',
            'expirationDate': '2027-01-01T00:00:00Z',
            'verification': 'NOT_REQUESTED',
          },
        }
      : <String, dynamic>{};

  return CustomerInfo.fromJson({
    'entitlements': {'all': entitlementJson, 'active': entitlementJson, 'verification': 'NOT_REQUESTED'},
    'allPurchaseDates': const <String, dynamic>{},
    'activeSubscriptions': isPro ? ['yearly'] : [],
    'allPurchasedProductIdentifiers': isPro ? ['yearly'] : [],
    'nonSubscriptionTransactions': const [],
    'firstSeen': '2026-01-01T00:00:00Z',
    'originalAppUserId': 'test-user',
    'allExpirationDates': const <String, dynamic>{},
    'requestDate': '2026-05-01T00:00:00Z',
    'latestExpirationDate': null,
    'originalPurchaseDate': null,
    'originalApplicationVersion': null,
    'managementURL': null,
  });
}

Package packageFixture({String offeringId = 'default', Map<String, dynamic>? introPrice}) {
  return Package.fromJson({
    'identifier': r'$rc_annual',
    'packageType': 'ANNUAL',
    'presentedOfferingContext': {
      'offeringIdentifier': offeringId,
      'placementIdentifier': null,
      'targetingContext': null,
    },
    'product': {
      'identifier': 'yearly',
      'description': 'WeeksAlive Pro yearly',
      'title': 'WeeksAlive Pro',
      'price': 49.99,
      'priceString': r'$49.99',
      'currencyCode': 'USD',
      'introPrice': introPrice,
      'discounts': null,
      'productCategory': 'SUBSCRIPTION',
      'defaultOption': null,
      'subscriptionOptions': null,
      'presentedOfferingContext': null,
      'subscriptionPeriod': 'P1Y',
    },
  });
}

Offering offeringFixture({
  String id = 'default',
  int trialDays = 14,
  Map<String, dynamic>? introPrice,
  bool includeAnnual = true,
  bool includeTrialMetadata = true,
}) {
  final metadata = includeTrialMetadata ? {'trial_days': trialDays} : <String, Object>{};
  if (!includeAnnual) {
    return Offering(id, 'Standard offering', metadata, const []);
  }
  final package = packageFixture(offeringId: id, introPrice: introPrice);
  return Offering(
    id,
    'Standard offering',
    metadata,
    [package],
    annual: package,
  );
}

Map<String, dynamic> introPriceFixture({
  required String period,
  required String periodUnit,
  required int periodNumberOfUnits,
}) {
  return {
    'price': 0.0,
    'priceString': r'$0.00',
    'period': period,
    'cycles': 1,
    'periodUnit': periodUnit,
    'periodNumberOfUnits': periodNumberOfUnits,
  };
}

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
    'entitlements': {
      'all': entitlementJson,
      'active': entitlementJson,
      'verification': 'NOT_REQUESTED',
    },
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

Package packageFixture({
  String offeringId = 'default',
  String identifier = r'$rc_annual',
  String packageType = 'ANNUAL',
  String productId = 'yearly',
  double price = 49.99,
  String priceString = r'$49.99',
  String currencyCode = 'USD',
  String productCategory = 'SUBSCRIPTION',
  String subscriptionPeriod = 'P1Y',
  Map<String, dynamic>? introPrice,
}) {
  return Package.fromJson({
    'identifier': identifier,
    'packageType': packageType,
    'presentedOfferingContext': {
      'offeringIdentifier': offeringId,
      'placementIdentifier': null,
      'targetingContext': null,
    },
    'product': {
      'identifier': productId,
      'description': 'WeeksAlive Pro yearly',
      'title': 'WeeksAlive Pro',
      'price': price,
      'priceString': priceString,
      'currencyCode': currencyCode,
      'introPrice': introPrice,
      'discounts': null,
      'productCategory': productCategory,
      'defaultOption': null,
      'subscriptionOptions': null,
      'presentedOfferingContext': null,
      'subscriptionPeriod': subscriptionPeriod,
    },
  });
}

Offering offeringFixture({
  String id = 'default',
  String productId = 'yearly',
  int trialDays = 14,
  Map<String, dynamic>? introPrice,
  bool includeAnnual = true,
  bool includeTrialMetadata = true,
}) {
  final metadata = includeTrialMetadata
      ? {'trial_days': trialDays}
      : <String, Object>{};
  if (!includeAnnual) {
    return Offering(id, 'Standard offering', metadata, const []);
  }
  final package = packageFixture(
    offeringId: id,
    productId: productId,
    introPrice: introPrice,
  );
  return Offering(
    id,
    'Standard offering',
    metadata,
    [package],
    annual: package,
  );
}

Offering plansOfferingFixture() {
  final annual = packageFixture(offeringId: 'no_trial');
  final weekly = packageFixture(
    offeringId: 'no_trial',
    identifier: r'$rc_weekly',
    packageType: 'WEEKLY',
    productId: 'weekly',
    price: 3.99,
    priceString: r'$3.99',
    subscriptionPeriod: 'P1W',
  );
  final lifetime = packageFixture(
    offeringId: 'no_trial',
    identifier: r'$rc_lifetime',
    packageType: 'LIFETIME',
    productId: 'lifetime',
    price: 119.99,
    priceString: r'$119.99',
    productCategory: 'NON_SUBSCRIPTION',
  );
  return Offering(
    'no_trial',
    'Plans without trial',
    const {},
    [annual, weekly, lifetime],
    annual: annual,
    weekly: weekly,
    lifetime: lifetime,
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

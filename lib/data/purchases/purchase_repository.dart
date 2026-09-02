import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;

class PurchaseRepository {
  final DotEnv dotenv;

  PurchaseRepository({required this.dotenv});

  String get _entitlementId => dotenv.env['REVENUE_CAT_ENTITLEMENT_ID'] ?? 'WeeksAlive Pro';

  Future<Offering?> fetchCurrentOffering() async {
    final result = await fetchOfferings();
    return result.current;
  }

  Future<({Offering? current, Offering? alternate})> fetchOfferings() async {
    final offerings = await Purchases.getOfferings();
    final current = offerings.current;
    return (current: current, alternate: alternateOffering(offerings, current));
  }

  Offering? alternateOffering(Offerings offerings, Offering? current) {
    if (current == null || offerings.all.length < 2) return null;
    for (final offering in offerings.all.values) {
      if (offering.identifier != current.identifier) return offering;
    }
    return null;
  }

  Future<CustomerInfo> purchasePackage(Package package) async {
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }

  Future<CustomerInfo> restorePurchases() async {
    return Purchases.restorePurchases();
  }

  Future<CustomerInfo> getCustomerInfo() async {
    return Purchases.getCustomerInfo();
  }

  bool isPro(CustomerInfo customerInfo) {
    return customerInfo.entitlements.active.containsKey(_entitlementId);
  }
}

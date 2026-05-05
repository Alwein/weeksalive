import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;

class PurchaseRepository {
  final DotEnv dotenv;

  PurchaseRepository({required this.dotenv});

  String get _entitlementId => dotenv.env['REVENUE_CAT_ENTITLEMENT_ID'] ?? 'WeeksAlive Pro';

  Future<Offering?> fetchCurrentOffering() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e, st) {
      print('error: $e');
      print('stackTrace: $st');
      rethrow;
    }
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

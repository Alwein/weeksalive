import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:weeksalive/data/purchases/offering_trial.dart';
import 'package:weeksalive/data/purchases/purchase_offerings.dart';

class PurchaseRepository {
  /// Offering shown after the onboarding trial is declined. Annual, weekly
  /// and lifetime, with no free trial attached.
  static const plansOfferingId = 'no_trial';

  final DotEnv dotenv;

  PurchaseRepository({required this.dotenv});

  String get _entitlementId =>
      dotenv.env['REVENUE_CAT_ENTITLEMENT_ID'] ?? 'WeeksAlive Pro';

  Future<Offering?> fetchCurrentOffering() async {
    final result = await fetchOfferings();
    return result.current;
  }

  Future<PurchaseOfferings> fetchOfferings() async {
    final offerings = await Purchases.getOfferings();
    final current = offerings.current;
    return PurchaseOfferings(
      current: current,
      alternate: alternateOffering(offerings, current),
      plans: plansOffering(offerings),
    );
  }

  Offering? plansOffering(Offerings offerings) =>
      offerings.getOffering(plansOfferingId);

  /// Another trial length, offered as an alternate on the onboarding paywall.
  /// The plans offering also has an annual package, so it has to be excluded
  /// here or dismissing the trial would still be able to start one. Any other
  /// offering qualifies only if it has a trial, from its metadata or its
  /// store intro offer.
  Offering? alternateOffering(Offerings offerings, Offering? current) {
    if (current == null) return null;
    for (final offering in offerings.all.values) {
      if (offering.identifier == current.identifier) continue;
      if (offering.identifier == plansOfferingId) continue;
      if (offering.annual == null) continue;
      if (offering.trialDays == null) continue;
      return offering;
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

  /// Whether the entitlement is currently served by a free trial rather than a
  /// paid period. The store, not the offering metadata, is the authority here:
  /// a user who already burned the introductory offer is charged immediately
  /// and must not be reported to TikTok as a trial start.
  bool isInTrial(CustomerInfo customerInfo) {
    return customerInfo.entitlements.active[_entitlementId]?.periodType ==
        PeriodType.trial;
  }
}

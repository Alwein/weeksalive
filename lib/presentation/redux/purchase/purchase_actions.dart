import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:weeksalive/data/purchases/purchase_offerings.dart';

class FetchOfferingAction {
  const FetchOfferingAction();
}

class PurchasePackageAction {
  final Package package;
  const PurchasePackageAction(this.package);
}

class RestorePurchasesAction {
  const RestorePurchasesAction();
}

class OfferingLoadedAction {
  final PurchaseOfferings offerings;
  const OfferingLoadedAction(this.offerings);
}

/// The offerings could not be fetched. Whatever was loaded before is kept: it
/// is still sellable, and dropping it would leave the paywall empty.
class OfferingLoadFailedAction {
  const OfferingLoadFailedAction();
}

/// Offerings fetched by a background retry rather than a user-facing load.
/// They replace the offerings without ending whatever is in flight: a purchase
/// still loading must stay loading.
class OfferingRefreshedAction {
  final PurchaseOfferings offerings;
  const OfferingRefreshedAction(this.offerings);
}

class PurchaseSucceededAction {
  final bool isPro;

  /// Whether the entitlement is served by a free trial, as the store reports
  /// it after a purchase. Always false for a restore or a status refresh.
  final bool isTrial;

  const PurchaseSucceededAction({required this.isPro, this.isTrial = false});
}

class PurchaseErrorAction {
  final String message;

  /// Stable, non-localized cause, for analytics. The message is user-facing and
  /// translated, so it cannot be grouped on.
  final String errorCode;

  const PurchaseErrorAction(this.message, {this.errorCode = 'unknown'});
}

class ClearPurchaseErrorAction {
  const ClearPurchaseErrorAction();
}

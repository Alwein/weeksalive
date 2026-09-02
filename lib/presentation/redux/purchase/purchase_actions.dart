import 'package:purchases_flutter/purchases_flutter.dart';

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
  final Offering? offering;
  final Offering? alternateOffering;

  const OfferingLoadedAction(this.offering, {this.alternateOffering});
}

class PurchaseSucceededAction {
  final bool isPro;
  const PurchaseSucceededAction({required this.isPro});
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

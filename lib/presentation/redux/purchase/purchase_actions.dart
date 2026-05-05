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
  const OfferingLoadedAction(this.offering);
}

class PurchaseSucceededAction {
  final bool isPro;
  const PurchaseSucceededAction({required this.isPro});
}

class PurchaseErrorAction {
  final String message;
  const PurchaseErrorAction(this.message);
}

class ClearPurchaseErrorAction {
  const ClearPurchaseErrorAction();
}

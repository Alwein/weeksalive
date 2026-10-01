import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:weeksalive/data/purchases/offering_trial.dart';

part 'purchase_offerings.freezed.dart';

/// Everything the paywalls sell, fetched together so that state never mixes
/// offerings from two different fetches.
@freezed
abstract class PurchaseOfferings with _$PurchaseOfferings {
  const PurchaseOfferings._();

  const factory PurchaseOfferings({
    /// The onboarding offer, with a free trial.
    Offering? current,

    /// Another trial length, offered alongside [current].
    Offering? alternate,

    /// Annual, weekly and lifetime with no trial, sold by the in-app paywall.
    Offering? plans,
  }) = _PurchaseOfferings;

  static const none = PurchaseOfferings();

  /// Free-trial length [package] is sold with. The offering metadata only
  /// describes its annual package, so any other package falls back to the
  /// store.
  int? trialDaysOf(Package package) {
    final offeringId = package.presentedOfferingContext.offeringIdentifier;
    for (final offering in [current, alternate, plans]) {
      if (offering == null || offering.identifier != offeringId) continue;
      if (offering.annual == package) return offering.trialDays;
    }
    return package.storeProduct.trialDays;
  }
}

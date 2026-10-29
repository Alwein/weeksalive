import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;

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
}

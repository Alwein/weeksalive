import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:weeksalive/data/purchases/purchase_offerings.dart';

part 'purchase_state.freezed.dart';

@freezed
sealed class PurchaseState with _$PurchaseState {
  const factory PurchaseState.initial() = PurchaseStateInitial;

  const factory PurchaseState.loading({
    @Default(PurchaseOfferings.none) PurchaseOfferings offerings,
  }) = PurchaseStateLoading;

  const factory PurchaseState.success({
    @Default(PurchaseOfferings.none) PurchaseOfferings offerings,
    required bool isPro,
  }) = PurchaseStateSuccess;

  const factory PurchaseState.error({
    required String message,
    @Default(PurchaseOfferings.none) PurchaseOfferings offerings,
    required bool isPro,
  }) = PurchaseStateError;
}

extension PurchaseStateX on PurchaseState {
  bool get isPro => switch (this) {
    PurchaseStateSuccess(:final isPro) => isPro,
    PurchaseStateError(:final isPro) => isPro,
    _ => false,
  };

  PurchaseOfferings get offerings => switch (this) {
    PurchaseStateLoading(:final offerings) => offerings,
    PurchaseStateSuccess(:final offerings) => offerings,
    PurchaseStateError(:final offerings) => offerings,
    _ => PurchaseOfferings.none,
  };

  Offering? get offering => offerings.current;

  Offering? get alternateOffering => offerings.alternate;

  Offering? get plansOffering => offerings.plans;

  bool get isLoading => this is PurchaseStateLoading;

  bool get isResolved => switch (this) {
    PurchaseStateInitial() => false,
    PurchaseStateLoading() => false,
    _ => true,
  };
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchase_state.freezed.dart';

@freezed
sealed class PurchaseState with _$PurchaseState {
  const factory PurchaseState.initial() = PurchaseStateInitial;

  const factory PurchaseState.loading({
    Offering? offering,
    Offering? alternateOffering,
  }) = PurchaseStateLoading;

  const factory PurchaseState.success({
    required Offering? offering,
    Offering? alternateOffering,
    required bool isPro,
  }) = PurchaseStateSuccess;

  const factory PurchaseState.error({
    required String message,
    Offering? offering,
    Offering? alternateOffering,
    required bool isPro,
  }) = PurchaseStateError;
}

extension PurchaseStateX on PurchaseState {
  bool get isPro => switch (this) {
    PurchaseStateSuccess(:final isPro) => isPro,
    PurchaseStateError(:final isPro) => isPro,
    _ => false,
  };

  Offering? get offering => switch (this) {
    PurchaseStateLoading(:final offering) => offering,
    PurchaseStateSuccess(:final offering) => offering,
    PurchaseStateError(:final offering) => offering,
    _ => null,
  };

  Offering? get alternateOffering => switch (this) {
    PurchaseStateLoading(:final alternateOffering) => alternateOffering,
    PurchaseStateSuccess(:final alternateOffering) => alternateOffering,
    PurchaseStateError(:final alternateOffering) => alternateOffering,
    _ => null,
  };

  bool get isLoading => this is PurchaseStateLoading;

  bool get isResolved => switch (this) {
    PurchaseStateInitial() => false,
    PurchaseStateLoading() => false,
    _ => true,
  };
}

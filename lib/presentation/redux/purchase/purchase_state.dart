import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchase_state.freezed.dart';

@freezed
class PurchaseState with _$PurchaseState {
  const factory PurchaseState.initial() = PurchaseStateInitial;

  const factory PurchaseState.loading({Offering? offering}) = PurchaseStateLoading;

  const factory PurchaseState.success({
    required Offering? offering,
    required bool isPro,
  }) = PurchaseStateSuccess;

  const factory PurchaseState.error({
    required String message,
    Offering? offering,
    required bool isPro,
  }) = PurchaseStateError;
}

extension PurchaseStateX on PurchaseState {
  bool get isPro => maybeMap(
    success: (s) => s.isPro,
    error: (s) => s.isPro,
    orElse: () => false,
  );

  Offering? get offering => maybeMap(
    loading: (s) => s.offering,
    success: (s) => s.offering,
    error: (s) => s.offering,
    orElse: () => null,
  );

  bool get isLoading => maybeMap(loading: (_) => true, orElse: () => false);
}

import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

PurchaseState purchaseReducer(PurchaseState state, dynamic action) {
  if (action is FetchOfferingAction) {
    return PurchaseState.loading(
      offering: state.offering,
      alternateOffering: state.alternateOffering,
    );
  }

  if (action is PurchasePackageAction || action is RestorePurchasesAction) {
    return PurchaseState.loading(
      offering: state.offering,
      alternateOffering: state.alternateOffering,
    );
  }

  if (action is OfferingLoadedAction) {
    return PurchaseState.success(
      offering: action.offering,
      alternateOffering: action.alternateOffering,
      isPro: state.isPro,
    );
  }

  if (action is PurchaseSucceededAction) {
    return PurchaseState.success(
      offering: state.offering,
      alternateOffering: state.alternateOffering,
      isPro: action.isPro,
    );
  }

  if (action is PurchaseErrorAction) {
    return PurchaseState.error(
      message: action.message,
      offering: state.offering,
      alternateOffering: state.alternateOffering,
      isPro: state.isPro,
    );
  }

  if (action is ClearPurchaseErrorAction) {
    return PurchaseState.success(
      offering: state.offering,
      alternateOffering: state.alternateOffering,
      isPro: state.isPro,
    );
  }

  return state;
}

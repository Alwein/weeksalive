import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

PurchaseState purchaseReducer(PurchaseState state, dynamic action) {
  if (action is FetchOfferingAction) {
    return PurchaseState.loading(offering: state.offering);
  }

  if (action is PurchasePackageAction || action is RestorePurchasesAction) {
    return PurchaseState.loading(offering: state.offering);
  }

  if (action is OfferingLoadedAction) {
    return PurchaseState.idle(offering: action.offering, isPro: state.isPro);
  }

  if (action is PurchaseSucceededAction) {
    return PurchaseState.idle(offering: state.offering, isPro: action.isPro);
  }

  if (action is PurchaseErrorAction) {
    return PurchaseState.error(
      message: action.message,
      offering: state.offering,
      isPro: state.isPro,
    );
  }

  if (action is ClearPurchaseErrorAction) {
    return PurchaseState.idle(offering: state.offering, isPro: state.isPro);
  }

  return state;
}

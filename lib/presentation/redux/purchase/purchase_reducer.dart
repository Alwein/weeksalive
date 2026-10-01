import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

PurchaseState purchaseReducer(PurchaseState state, dynamic action) {
  if (action is FetchOfferingAction ||
      action is PurchasePackageAction ||
      action is RestorePurchasesAction) {
    return PurchaseState.loading(offerings: state.offerings);
  }

  if (action is OfferingLoadedAction) {
    return PurchaseState.success(
      offerings: action.offerings,
      isPro: state.isPro,
    );
  }

  if (action is OfferingLoadFailedAction) {
    return PurchaseState.success(
      offerings: state.offerings,
      isPro: state.isPro,
    );
  }

  if (action is PurchaseSucceededAction) {
    return PurchaseState.success(
      offerings: state.offerings,
      isPro: action.isPro,
    );
  }

  if (action is PurchaseErrorAction) {
    return PurchaseState.error(
      message: action.message,
      offerings: state.offerings,
      isPro: state.isPro,
    );
  }

  if (action is ClearPurchaseErrorAction) {
    return PurchaseState.success(
      offerings: state.offerings,
      isPro: state.isPro,
    );
  }

  return state;
}

import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:redux/redux.dart';
import 'package:weeksalive/core/utils/logger.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';

class PurchaseMiddleware extends MiddlewareClass<AppState> {
  final PurchaseRepository purchaseRepository;

  PurchaseMiddleware({required this.purchaseRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      await _loadOfferingAndStatus(store);
      return;
    }

    if (action is FetchOfferingAction) {
      await _loadOfferingAndStatus(store);
      return;
    }

    if (action is PurchasePackageAction) {
      await _handlePurchase(store, action.package);
      return;
    }

    if (action is RestorePurchasesAction) {
      await _handleRestore(store);
      return;
    }
  }

  Future<void> _loadOfferingAndStatus(Store<AppState> store) async {
    try {
      final results = await Future.wait([
        purchaseRepository.fetchCurrentOffering(),
        purchaseRepository.getCustomerInfo(),
      ]);
      final offering = results[0] as dynamic;
      final customerInfo = results[1] as CustomerInfo;
      store.dispatch(OfferingLoadedAction(offering));
      store.dispatch(PurchaseSucceededAction(isPro: purchaseRepository.isPro(customerInfo)));
    } catch (e, st) {
      log.e('PurchaseMiddleware: failed to load offering/status', error: e, stackTrace: st);
      store.dispatch(const OfferingLoadedAction(null));
    }
  }

  Future<void> _handlePurchase(Store<AppState> store, Package package) async {
    try {
      final customerInfo = await purchaseRepository.purchasePackage(package);
      store.dispatch(PurchaseSucceededAction(isPro: purchaseRepository.isPro(customerInfo)));
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return;
      store.dispatch(PurchaseErrorAction(e.toString()));
    } catch (e, st) {
      log.e('PurchaseMiddleware: purchase failed', error: e, stackTrace: st);
      store.dispatch(PurchaseErrorAction(e.toString()));
    }
  }

  Future<void> _handleRestore(Store<AppState> store) async {
    try {
      final customerInfo = await purchaseRepository.restorePurchases();
      store.dispatch(PurchaseSucceededAction(isPro: purchaseRepository.isPro(customerInfo)));
    } catch (e, st) {
      log.e('PurchaseMiddleware: restore failed', error: e, stackTrace: st);
      store.dispatch(PurchaseErrorAction(e.toString()));
    }
  }
}

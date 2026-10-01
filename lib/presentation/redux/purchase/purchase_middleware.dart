import 'dart:async';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:redux/redux.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/logger.dart';
import 'package:weeksalive/data/purchases/purchase_offerings.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/tiktok_events/tiktok_events_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

class PurchaseMiddleware extends MiddlewareClass<AppState> {
  final PurchaseRepository purchaseRepository;
  final TikTokEventsRepository tikTokEventsRepository;

  PurchaseMiddleware({
    required this.purchaseRepository,
    required this.tikTokEventsRepository,
  });

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

  /// Offerings and entitlement are fetched together but fail independently: a
  /// subscriber must not lose Pro because the offerings could not be loaded.
  Future<void> _loadOfferingAndStatus(Store<AppState> store) async {
    final (offerings, customerInfo) = await (
      _fetchOfferings(),
      _fetchCustomerInfo(),
    ).wait;
    store.dispatch(
      offerings == null
          ? const OfferingLoadFailedAction()
          : OfferingLoadedAction(offerings),
    );
    if (customerInfo != null) {
      store.dispatch(
        PurchaseSucceededAction(isPro: purchaseRepository.isPro(customerInfo)),
      );
    }
  }

  Future<PurchaseOfferings?> _fetchOfferings() async {
    try {
      return await purchaseRepository.fetchOfferings();
    } catch (e, st) {
      log.e(
        'PurchaseMiddleware: failed to load offerings',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<CustomerInfo?> _fetchCustomerInfo() async {
    try {
      return await purchaseRepository.getCustomerInfo();
    } catch (e, st) {
      log.e(
        'PurchaseMiddleware: failed to load purchase status',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<void> _handlePurchase(Store<AppState> store, Package package) async {
    try {
      final customerInfo = await purchaseRepository.purchasePackage(package);
      final isPro = purchaseRepository.isPro(customerInfo);
      final isTrial = isPro && purchaseRepository.isInTrial(customerInfo);
      if (isPro) {
        await _trackPurchaseForTikTok(
          package,
          isTrial: isTrial,
          trialDays: store.state.purchaseState.offerings.trialDaysOf(package),
        );
      }
      store.dispatch(PurchaseSucceededAction(isPro: isPro, isTrial: isTrial));
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        store.dispatch(
          PurchaseSucceededAction(isPro: store.state.purchaseState.isPro),
        );
        return;
      }
      store.dispatch(
        PurchaseErrorAction(_messageForPurchaseError(e), errorCode: e.name),
      );
    } on PlatformException catch (e) {
      if (_isCancelledPlatformException(e)) {
        store.dispatch(
          PurchaseSucceededAction(isPro: store.state.purchaseState.isPro),
        );
        return;
      }
      log.e('PurchaseMiddleware: purchase platform error', error: e);
      store.dispatch(
        PurchaseErrorAction(
          _messageForPlatformException(e),
          errorCode: _errorCodeForPlatformException(e),
        ),
      );
    } catch (e, st) {
      log.e('PurchaseMiddleware: purchase failed', error: e, stackTrace: st);
      store.dispatch(
        PurchaseErrorAction(Strings.paywallErrorGeneric, errorCode: 'unknown'),
      );
    }
  }

  Future<void> _handleRestore(Store<AppState> store) async {
    try {
      final customerInfo = await purchaseRepository.restorePurchases();
      store.dispatch(
        PurchaseSucceededAction(isPro: purchaseRepository.isPro(customerInfo)),
      );
    } on PurchasesErrorCode catch (e) {
      store.dispatch(
        PurchaseErrorAction(_messageForRestoreError(e), errorCode: e.name),
      );
    } on PlatformException catch (e) {
      log.e('PurchaseMiddleware: restore platform error', error: e);
      store.dispatch(
        PurchaseErrorAction(
          _messageForPlatformException(e),
          errorCode: _errorCodeForPlatformException(e),
        ),
      );
    } catch (e, st) {
      log.e('PurchaseMiddleware: restore failed', error: e, stackTrace: st);
      store.dispatch(
        PurchaseErrorAction(
          Strings.paywallErrorRestoreGeneric,
          errorCode: 'unknown',
        ),
      );
    }
  }

  /// A trial start and a paid purchase are different signals for TikTok, and
  /// reporting one as the other is what breaks App Event Optimization: sending
  /// Purchase the day a free trial opens declares revenue that has not happened
  /// and leaves the campaign with no StartTrial to bid on. The conversion that
  /// follows the trial happens outside the app, so only a server-side Events
  /// API call (RevenueCat webhook) can ever report it.
  Future<void> _trackPurchaseForTikTok(
    Package package, {
    required bool isTrial,
    required int? trialDays,
  }) async {
    if (!tikTokEventsRepository.isInitialized) return;

    try {
      final product = package.storeProduct;

      if (isTrial) {
        await tikTokEventsRepository.logStartTrial(
          value: product.price,
          currency: product.currencyCode,
          contentId: product.identifier,
          contentName: package.packageType.name,
          trialDays: trialDays,
        );
        return;
      }

      await tikTokEventsRepository.logPurchase(
        value: product.price,
        currency: product.currencyCode,
        contentId: product.identifier,
        contentName: package.packageType.name,
      );
      // Lifetime is a one-time purchase: reporting it as a subscription would
      // inflate Subscribe for any campaign optimizing on it.
      if (!_isSubscription(package)) return;
      await tikTokEventsRepository.logSubscribe(
        value: product.price,
        currency: product.currencyCode,
        contentId: product.identifier,
        contentName: package.packageType.name,
      );
    } catch (e, st) {
      log.e(
        'PurchaseMiddleware: failed to track TikTok purchase',
        error: e,
        stackTrace: st,
      );
    }
  }

  static bool _isSubscription(Package package) =>
      package.packageType != PackageType.lifetime &&
      package.storeProduct.productCategory != ProductCategory.nonSubscription;

  static bool _isCancelledPlatformException(PlatformException e) {
    final details = e.details;
    if (details is Map) {
      final userCancelled = details['userCancelled'];
      if (userCancelled == true) return true;
      final code =
          details['readableErrorCode'] ?? details['readable_error_code'];
      if (code == 'PURCHASE_CANCELLED') return true;
    }
    return false;
  }

  static String _messageForPurchaseError(PurchasesErrorCode code) {
    switch (code) {
      case PurchasesErrorCode.networkError:
        return Strings.paywallErrorNetwork;
      case PurchasesErrorCode.purchaseNotAllowedError:
        return Strings.paywallErrorNotAllowed;
      case PurchasesErrorCode.productAlreadyPurchasedError:
        return Strings.paywallErrorAlreadyOwned;
      default:
        return Strings.paywallErrorGeneric;
    }
  }

  static String _messageForRestoreError(PurchasesErrorCode code) {
    switch (code) {
      case PurchasesErrorCode.networkError:
        return Strings.paywallErrorNetwork;
      case PurchasesErrorCode.missingReceiptFileError:
        return Strings.paywallErrorRestoreNotFound;
      default:
        return Strings.paywallErrorRestoreGeneric;
    }
  }

  static String _errorCodeForPlatformException(PlatformException e) {
    final details = e.details;
    if (details is Map) {
      final code =
          details['readableErrorCode'] ?? details['readable_error_code'];
      if (code is String) return code;
    }
    return e.code;
  }

  static String _messageForPlatformException(PlatformException e) {
    final details = e.details;
    if (details is Map) {
      final code =
          details['readableErrorCode'] ?? details['readable_error_code'];
      if (code == 'NETWORK_ERROR') return Strings.paywallErrorNetwork;
      if (code == 'PURCHASE_NOT_ALLOWED') return Strings.paywallErrorNotAllowed;
    }
    return Strings.paywallErrorGeneric;
  }
}

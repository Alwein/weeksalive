import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

class PaywallViewModel {
  final Package? annualPackage;

  final int? trialWeeks;

  final String? pricePerYear;

  final String? pricePerWeek;

  final String? trialEndDate;

  final bool isLoading;
  final bool isPro;
  final String? errorMessage;
  final void Function(BuildContext, Package) onPurchase;
  final void Function(BuildContext) onRestore;

  const PaywallViewModel({
    required this.annualPackage,
    required this.trialWeeks,
    required this.pricePerYear,
    required this.pricePerWeek,
    required this.trialEndDate,
    required this.isLoading,
    required this.isPro,
    required this.errorMessage,
    required this.onPurchase,
    required this.onRestore,
  });

  static PaywallViewModel create(Store<AppState> store) {
    final ps = store.state.purchaseState;
    final offering = ps.offering;
    final annual = offering?.annual;

    final trialWeeks = _trialWeeksFromOffering(offering);
    final pricePerYear = annual?.storeProduct.priceString;
    final pricePerWeek = _weeklyPrice(annual);
    final trialEndDate = _formatTrialEndDate(trialWeeks);

    return PaywallViewModel(
      annualPackage: annual,
      trialWeeks: trialWeeks,
      pricePerYear: pricePerYear,
      pricePerWeek: pricePerWeek,
      trialEndDate: trialEndDate,
      isLoading: ps.isLoading,
      isPro: ps.isPro,
      errorMessage: ps.maybeMap(error: (e) => e.message, orElse: () => null),
      onPurchase: (context, pkg) => store.dispatch(PurchasePackageAction(pkg)),
      onRestore: (context) => store.dispatch(const RestorePurchasesAction()),
    );
  }

  static String? _formatTrialEndDate(int? trialWeeks) {
    if (trialWeeks == null) return null;
    final endDate = DateTime.now().add(Duration(days: trialWeeks * 7));
    return DateFormat('MMM d').format(endDate);
  }

  static int? _trialWeeksFromOffering(Offering? offering) {
    if (offering == null) return null;
    final raw = offering.metadata['trial_days'];
    final int? days;
    if (raw is int) {
      days = raw;
    } else if (raw is double) {
      days = raw.toInt();
    } else if (raw is String) {
      days = int.tryParse(raw);
    } else {
      days = null;
    }
    if (days == null) return null;
    return (days / 7).round().clamp(1, 99);
  }

  static String? _weeklyPrice(Package? annual) {
    if (annual == null) return null;
    final annualPrice = annual.storeProduct.price;
    final weeklyPrice = annualPrice / 52;
    final currencyCode = annual.storeProduct.currencyCode;
    final symbol = _currencySymbol(currencyCode);
    return '$symbol${weeklyPrice.toStringAsFixed(2)}';
  }

  static String _currencySymbol(String currencyCode) {
    const symbols = {'USD': r'$', 'EUR': '€', 'GBP': '£', 'JPY': '¥', 'CAD': r'CA$', 'AUD': r'A$'};
    return symbols[currencyCode] ?? '$currencyCode ';
  }
}

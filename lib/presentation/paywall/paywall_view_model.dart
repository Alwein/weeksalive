import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

class PaywallPlanData {
  final Package? annualPackage;
  final int? trialDays;
  final int? trialWeeks;
  final String? pricePerYear;
  final String? pricePerWeek;
  final String? trialEndDate;
  final String? offeringId;

  const PaywallPlanData({
    required this.annualPackage,
    required this.trialDays,
    required this.trialWeeks,
    required this.pricePerYear,
    required this.pricePerWeek,
    required this.trialEndDate,
    required this.offeringId,
  });

  static PaywallPlanData? fromOffering(Offering? offering) {
    if (offering == null) return null;
    final annual = offering.annual;
    final trialDays = PaywallViewModel.trialDaysFromOffering(offering);
    final trialWeeks = PaywallViewModel.trialWeeksFromOffering(offering);
    return PaywallPlanData(
      annualPackage: annual,
      trialDays: trialDays,
      trialWeeks: trialWeeks,
      pricePerYear: annual?.storeProduct.priceString,
      pricePerWeek: PaywallViewModel.weeklyPrice(annual),
      trialEndDate: PaywallViewModel.formatTrialEndDate(trialWeeks),
      offeringId: offering.identifier,
    );
  }
}

class PaywallViewModel {
  final PaywallPlanData? primaryPlan;
  final PaywallPlanData? alternatePlan;

  final bool isLoading;
  final bool isPro;
  final String? errorMessage;
  final void Function(BuildContext, Package) onPurchase;
  final void Function(BuildContext) onRestore;

  const PaywallViewModel({
    required this.primaryPlan,
    required this.alternatePlan,
    required this.isLoading,
    required this.isPro,
    required this.errorMessage,
    required this.onPurchase,
    required this.onRestore,
  });

  bool get hasAlternatePlan => alternatePlan?.annualPackage != null;

  static PaywallViewModel create(Store<AppState> store) {
    final ps = store.state.purchaseState;

    return PaywallViewModel(
      primaryPlan: PaywallPlanData.fromOffering(ps.offering),
      alternatePlan: PaywallPlanData.fromOffering(ps.alternateOffering),
      isLoading: ps.isLoading,
      isPro: ps.isPro,
      errorMessage: switch (ps) {
        PurchaseStateError(:final message) => message,
        _ => null,
      },
      onPurchase: (context, pkg) => store.dispatch(PurchasePackageAction(pkg)),
      onRestore: (context) => store.dispatch(const RestorePurchasesAction()),
    );
  }

  static String? formatTrialEndDate(int? trialWeeks) {
    if (trialWeeks == null) return null;
    final endDate = DateTime.now().add(Duration(days: trialWeeks * 7));
    return DateFormat('MMM d').format(endDate);
  }

  static int? trialWeeksFromOffering(Offering? offering) {
    if (offering == null) return null;
    final days = trialDaysFromOffering(offering);
    if (days == null) return null;
    return (days / 7).round().clamp(1, 99);
  }

  static int? trialDaysFromOffering(Offering? offering) {
    if (offering == null) return null;
    final raw = offering.metadata['trial_days'];
    if (raw is int) return raw;
    if (raw is double) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  static String? weeklyPrice(Package? annual) {
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

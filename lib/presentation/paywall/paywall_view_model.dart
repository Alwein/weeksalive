import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:redux/redux.dart';
import 'package:weeksalive/data/purchases/offering_trial.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

part 'paywall_view_model.freezed.dart';

enum PaywallPlanKind { annual, weekly, lifetime }

@freezed
abstract class PaywallPlanOption with _$PaywallPlanOption {
  const factory PaywallPlanOption({
    required PaywallPlanKind kind,
    required Package package,
    required String price,

    /// Weekly equivalent of an annual price, so the annual card can show the comparison.
    String? equivalentWeeklyPrice,

    /// Percent saved versus paying the weekly price for a year. Null when the
    /// weekly plan is missing or the annual plan is not cheaper.
    int? savingsPercent,
  }) = _PaywallPlanOption;
}

@freezed
abstract class PaywallPlanData with _$PaywallPlanData {
  const factory PaywallPlanData({
    required Package? annualPackage,
    required int? trialDays,
    required int? trialWeeks,
    required String? pricePerYear,
    required String? pricePerWeek,
    required String? trialEndDate,
    required String? offeringId,
  }) = _PaywallPlanData;

  static PaywallPlanData? fromOffering(Offering? offering) {
    if (offering == null) return null;
    final annual = offering.annual;
    final trialWeeks = PaywallViewModel.trialWeeksFromOffering(offering);
    return PaywallPlanData(
      annualPackage: annual,
      trialDays: offering.trialDays,
      trialWeeks: trialWeeks,
      pricePerYear: annual?.storeProduct.priceString,
      pricePerWeek: PaywallViewModel.weeklyPrice(annual),
      trialEndDate: PaywallViewModel.formatTrialEndDate(trialWeeks),
      offeringId: offering.identifier,
    );
  }
}

/// Data only, so that `distinct` can skip the rebuilds caused by unrelated
/// actions. The page dispatches purchases and restores itself.
@freezed
abstract class PaywallViewModel with _$PaywallViewModel {
  const PaywallViewModel._();

  const factory PaywallViewModel({
    required PaywallPlanData? primaryPlan,
    required PaywallPlanData? alternatePlan,
    required List<PaywallPlanOption> plans,
    required bool isLoading,
    required bool isPro,
    required String? errorMessage,
  }) = _PaywallViewModel;

  bool get hasAlternatePlan => alternatePlan?.annualPackage != null;

  factory PaywallViewModel.create(Store<AppState> store) {
    final ps = store.state.purchaseState;

    return PaywallViewModel(
      primaryPlan: PaywallPlanData.fromOffering(ps.offering),
      alternatePlan: PaywallPlanData.fromOffering(ps.alternateOffering),
      plans: plansFromOffering(ps.plansOffering),
      isLoading: ps.isLoading,
      isPro: ps.isPro,
      errorMessage: switch (ps) {
        PurchaseStateError(:final message) => message,
        _ => null,
      },
    );
  }

  static List<PaywallPlanOption> plansFromOffering(Offering? offering) {
    if (offering == null) return const [];
    final plans = <PaywallPlanOption>[];
    final annual = offering.annual;
    final weekly = offering.weekly;
    if (annual != null) {
      plans.add(
        PaywallPlanOption(
          kind: PaywallPlanKind.annual,
          package: annual,
          price: annual.storeProduct.priceString,
          equivalentWeeklyPrice: weeklyPrice(annual),
          savingsPercent: weekly == null
              ? null
              : savingsPercent(
                  annualPrice: annual.storeProduct.price,
                  weeklyPrice: weekly.storeProduct.price,
                ),
        ),
      );
    }
    if (weekly != null) {
      plans.add(
        PaywallPlanOption(
          kind: PaywallPlanKind.weekly,
          package: weekly,
          price: weekly.storeProduct.priceString,
        ),
      );
    }
    final lifetime = offering.lifetime;
    if (lifetime != null) {
      plans.add(
        PaywallPlanOption(
          kind: PaywallPlanKind.lifetime,
          package: lifetime,
          price: lifetime.storeProduct.priceString,
        ),
      );
    }
    return plans;
  }

  static String? formatTrialEndDate(int? trialWeeks) {
    if (trialWeeks == null) return null;
    final endDate = DateTime.now().add(Duration(days: trialWeeks * 7));
    return DateFormat('MMM d').format(endDate);
  }

  static int? trialWeeksFromOffering(Offering? offering) {
    final days = offering?.trialDays;
    if (days == null) return null;
    return (days / 7).round().clamp(1, 99);
  }

  /// Share of a year of weekly payments avoided by buying the annual plan.
  static int? savingsPercent({
    required double annualPrice,
    required double weeklyPrice,
  }) {
    if (annualPrice <= 0 || weeklyPrice <= 0) return null;
    final percent = ((1 - annualPrice / (weeklyPrice * 52)) * 100).round();
    if (percent <= 0) return null;
    return percent;
  }

  /// Annual price spread over 52 weeks, formatted for the device locale so it
  /// matches the store's own price string (separator, symbol position, and
  /// currencies without minor units such as JPY).
  static String? weeklyPrice(Package? annual, {String? locale}) {
    if (annual == null) return null;
    final product = annual.storeProduct;
    return _currencyFormat(
      product.currencyCode,
      locale ?? Platform.localeName,
    ).format(product.price / 52);
  }

  static NumberFormat _currencyFormat(String currencyCode, String locale) {
    try {
      return NumberFormat.simpleCurrency(locale: locale, name: currencyCode);
    } on ArgumentError {
      return NumberFormat.simpleCurrency(name: currencyCode);
    }
  }
}

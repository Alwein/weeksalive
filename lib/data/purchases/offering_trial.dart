import 'package:purchases_flutter/purchases_flutter.dart' hide Store;

extension OfferingTrialX on Offering {
  /// Free-trial length of the annual package, in days.
  ///
  /// The `trial_days` metadata wins over the store: StoreKit can report the
  /// same intro period for every offer of a subscription group, so the store
  /// is only a fallback.
  int? get trialDays =>
      trialDaysFromMetadata(metadata['trial_days']) ??
      annual?.storeProduct.trialDays;
}

extension StoreProductTrialX on StoreProduct {
  /// Length of the introductory offer, in days. Prefers the ISO period (`P2W`,
  /// `P1M`) over `periodUnit`, which StoreKit sometimes reports as month for
  /// every intro offer in the same subscription group.
  int? get trialDays {
    final intro = introductoryPrice;
    if (intro == null) return null;
    final fromIso = trialDaysFromIsoPeriod(intro.period);
    if (fromIso != null) return fromIso;
    if (intro.periodNumberOfUnits <= 0) return null;
    return switch (intro.periodUnit) {
      PeriodUnit.day => intro.periodNumberOfUnits,
      PeriodUnit.week => intro.periodNumberOfUnits * 7,
      PeriodUnit.month => intro.periodNumberOfUnits * 30,
      PeriodUnit.year => intro.periodNumberOfUnits * 365,
      PeriodUnit.unknown => null,
    };
  }
}

int? trialDaysFromMetadata(Object? raw) => switch (raw) {
  final int days => days,
  final double days => days.toInt(),
  final String days => int.tryParse(days),
  _ => null,
};

int? trialDaysFromIsoPeriod(String? period) {
  if (period == null || period.isEmpty) return null;
  final match = RegExp(
    r'^P(?:(\d+)D)?(?:(\d+)W)?(?:(\d+)M)?(?:(\d+)Y)?$',
  ).firstMatch(period);
  if (match == null) return null;
  final days = int.tryParse(match[1] ?? '') ?? 0;
  final weeks = int.tryParse(match[2] ?? '') ?? 0;
  final months = int.tryParse(match[3] ?? '') ?? 0;
  final years = int.tryParse(match[4] ?? '') ?? 0;
  final total = days + weeks * 7 + months * 30 + years * 365;
  return total > 0 ? total : null;
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;
import 'package:redux/redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/app_links.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

const _fallbackTrialDays = 14;
const _pricePerYear = r'$49.99';
const _pricePerWeek = r'$0.96';

// ─────────────────────────────────────────────────────────────────────────────
// Public entry-point
// ─────────────────────────────────────────────────────────────────────────────

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  static Route<bool> route() =>
      MaterialPageRoute<bool>(builder: (_) => const PaywallPage());

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      onInit: (store) => store.dispatch(const FetchOfferingAction()),
      distinct: true,
      builder: (context, vm) {
        final trialDays =
            _trialDaysFromOffering(vm.offering) ?? _fallbackTrialDays;
        final trialWeeks = (trialDays / 7).round().clamp(1, 99);

        return _PaywallView(
          trialWeeks: trialWeeks,
          isLoading: vm.isLoading,
          errorMessage: vm.errorMessage,
          onStartTrial: vm.annualPackage != null
              ? () => vm.onPurchase(context, vm.annualPackage!)
              : null,
          onRestore: () => vm.onRestore(context),
          onDismiss: () => Navigator.of(context).pop(false),
          isPro: vm.isPro,
        );
      },
    );
  }

  int? _trialDaysFromOffering(Offering? offering) {
    if (offering == null) return null;
    final raw = offering.metadata['trial_days'];
    if (raw is int) return raw;
    if (raw is double) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ViewModel
// ─────────────────────────────────────────────────────────────────────────────

class _ViewModel {
  final Offering? offering;
  final Package? annualPackage;
  final bool isLoading;
  final bool isPro;
  final String? errorMessage;
  final void Function(BuildContext, Package) onPurchase;
  final void Function(BuildContext) onRestore;

  const _ViewModel({
    required this.offering,
    required this.annualPackage,
    required this.isLoading,
    required this.isPro,
    required this.errorMessage,
    required this.onPurchase,
    required this.onRestore,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final ps = store.state.purchaseState;
    final offering = ps.offering;

    return _ViewModel(
      offering: offering,
      annualPackage: offering?.annual,
      isLoading: ps.isLoading,
      isPro: ps.isPro,
      errorMessage: ps.maybeMap(error: (e) => e.message, orElse: () => null),
      onPurchase: (context, pkg) {
        store.dispatch(PurchasePackageAction(pkg));
      },
      onRestore: (context) {
        store.dispatch(const RestorePurchasesAction());
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// View — reacts to isPro via StoreConnector rebuild
// ─────────────────────────────────────────────────────────────────────────────

class _PaywallView extends StatefulWidget {
  const _PaywallView({
    required this.trialWeeks,
    required this.isLoading,
    required this.isPro,
    required this.errorMessage,
    required this.onStartTrial,
    required this.onRestore,
    required this.onDismiss,
  });

  final int trialWeeks;
  final bool isLoading;
  final bool isPro;
  final String? errorMessage;
  final VoidCallback? onStartTrial;
  final VoidCallback onRestore;
  final VoidCallback onDismiss;

  @override
  State<_PaywallView> createState() => _PaywallViewState();
}

class _PaywallViewState extends State<_PaywallView> {
  @override
  void didUpdateWidget(_PaywallView old) {
    super.didUpdateWidget(old);
    // Once the purchase succeeds, close the paywall automatically.
    if (widget.isPro && !old.isPro) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: SafeArea(
        top: true,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Margins.spacingM),
                  Texts.xlBold('Try WeeksAlive free for ${widget.trialWeeks} weeks.'),
                  const SizedBox(height: Margins.spacingL),
                  _TrialTimeline(trialWeeks: widget.trialWeeks),
                  const SizedBox(height: 160),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(color: AppColors.bg(context)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SmallDivider(width: double.infinity),
                    const SizedBox(height: Margins.spacingBase),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Margins.spacingM),
                      child: Column(
                        children: [
                          if (widget.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Margins.spacingBase),
                              child: Text(
                                widget.errorMessage!,
                                style: TextStyles.primaryXsRegular
                                    .copyWith(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          _PriceBlock(
                            trialWeeks: widget.trialWeeks,
                            pricePerYear: _pricePerYear,
                            pricePerWeek: _pricePerWeek,
                          ),
                          const SizedBox(height: Margins.spacingBase),
                          _CtaButton(
                            trialWeeks: widget.trialWeeks,
                            isLoading: widget.isLoading,
                            onTap: widget.onStartTrial,
                          ),
                          const SizedBox(height: Margins.spacingBase),
                          _Footer(
                            onRestore: widget.onRestore,
                            onDismiss: widget.onDismiss,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Margins.spacingBase),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trial Timeline
// ─────────────────────────────────────────────────────────────────────────────

class _TrialTimeline extends StatelessWidget {
  const _TrialTimeline({required this.trialWeeks});
  final int trialWeeks;

  @override
  Widget build(BuildContext context) {
    final reminderWeek =
        trialWeeks <= 2 ? 'Week 1' : 'Week ${(trialWeeks / 2).ceil()}';
    final endDate = DateFormat('MMM d').format(
      DateTime.now().add(Duration(days: trialWeeks * 7)),
    );

    final steps = [
      const _TimelineItem(
        isActive: false,
        isDone: true,
        label: 'Download the app',
        sublabel: 'You chose to see your life differently.',
      ),
      const _TimelineItem(
        isActive: true,
        label: 'Today — Free trial starts',
        sublabel: 'Get full access. Start shaping your grid.',
      ),
      _TimelineItem(
        isActive: false,
        label: '$reminderWeek — Feel your first wins',
        sublabel:
            "Your first week is already on the grid. You'll remember this one.",
      ),
      _TimelineItem(
        isActive: false,
        label: 'Week $trialWeeks — End of trial period',
        sublabel:
            "Watch your grid growing. Cancel anytime before $endDate and you won't be charged.",
        isLast: true,
      ),
    ];

    return Column(children: steps.map((s) => _TimelineRow(item: s)).toList());
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.isActive,
    required this.label,
    required this.sublabel,
    this.isDone = false,
    this.isLast = false,
  });
  final bool isActive;
  final bool isDone;
  final String label;
  final String sublabel;
  final bool isLast;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item});
  final _TimelineItem item;

  static const double _dotSize = 20.0;
  static const double _lineWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final Color dotColor;
    final Widget dotWidget;

    if (item.isDone) {
      dotColor = AppColors.content(context);
      dotWidget = Container(
        width: _dotSize,
        height: _dotSize,
        decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
        child: const Icon(Icons.check, size: 16, color: Colors.white),
      );
    } else if (item.isActive) {
      dotColor = AppColors.highlightColor;
      dotWidget = Container(
        width: _dotSize,
        height: _dotSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.highlightColor,
        ),
      );
    } else {
      dotColor = AppColors.strokeColor(context);
      dotWidget = Container(
        width: _dotSize,
        height: _dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: dotColor, width: 1.5),
        ),
      );
    }

    final labelColor = item.isDone
        ? AppColors.contentSoft(context)
        : AppColors.content(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                const SizedBox(height: 3),
                dotWidget,
                if (!item.isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: _lineWidth,
                        color: AppColors.strokeColor(context),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Margins.spacingBase),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: item.isLast ? 0 : Margins.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyles.primaryMediumBlack.copyWith(
                      color: labelColor,
                      decoration:
                          item.isDone ? TextDecoration.lineThrough : null,
                      decorationColor: labelColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.sublabel,
                    style: TextStyles.primaryRegular
                        .copyWith(color: AppColors.contentSoft(context)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Price block
// ─────────────────────────────────────────────────────────────────────────────

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({
    required this.trialWeeks,
    required this.pricePerYear,
    required this.pricePerWeek,
  });
  final int trialWeeks;
  final String pricePerYear;
  final String pricePerWeek;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$trialWeeks weeks free, then $pricePerYear / year',
          style: TextStyles.primaryRegular
              .copyWith(color: AppColors.contentSoft(context)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacingXs),
        Text(
          'Only $pricePerWeek / week',
          style: TextStyles.primaryMediumBlack
              .copyWith(color: AppColors.content(context)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CTA button
// ─────────────────────────────────────────────────────────────────────────────

class _CtaButton extends StatelessWidget {
  const _CtaButton({
    required this.trialWeeks,
    required this.isLoading,
    required this.onTap,
  });
  final int trialWeeks;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !isLoading;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.content(context)
              : AppColors.contentSoft(context),
          borderRadius: BorderRadius.circular(200),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.bg(context),
                ),
              )
            : Text(
                'Start my $trialWeeks-week free trial',
                style: TextStyles.mediumBold
                    .copyWith(color: AppColors.bg(context)),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Footer
// ─────────────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({required this.onRestore, required this.onDismiss});
  final VoidCallback onRestore;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Cancel anytime. Billed via App Store.',
          style: TextStyles.primaryXsRegular
              .copyWith(color: AppColors.contentSoft(context)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacingXs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterLink(label: 'Terms', onTap: () => _open(AppLinks.terms)),
            _dot(context),
            _FooterLink(
                label: 'Privacy', onTap: () => _open(AppLinks.privacy)),
            _dot(context),
            _FooterLink(label: 'Restore', onTap: onRestore),
            _dot(context),
            _FooterLink(label: 'Skip', onTap: onDismiss),
          ],
        ),
      ],
    );
  }

  Widget _dot(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          '·',
          style: TextStyles.primaryXsRegular
              .copyWith(color: AppColors.contentSoftOnSoft(context)),
        ),
      );

  void _open(String url) {
    // Wire url_launcher here when ready.
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyles.primaryXsRegular.copyWith(
          color: AppColors.contentSoft(context),
          decoration: TextDecoration.underline,
          decorationColor: AppColors.contentSoft(context),
        ),
      ),
    );
  }
}

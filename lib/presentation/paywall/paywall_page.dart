import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/app_links.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/paywall/paywall_view_model.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

// TODO: Relire ce code AI swap
class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  static Route<bool> route() => MaterialPageRoute<bool>(builder: (_) => const PaywallPage());

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaywallViewModel>(
      converter: (store) => PaywallViewModel.create(store),
      onInit: (store) => store.dispatch(const FetchOfferingAction()),
      distinct: true,
      builder: (context, vm) {
        return _PaywallView(
          trialWeeks: vm.trialWeeks,
          trialEndDate: vm.trialEndDate,
          pricePerYear: vm.pricePerYear,
          pricePerWeek: vm.pricePerWeek,
          isLoading: vm.isLoading,
          errorMessage: vm.errorMessage,
          onStartTrial: vm.annualPackage != null ? () => vm.onPurchase(context, vm.annualPackage!) : null,
          onRestore: () => vm.onRestore(context),
          onDismiss: () => Navigator.of(context).pop(false),
          isPro: vm.isPro,
        );
      },
    );
  }
}

class _PaywallView extends StatefulWidget {
  const _PaywallView({
    required this.trialWeeks,
    required this.trialEndDate,
    required this.pricePerYear,
    required this.pricePerWeek,
    required this.isLoading,
    required this.isPro,
    required this.errorMessage,
    required this.onStartTrial,
    required this.onRestore,
    required this.onDismiss,
  });

  final int? trialWeeks;
  final String? trialEndDate;
  final String? pricePerYear;
  final String? pricePerWeek;
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
                  if (widget.trialWeeks != null) ...[
                    Texts.xlBold(Strings.paywallTitle(widget.trialWeeks!)),
                    const SizedBox(height: Margins.spacingL),
                    _TrialTimeline(trialWeeks: widget.trialWeeks!, trialEndDate: widget.trialEndDate),
                  ] else
                    const SizedBox(height: Margins.spacingL),
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
                      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
                      child: Column(
                        children: [
                          if (widget.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: Margins.spacingBase),
                              child: Text(
                                widget.errorMessage!,
                                style: TextStyles.primaryXsRegular.copyWith(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (widget.pricePerYear != null && widget.pricePerWeek != null && widget.trialWeeks != null)
                            _PriceBlock(
                              trialWeeks: widget.trialWeeks!,
                              pricePerYear: widget.pricePerYear!,
                              pricePerWeek: widget.pricePerWeek!,
                            )
                          else if (widget.isLoading)
                            const _PriceBlockSkeleton(),
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

class _TrialTimeline extends StatelessWidget {
  const _TrialTimeline({required this.trialWeeks, required this.trialEndDate});
  final int trialWeeks;
  final String? trialEndDate;

  @override
  Widget build(BuildContext context) {
    final reminderWeek = trialWeeks <= 2 ? 'Week 1' : 'Week ${(trialWeeks / 2).ceil()}';

    final steps = [
      _TimelineItem(
        isActive: false,
        isDone: true,
        label: Strings.paywallTimelineStep1Label,
        sublabel: Strings.paywallTimelineStep1Sublabel,
      ),
      _TimelineItem(
        isActive: true,
        label: Strings.paywallTimelineStep2Label,
        sublabel: Strings.paywallTimelineStep2Sublabel,
      ),
      _TimelineItem(
        isActive: false,
        label: Strings.paywallTimelineStep3Label(reminderWeek),
        sublabel: Strings.paywallTimelineStep3Sublabel,
      ),
      _TimelineItem(
        isActive: false,
        label: Strings.paywallTimelineStep4Label(trialWeeks),
        sublabel: trialEndDate != null
            ? Strings.paywallTimelineStep4Sublabel(trialEndDate!)
            : Strings.paywallTimelineStep3Sublabel,
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

    final labelColor = item.isDone ? AppColors.contentSoft(context) : AppColors.content(context);

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
              padding: EdgeInsets.only(bottom: item.isLast ? 0 : Margins.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyles.primaryMediumBlack.copyWith(
                      color: labelColor,
                      decoration: item.isDone ? TextDecoration.lineThrough : null,
                      decorationColor: labelColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.sublabel,
                    style: TextStyles.primaryRegular.copyWith(color: AppColors.contentSoft(context)),
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
          Strings.paywallPriceSubtitle(trialWeeks, pricePerYear),
          style: TextStyles.primaryRegular.copyWith(color: AppColors.contentSoft(context)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacingXs),
        Text(
          Strings.paywallPricePerWeek(pricePerWeek),
          style: TextStyles.primaryMediumBlack.copyWith(color: AppColors.content(context)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({
    required this.trialWeeks,
    required this.isLoading,
    required this.onTap,
  });
  final int? trialWeeks;
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
          color: enabled ? AppColors.content(context) : AppColors.contentSoft(context),
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
                trialWeeks != null ? Strings.paywallCtaWithWeeks(trialWeeks!) : Strings.paywallCtaWithTrial,
                style: TextStyles.mediumBold.copyWith(color: AppColors.bg(context)),
              ),
      ),
    );
  }
}

class _PriceBlockSkeleton extends StatelessWidget {
  const _PriceBlockSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = AppColors.strokeColor(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 14,
          width: 200,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(height: Margins.spacingXs),
        Container(
          height: 16,
          width: 120,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onRestore, required this.onDismiss});
  final VoidCallback onRestore;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Strings.paywallFooterDisclaimer,
          style: TextStyles.primaryXsRegular.copyWith(color: AppColors.contentSoft(context)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacingXs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterLink(label: Strings.paywallFooterTerms, onTap: () => _open(AppLinks.terms)),
            _dot(context),
            _FooterLink(label: Strings.paywallFooterPrivacy, onTap: () => _open(AppLinks.privacy)),
            _dot(context),
            _FooterLink(label: Strings.paywallFooterRestore, onTap: onRestore),
            _dot(context),
            _FooterLink(label: Strings.paywallFooterSkip, onTap: onDismiss),
          ],
        ),
      ],
    );
  }

  Widget _dot(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Text(
      '·',
      style: TextStyles.primaryXsRegular.copyWith(color: AppColors.contentSoftOnSoft(context)),
    ),
  );

  void _open(String url) {}
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

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/app_links.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/display_state.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/paywall/paywall_presentation.dart';
import 'package:weeksalive/presentation/paywall/paywall_view_model.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key, this.presentation = PaywallPresentation.onboarding});

  final PaywallPresentation presentation;

  static Route<bool> route({PaywallPresentation presentation = PaywallPresentation.onboarding}) {
    return MaterialPageRoute<bool>(
      builder: (_) => PaywallPage(presentation: presentation),
      fullscreenDialog: presentation == PaywallPresentation.inApp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaywallViewModel>(
      converter: (store) => PaywallViewModel.create(store),
      onInit: (store) => store.dispatch(const FetchOfferingAction()),
      distinct: true,
      builder: (context, vm) {
        return _PaywallView(
          presentation: presentation,
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
    required this.presentation,
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

  final PaywallPresentation presentation;
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

class _PaywallViewState extends State<_PaywallView> with SingleTickerProviderStateMixin {
  bool _showSuccess = false;
  late final AnimationController _successAnimController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _successAnimController = AnimationController(
      vsync: this,
      duration: AnimationDurations.long,
    );
    _fadeAnimation = CurvedAnimation(parent: _successAnimController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _successAnimController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_PaywallView old) {
    super.didUpdateWidget(old);

    if (widget.isPro && !old.isPro) {
      setState(() => _showSuccess = true);
      _successAnimController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = _showSuccess || widget.presentation.isDismissible;

    return PopScope(
      canPop: canPop,
      child: Scaffold(
        backgroundColor: AppColors.bg(context),
        body: SafeArea(
          top: true,
          child: _showSuccess
              ? _SuccessView(
                  fadeAnimation: _fadeAnimation,
                  onGetStarted: () => Navigator.of(context).pop(true),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: _TimelineOffer(
                              trialWeeks: widget.trialWeeks,
                              trialEndDate: widget.trialEndDate,
                            ),
                          ),
                        ),
                        _FooterSection(
                          errorMessage: widget.errorMessage,
                          pricePerYear: widget.pricePerYear,
                          pricePerWeek: widget.pricePerWeek,
                          trialWeeks: widget.trialWeeks,
                          isLoading: widget.isLoading,
                          onStartTrial: widget.onStartTrial,
                          onRestore: widget.onRestore,
                          onDismiss: widget.onDismiss,
                        ),
                      ],
                    ),
                    if (widget.presentation.isDismissible)
                      Positioned(
                        top: Margins.spacingXs,
                        right: Margins.spacingS,
                        child: IconButton(
                          onPressed: widget.onDismiss,
                          icon: Icon(
                            MingCuteIcons.mgc_close_line,
                            color: AppColors.contentSoft(context),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.fadeAnimation,
    required this.onGetStarted,
  });

  final Animation<double> fadeAnimation;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            _SuccessIcon(),
            const SizedBox(height: Margins.spacingL),
            Text(
              Strings.paywallSuccessTitle,
              style: TextStyles.xlBold.copyWith(color: AppColors.content(context)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Margins.spacingBase),
            Text(
              Strings.paywallSuccessSubtitle,
              style: TextStyles.primaryRegular.copyWith(
                color: AppColors.contentSoft(context),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            PrimaryButton.animated(
              text: Strings.paywallSuccessCta,
              onPressed: onGetStarted,
              displayState: DisplayState.success,
            ),
            const SizedBox(height: Margins.spacingL),
          ],
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Dimens.iconSizeHuge,
        height: Dimens.iconSizeHuge,
        decoration: BoxDecoration(
          color: AppColors.content(context),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_rounded,
          color: AppColors.contentMuted(context),
          size: Dimens.iconSizeM,
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection({
    required this.onRestore,
    required this.onDismiss,
    required this.errorMessage,
    required this.pricePerYear,
    required this.pricePerWeek,
    required this.trialWeeks,
    required this.isLoading,
    required this.onStartTrial,
  });

  final VoidCallback onRestore;
  final VoidCallback onDismiss;
  final String? errorMessage;
  final String? pricePerYear;
  final String? pricePerWeek;
  final int? trialWeeks;
  final bool isLoading;
  final VoidCallback? onStartTrial;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Margins.spacingBase),
                    child: Text(
                      errorMessage!,
                      style: TextStyles.primarySmallBold.copyWith(color: AppColors.redWarning(context)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (pricePerYear != null && pricePerWeek != null && trialWeeks != null)
                  _PriceBlock(
                    trialWeeks: trialWeeks!,
                    pricePerYear: pricePerYear!,
                    pricePerWeek: pricePerWeek!,
                  )
                else if (isLoading)
                  const _PriceBlockSkeleton(),
                const SizedBox(height: Margins.spacingBase),
                _CtaButton(
                  trialWeeks: trialWeeks,
                  isLoading: isLoading,
                  onTap: onStartTrial,
                ),
                const SizedBox(height: Margins.spacingBase),
                _Links(onRestore: onRestore),
              ],
            ),
          ),
          const SizedBox(height: Margins.spacingBase),
        ],
      ),
    );
  }
}

class _TimelineOffer extends StatelessWidget {
  const _TimelineOffer({
    required this.trialWeeks,
    required this.trialEndDate,
  });

  final int? trialWeeks;
  final String? trialEndDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Margins.spacingM),
          Texts.xlBold(Strings.paywallTitle(trialWeeks?.toString() ?? "-")),
          const SizedBox(height: Margins.spacingL),
          _TrialTimeline(trialWeeks: trialWeeks, trialEndDate: trialEndDate),
          const SizedBox(height: Margins.spacingBase),
          // TODO: work zone
          const Placeholder(
            fallbackHeight: 400,
          ),
        ],
      ),
    );
  }
}

class _TrialTimeline extends StatelessWidget {
  const _TrialTimeline({required this.trialWeeks, required this.trialEndDate});
  final int? trialWeeks;
  final String? trialEndDate;

  @override
  Widget build(BuildContext context) {
    final steps = [
      _TimelineItem(
        isActive: false,
        isDone: true,
        icon: MingCuteIcons.mgc_check_line,
        label: Strings.paywallTimelineStep1Label,
      ),
      _TimelineItem(
        isActive: true,
        icon: MingCuteIcons.mgc_unlock_line,
        label: Strings.paywallTimelineStep2Label,
        sublabel: Strings.paywallTimelineStep2Sublabel,
      ),
      _TimelineItem(
        isActive: false,
        icon: MingCuteIcons.mgc_notification_line,
        label: Strings.paywallTimelineStep3Label(trialWeeks != null ? trialWeeks! - 1 : 0),
        sublabel: Strings.paywallTimelineStep3Sublabel,
      ),
      _TimelineItem(
        isActive: false,
        icon: MingCuteIcons.mgc_checks_line,
        label: Strings.paywallTimelineStep4Label(trialWeeks?.toString() ?? "x"),
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
    required this.icon,
    required this.label,
    this.sublabel,
    this.isDone = false,
    this.isLast = false,
  });
  final bool isActive;
  final bool isDone;
  final IconData icon;
  final String label;
  final String? sublabel;
  final bool isLast;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item});
  final _TimelineItem item;

  @override
  Widget build(BuildContext context) {
    final Color dotColor;
    final Widget dotWidget;

    const double dotSize = Dimens.iconSizeM;
    const double lineWidth = Dimens.strokeWidthS;

    if (item.isDone) {
      dotColor = AppColors.content(context);
      dotWidget = Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
        child: Icon(item.icon, size: Dimens.iconSizeXs, color: AppColors.bg(context)),
      );
    } else if (item.isActive) {
      dotColor = AppColors.accentOrange(context);
      dotWidget = Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accentOrange(context),
        ),
        child: Icon(item.icon, size: Dimens.iconSizeXs, color: Colors.white),
      );
    } else {
      dotColor = AppColors.strokeColor(context);
      dotWidget = Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: dotColor,
            width: lineWidth,
          ),
        ),
        child: Icon(item.icon, size: Dimens.iconSizeXs, color: AppColors.contentSoft(context)),
      );
    }

    final labelColor = item.isDone ? AppColors.contentSoft(context) : AppColors.content(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Dimens.iconSizeM,
            child: Column(
              children: [
                dotWidget,
                if (!item.isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: lineWidth,
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
                  const SizedBox(height: Margins.spacingXs),
                  if (item.sublabel != null) ...[
                    Text(
                      item.sublabel!,
                      style: TextStyles.primaryRegular.copyWith(color: AppColors.contentSoft(context)),
                    ),
                  ],
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
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton.animated(
        text: trialWeeks != null ? Strings.paywallCtaWithWeeks(trialWeeks!) : Strings.paywallCtaWithTrial,
        onPressed: enabled ? onTap : null,
        displayState: isLoading ? DisplayState.loading : DisplayState.success,
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

class _Links extends StatelessWidget {
  const _Links({required this.onRestore});
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterLink(label: Strings.paywallFooterTerms, onTap: () => _open(AppLinks.terms)),
            _dot(context),
            _FooterLink(label: Strings.paywallFooterPrivacy, onTap: () => _open(AppLinks.privacy)),
            _dot(context),
            _FooterLink(label: Strings.paywallFooterRestore, onTap: onRestore),
          ],
        ),
      ],
    );
  }

  Widget _dot(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Text(
      '·',
      style: TextStyles.primarySmallRegular.copyWith(color: AppColors.contentSoftOnSoft(context)),
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
        style: TextStyles.primarySmallRegular.copyWith(
          color: AppColors.contentSoft(context),
          decoration: TextDecoration.underline,
          decorationColor: AppColors.contentSoft(context),
        ),
      ),
    );
  }
}

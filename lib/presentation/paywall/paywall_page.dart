import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:rive/rive.dart' hide Animation;
import 'package:rive_native/rive_native.dart' as rive_native;
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/app_links.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/display_state.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/onboarding/widgets/rive_theme_mixin.dart';
import 'package:weeksalive/presentation/paywall/paywall_presentation.dart';
import 'package:weeksalive/presentation/paywall/paywall_view_model.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

const double _paywallMascotArtboardSize = 120;
const double _paywallMascotVisibleHeight = 99.5;
const double _maxScrollAnimationExtent = 100;
const Duration _mascotIntroHiddenDelay = Duration(milliseconds: 600);
const Duration _mascotIntroReverseDuration = Duration(milliseconds: 600);

enum _MascotIntroPhase { hidden, reversing, scroll }

base class _PaywallScrubController extends RiveWidgetController {
  static const String _mainAnimName = 'main';

  late final rive_native.Animation? _mainAnim;

  _PaywallScrubController(super.file) {
    _mainAnim = artboard.animationNamed(_mainAnimName);
    scrubTo(1);
  }

  void scrubTo(double progress) {
    final anim = _mainAnim;
    if (anim == null) return;
    anim.time = progress.clamp(0.0, 1.0) * anim.duration;
    anim.apply();
    scheduleRepaint();
  }

  @override
  bool advance(double elapsedSeconds) {
    super.advance(elapsedSeconds);
    _mainAnim?.apply();
    return true;
  }
}

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
          isPro: vm.isPro, // TODO:
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

class _PaywallViewState extends State<_PaywallView> with TickerProviderStateMixin, RiveThemeMixin<_PaywallView> {
  bool _showSuccess = false;
  late final AnimationController _successAnimController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _mascotIntroController;
  late final Animation<double> _mascotIntroAnimation;
  late final ScrollController _scrollController;
  late final FileLoader _mascotFileLoader;
  _PaywallScrubController? _scrubController;
  _MascotIntroPhase _mascotIntroPhase = _MascotIntroPhase.hidden;

  @override
  void initState() {
    super.initState();
    _successAnimController = AnimationController(
      vsync: this,
      duration: AnimationDurations.long,
    );
    _fadeAnimation = CurvedAnimation(parent: _successAnimController, curve: Curves.easeOut);
    _mascotIntroController = AnimationController(
      vsync: this,
      duration: _mascotIntroReverseDuration,
    );
    _mascotIntroAnimation = CurvedAnimation(
      parent: _mascotIntroController,
      curve: Curves.ease,
    )..addListener(_onMascotIntroTick);
    _mascotIntroController.addStatusListener(_onMascotIntroStatus);
    _scrollController = ScrollController()..addListener(_onScroll);
    _mascotFileLoader = FileLoader.fromAsset(
      'assets/animations/outline_paywall.riv',
      riveFactory: Factory.flutter,
    );
    Future<void>.delayed(_mascotIntroHiddenDelay, _startMascotIntro);
  }

  void _startMascotIntro() {
    if (!mounted || _mascotIntroPhase != _MascotIntroPhase.hidden) return;
    setState(() => _mascotIntroPhase = _MascotIntroPhase.reversing);
    _mascotIntroController.forward(from: 0);
  }

  void _onMascotIntroTick() {
    if (_mascotIntroPhase != _MascotIntroPhase.reversing) return;
    _scrubController?.scrubTo(1 - _mascotIntroAnimation.value);
  }

  void _onMascotIntroStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _mascotIntroPhase != _MascotIntroPhase.reversing) return;
    setState(() => _mascotIntroPhase = _MascotIntroPhase.scroll);
    _onScroll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vmi?.color('fill')?.value = AppColors.bg(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _mascotFileLoader.dispose();
    _mascotIntroController.dispose();
    _successAnimController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_mascotIntroPhase != _MascotIntroPhase.scroll) return;
    const max = _maxScrollAnimationExtent;
    final progress = max > 0 ? (_scrollController.offset / max).clamp(0.0, 1.0) : 0.0;
    _scrubController?.scrubTo(progress);
  }

  void _onMascotLoaded(RiveLoaded state) {
    if (state.controller is _PaywallScrubController) {
      _scrubController = state.controller as _PaywallScrubController;
      if (_mascotIntroPhase == _MascotIntroPhase.scroll) {
        _onScroll();
      } else if (_mascotIntroPhase == _MascotIntroPhase.reversing) {
        _scrubController?.scrubTo(1 - _mascotIntroAnimation.value);
      } else {
        _scrubController?.scrubTo(1);
      }
    }
    onRiveLoaded(state.controller);
    vmi?.color('fill')?.value = AppColors.bg(context);
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
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: _TimelineOffer(
                                scrollController: _scrollController,
                                trialWeeks: widget.trialWeeks,
                                trialEndDate: widget.trialEndDate,
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
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
                            Positioned(
                              top: -_paywallMascotVisibleHeight,
                              left: 0,
                              right: 0,
                              height: _paywallMascotArtboardSize,
                              child: IgnorePointer(
                                child: Opacity(
                                  opacity: _mascotIntroPhase == _MascotIntroPhase.hidden ? 0 : 1,
                                  child: Center(
                                    child: SizedBox(
                                      width: _paywallMascotArtboardSize,
                                      height: _paywallMascotArtboardSize,
                                      child: RiveWidgetBuilder(
                                        fileLoader: _mascotFileLoader,
                                        controller: _PaywallScrubController.new,
                                        onLoaded: _onMascotLoaded,
                                        builder: (context, state) => switch (state) {
                                          RiveLoading() => const SizedBox.expand(),
                                          RiveFailed() => const SizedBox.shrink(),
                                          RiveLoaded(:final controller) => RiveWidget(
                                            controller: controller,
                                            fit: Fit.contain,
                                          ),
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    required this.scrollController,
    required this.trialWeeks,
    required this.trialEndDate,
  });

  final ScrollController scrollController;
  final int? trialWeeks;
  final String? trialEndDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Margins.spacingHuge),
          Texts.xlBold(Strings.paywallTitle(trialWeeks?.toString() ?? "-")),
          const SizedBox(height: Margins.spacingL),
          _TrialTimeline(trialWeeks: trialWeeks, trialEndDate: trialEndDate),
          const SizedBox(height: Margins.spacingXHuge),
          const _BenefitsSection(),
          const SizedBox(height: Margins.spacingL),
          const _SocialProofCarousel(),
          const SizedBox(height: Margins.spacingL),
          const SizedBox(
            height: 160,
            child: OverflowBox(
              maxHeight: 220,
              alignment: Alignment.bottomCenter,
              child: ParallaxRive(
                maxOffset: 0,
                assetPath: "assets/animations/outline_looking_up.riv",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection();

  static final _benefits = [
    Strings.paywallBenefit1,
    Strings.paywallBenefit2,
    Strings.paywallBenefit3,
    Strings.paywallBenefit4,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _benefits.length; i++) ...[
          if (i > 0) const SizedBox(height: Margins.spacingBase),
          _BenefitRow(label: _benefits[i]),
        ],
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          MingCuteIcons.mgc_check_line,
          size: Dimens.iconSizeXs,
          color: AppColors.contentSoft(context),
        ),
        const SizedBox(width: Margins.spacingS),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: TextStyles.primarySmallMedium.copyWith(color: AppColors.contentSoft(context)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialProofCarousel extends StatefulWidget {
  const _SocialProofCarousel();

  static final _reviews = [
    Strings.paywallReview1,
    Strings.paywallReview2,
    Strings.paywallReview3,
  ];

  @override
  State<_SocialProofCarousel> createState() => _SocialProofCarouselState();
}

class _SocialProofCarouselState extends State<_SocialProofCarousel> {
  static const _cardHeight = 132.0;

  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviews = _SocialProofCarousel._reviews;

    return Column(
      children: [
        SizedBox(
          height: _cardHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: reviews.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final isLast = index == reviews.length - 1;
              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : Margins.spacingS),
                child: _ReviewCard(quote: reviews[index]),
              );
            },
          ),
        ),
        const SizedBox(height: Margins.spacingS),
        _CarouselDots(count: reviews.length, currentIndex: _currentPage),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.quote});

  final String quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Margins.spacingBase),
      decoration: BoxDecoration(
        color: AppColors.bgSoft(context),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        border: Border.all(color: AppColors.strokeColor(context), width: Dimens.strokeWidthS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _ReviewStars(),
          const SizedBox(height: Margins.spacingS),
          Text(
            '"$quote"',
            style: TextStyles.primarySmallRegular.copyWith(
              color: AppColors.content(context),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewStars extends StatelessWidget {
  const _ReviewStars();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 5; i++) ...[
          if (i > 0) const SizedBox(width: Margins.spacingXs),
          const Icon(
            MingCuteIcons.mgc_star_fill,
            size: Dimens.iconSizeXs,
            color: Colors.orangeAccent,
          ),
        ],
      ],
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: Margins.spacingXs),
          AnimatedContainer(
            duration: AnimationDurations.base,
            curve: Curves.easeOut,
            width: i == currentIndex ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == currentIndex ? AppColors.content(context) : AppColors.strokeColor(context),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ],
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

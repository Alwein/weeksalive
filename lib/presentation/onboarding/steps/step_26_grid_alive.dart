import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/custom_tab_bar.dart';
import 'package:weeksalive/presentation/onboarding/widgets/year_grid_illustration.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/week_grid_painter.dart';

class Step26GridAlive extends OnboardingStep {
  const Step26GridAlive();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final bgColor = AppColors.bg(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.0, 0.88, 1.0],
              colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
            ).createShader(rect),
            blendMode: BlendMode.dstOut,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Texts.xlBold(Strings.onboarding19Title),
                  const SizedBox(height: Margins.spacingS),
                  Texts.primaryMediumSoft(context, Strings.onboarding19Subtitle),
                  const SizedBox(height: Margins.spacingM),
                  const _Content(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = CustomTabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final grid = controller.lifeWeekGrid;

    final now = DateTime.now();
    final int daysLived = dayOfYearIndex(now) + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
          child: CustomTabBar(
            controller: tabController,
            onTap: (index) => tabController.index = index,
            tabHeight: 42,
            tabs: [
              Tab(
                child: Text(Strings.homeGridTabYear, style: TextStyles.primaryRegularBold),
              ),
              Tab(
                child: Text(Strings.homeGridTabLife, style: TextStyles.primaryRegularBold),
              ),
            ],
          ),
        ),
        const SizedBox(height: Margins.spacingM),
        AnimatedBuilder(
          animation: tabController,
          builder: (context, _) {
            if (tabController.index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
                child: YearGridIllustration(
                  animationDurationMs: 1000,
                  header: Texts.primaryXsCounter(
                    context,
                    Strings.thisYearLabel,
                    DateTime.now().year.toString(),
                  ),
                  filledCount: daysLived,
                  wheightDistribution: const [0, 1, 2, 2, 3, 3, 4, 4, 4],
                ),
              );
            } else {
              return _LifeGridIllustration(
                totalWeeks: grid.totalWeeks,
                livedWeeks: grid.livedWeeks,
                progressFraction: grid.progressFraction,
              );
            }
          },
        ),
      ],
    );
  }
}

class _LifeGridIllustration extends StatefulWidget {
  const _LifeGridIllustration({
    required this.totalWeeks,
    required this.livedWeeks,
    required this.progressFraction,
  });

  final int totalWeeks;
  final int livedWeeks;
  final double progressFraction;

  @override
  State<_LifeGridIllustration> createState() => _LifeGridIllustrationState();
}

class _LifeGridIllustrationState extends State<_LifeGridIllustration> with SingleTickerProviderStateMixin {
  static const _kColumns = 52;
  static const _kDotSpacing = 2.0;
  static const _animationDurationMs = 1000;
  static const _kAnimationDuration = Duration(milliseconds: _animationDurationMs);

  static const _kGridPadding = EdgeInsets.only(
    left: Margins.spacingL,
    right: Margins.spacingL,
    top: Margins.spacingS,
  );

  late final AnimationController _controller;
  late final FlutterHaptic _haptic;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _kAnimationDuration)..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _haptic = FlutterHaptic.instance;
      _haptic.vibrate(
        intensity: 0.3,
        duration: _animationDurationMs,
      );
    });
  }

  @override
  void dispose() {
    _haptic.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.content(context);
    final inactiveColor = AppColors.bgSoft(context);
    final bgColor = AppColors.bg(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final exactHeight = WeekGridPainter.computeHeight(
          availableWidth: constraints.maxWidth,
          totalWeeks: widget.totalWeeks,
          columns: _kColumns,
          dotSpacing: _kDotSpacing,
          padding: _kGridPadding,
        );
        final needsScroll = exactHeight > constraints.maxHeight;

        final scrollContent = SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: Margins.spacingBase),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
                child: Row(
                  spacing: Margins.spacingBase,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Texts.primaryXsCounter(
                      context,
                      Strings.progressLabel,
                      '${(widget.progressFraction * 100).toStringAsFixed(1)}%',
                    ),
                    Texts.primaryXsCounter(
                      context,
                      Strings.weekLabel,
                      widget.livedWeeks.toString(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: exactHeight,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => CustomPaint(
                    painter: WeekGridPainter(
                      columns: _kColumns,
                      totalWeeks: widget.totalWeeks,
                      livedWeeks: widget.livedWeeks,
                      dotSpacing: _kDotSpacing,
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      padding: _kGridPadding,
                      revealProgress: _controller.value,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        if (!needsScroll) return scrollContent;

        return ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.0, 0.90, 1.0],
            colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
          ).createShader(rect),
          blendMode: BlendMode.dstOut,
          child: scrollContent,
        );
      },
    );
  }
}

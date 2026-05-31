import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/week_grid_painter.dart';

class Step11GridReveal extends OnboardingStep {
  const Step11GridReveal();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final name = controller.name ?? 'You';
    final grid = controller.lifeWeekGrid;

    return _Step11Content(
      name: name,
      totalWeeks: grid.totalWeeks,
      livedWeeks: grid.livedWeeks,
      progressFraction: grid.progressFraction,
    );
  }
}

class _Step11Content extends StatefulWidget {
  const _Step11Content({
    required this.name,
    required this.totalWeeks,
    required this.livedWeeks,
    required this.progressFraction,
  });

  final String name;
  final int totalWeeks;
  final int livedWeeks;
  final double progressFraction;

  @override
  State<_Step11Content> createState() => _Step11ContentState();
}

class _Step11ContentState extends State<_Step11Content> with SingleTickerProviderStateMixin {
  static const _loaderDuration = Duration(milliseconds: 2000);

  late final AnimationController _loaderController;
  late final Animation<double> _progressAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loaderController = AnimationController(vsync: this, duration: _loaderDuration);

    _progressAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.22).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.22, end: 0.71).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.71),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.71, end: 1.0).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 20,
      ),
    ]).animate(_loaderController);

    _loaderController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _isLoading = false);
      }
    });

    _loaderController.forward();
  }

  @override
  void dispose() {
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: _isLoading
          ? _GridLoader(key: const ValueKey('loader'), progressAnimation: _progressAnimation)
          : _GridContent(
              key: const ValueKey('grid'),
              name: widget.name,
              totalWeeks: widget.totalWeeks,
              livedWeeks: widget.livedWeeks,
              progressFraction: widget.progressFraction,
            ),
    );
  }
}

class _GridLoader extends StatelessWidget {
  const _GridLoader({super.key, required this.progressAnimation});

  final Animation<double> progressAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressAnimation,
      builder: (context, _) {
        final progress = progressAnimation.value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: _CircularProgress(percentage: progress),
              ),
              const SizedBox(height: Margins.spacingL),
              Texts.primaryMediumSoft(
                context,
                Strings.onboarding09LoadingLabel,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CircularProgress extends StatelessWidget {
  const _CircularProgress({required this.percentage});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CircularProgressIndicator(
          value: percentage,
          color: AppColors.content(context),
          backgroundColor: AppColors.bgSoft(context),
          strokeCap: StrokeCap.round,
          strokeWidth: 5,
        ),
        Center(
          child: Text(
            '${(percentage * 100).toInt()}%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.content(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _GridContent extends StatelessWidget {
  const _GridContent({
    super.key,
    required this.name,
    required this.totalWeeks,
    required this.livedWeeks,
    required this.progressFraction,
  });

  final String name;
  final int totalWeeks;
  final int livedWeeks;
  final double progressFraction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Texts.xlBold(Strings.onboarding09Title(name)),
          Expanded(
            child: Center(
              child: _GridIllustration(
                totalWeeks: totalWeeks,
                livedWeeks: livedWeeks,
                progressFraction: progressFraction,
              ),
            ),
          ),
          const SizedBox(height: Margins.spacingBase),
        ],
      ),
    );
  }
}

class _GridIllustration extends StatefulWidget {
  const _GridIllustration({
    required this.totalWeeks,
    required this.livedWeeks,
    required this.progressFraction,
  });
  final int totalWeeks;
  final int livedWeeks;
  final double progressFraction;

  @override
  State<_GridIllustration> createState() => _GridIllustrationState();
}

class _GridIllustrationState extends State<_GridIllustration> with SingleTickerProviderStateMixin {
  static const _kColumns = 52;
  static const _kDotSpacing = 2.0;
  static const _animationDurationMs = 3000;
  static const _kAnimationDuration = Duration(milliseconds: _animationDurationMs);

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

  static const _kGridPadding = EdgeInsets.only(
    left: Margins.spacingL,
    right: Margins.spacingL,
    top: Margins.spacingS,
  );

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

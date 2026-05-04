import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step21Widget extends OnboardingStep {
  const Step21Widget();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: Margins.spacingM),
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return _WidgetIllustration(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: Margins.spacingM),
          Texts.xlBold(Strings.onboarding21Title),
          const SizedBox(height: Margins.spacingM),
          const SmallDivider(),
          const SizedBox(height: Margins.spacingM),
          Texts.primaryMediumSoft(context, Strings.onboarding21Subtitle),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}

class _WidgetIllustration extends StatefulWidget {
  const _WidgetIllustration({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<_WidgetIllustration> createState() => _WidgetIllustrationState();
}

class _WidgetIllustrationState extends State<_WidgetIllustration> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _staggered(int index) {
    // 0ms, 100ms, 200ms start times for 3 icons (100ms delay between each).
    final start = (index * 200) / 1000;
    final end = (start + 0.6).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rise = widget.width * 0.40;

    Widget buildIcon({
      required int index,
      required String assetPath,
      required double finalRotation,
      required double height,
    }) {
      final anim = _staggered(index);
      final startRotation = finalRotation + (index.isEven ? -0.3 : 0.9);
      final rotation = Tween<double>(begin: startRotation, end: finalRotation).animate(anim);
      final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(anim);
      final dy = Tween<double>(begin: rise, end: 0.0).animate(anim);

      return AnimatedBuilder(
        animation: anim,
        builder: (context, _) {
          return Transform.translate(
            offset: Offset(0, dy.value),
            child: Transform.rotate(
              angle: rotation.value,
              child: Opacity(
                opacity: opacity.value.clamp(0.0, 1.0),
                child: Image.asset(
                  assetPath,
                  filterQuality: FilterQuality.high,
                  height: height,
                ),
              ),
            ),
          );
        },
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        buildIcon(
          index: 0,
          assetPath: 'assets/images/wallpaper.webp',
          finalRotation: 0,
          height: (widget.height / 470) * 470,
        ),
        buildIcon(
          index: 1,
          assetPath: 'assets/images/widget1.webp',
          finalRotation: -0.10,
          height: (widget.height / 470) * 211,
        ),
        buildIcon(
          index: 2,
          assetPath: 'assets/images/widget2.webp',
          finalRotation: 0.10,
          height: (widget.height / 470) * 211,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:weeksalive/core/styles/dimens.dart';

class OnboardingStaggeredColumn extends StatefulWidget {
  const OnboardingStaggeredColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.textBaseline,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.duration = AnimationDurations.long,
    this.delay = AnimationDurations.medium,
    this.verticalOffset = 20.0,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline? textBaseline;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Duration duration;
  final Duration delay;
  final double verticalOffset;

  @override
  State<OnboardingStaggeredColumn> createState() => _OnboardingStaggeredColumnState();
}

class _OnboardingStaggeredColumnState extends State<OnboardingStaggeredColumn> {
  bool started = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay).then((value) {
      setState(() {
        started = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (!started) {
      return IgnorePointer(
        child: Opacity(
          opacity: 0.0,
          child: _column(),
        ),
      );
    }

    if (disableAnimations) {
      return _column();
    }

    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        textBaseline: widget.textBaseline,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        children: AnimationConfiguration.toStaggeredList(
          duration: widget.duration,
          delay: widget.delay,
          childAnimationBuilder: (child) => SlideAnimation(
            verticalOffset: widget.verticalOffset,
            child: FadeInAnimation(child: child),
          ),
          children: widget.children,
        ),
      ),
    );
  }

  Widget _column() => Column(
    crossAxisAlignment: widget.crossAxisAlignment,
    mainAxisAlignment: widget.mainAxisAlignment,
    mainAxisSize: widget.mainAxisSize,
    textBaseline: widget.textBaseline,
    textDirection: widget.textDirection,
    verticalDirection: widget.verticalDirection,
    children: widget.children,
  );
}

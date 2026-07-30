import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_native/rive_native.dart' as rive_native;
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/rive_theme_mixin.dart';
import 'package:weeksalive/presentation/widgets/lifespan_slider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

base class _LifespanScrubController extends RiveWidgetController {
  static const String _scrollAnimName = 'scroll';
  static const String _idleAnimName = 'idle';
  static const String _rotateSkyAnimName = 'rotate_sky';
  static const int _totalFrames = 130;

  late final rive_native.Animation? _scrollAnim;
  late final rive_native.Animation? _idleAnim;
  late final rive_native.Animation? _rotateSkyAnim;

  int _lastFrame = 0;

  int _rotateDirection = 0;

  bool _skyActivated = false;

  _LifespanScrubController(super.file) {
    _scrollAnim = artboard.animationNamed(_scrollAnimName);
    _idleAnim = artboard.animationNamed(_idleAnimName);
    _rotateSkyAnim = artboard.animationNamed(_rotateSkyAnimName);
    _applyScrollFrame(0);
  }

  void scrubTo(int frame, {bool skipSky = false}) {
    final clamped = frame.clamp(0, _totalFrames);
    final newDir = clamped.compareTo(_lastFrame);
    _lastFrame = clamped;

    if (newDir != 0 && newDir != _rotateDirection && !skipSky) {
      _rotateDirection = newDir;
      _skyActivated = true;
      final sky = _rotateSkyAnim;
      if (sky != null) {
        sky.time = newDir > 0 ? 0 : sky.duration;
      }
    }

    _applyScrollFrame(clamped);
    scheduleRepaint();
  }

  void _applyScrollFrame(int frame) {
    final anim = _scrollAnim;
    if (anim == null) return;
    anim.time = frame * anim.duration / _totalFrames;
    anim.apply();
  }

  @override
  bool advance(double elapsedSeconds) {
    super.advance(elapsedSeconds);

    final idle = _idleAnim;
    if (idle != null) {
      if (!idle.advance(elapsedSeconds)) idle.time = 0;
      idle.apply();
    }

    final sky = _rotateSkyAnim;
    if (sky != null && _skyActivated) {
      if (_rotateDirection > 0) {
        if (!sky.advance(elapsedSeconds)) {
          sky.time = sky.duration;
          _rotateDirection = 0;
        }
      } else if (_rotateDirection < 0) {
        sky.time = (sky.time - elapsedSeconds).clamp(0.0, sky.duration);
        if (sky.time <= 0) {
          _rotateDirection = 0;
        }
      }

      sky.apply();
    }

    _scrollAnim?.apply();

    return true;
  }
}

class Step10Lifespan extends OnboardingStep {
  const Step10Lifespan();

  @override
  String primaryLabel(BuildContext context) => Strings.onboarding08ShowGrid;

  @override
  bool canContinue(OnboardingFormController controller) => true;

  @override
  Widget buildContent(BuildContext context) => const _Step10LifespanContent();
}

class _Step10LifespanContent extends StatefulWidget {
  const _Step10LifespanContent();

  @override
  State<_Step10LifespanContent> createState() => _Step10LifespanContentState();
}

class _Step10LifespanContentState extends State<_Step10LifespanContent> with RiveThemeMixin<_Step10LifespanContent> {
  late final FileLoader _fileLoader;
  _LifespanScrubController? _scrubController;

  @override
  void initState() {
    super.initState();
    _fileLoader = FileLoader.fromAsset(
      "assets/animations/outline_lifespan.riv",
      riveFactory: Factory.flutter,
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final initialLifespan = OnboardingScope.of(context).lifespan;
      _onSliderChanged(initialLifespan, skipSky: true);
    });
  }

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  void _onRiveLoaded(RiveLoaded state) {
    if (state.controller is _LifespanScrubController) {
      _scrubController = state.controller as _LifespanScrubController;
    }
    onRiveLoaded(state.controller);
  }

  void _onSliderChanged(int frame, {bool skipSky = false}) {
    _scrubController?.scrubTo(frame, skipSky: skipSky);
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingFormController controller = OnboardingScope.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: RiveWidgetBuilder(
                fileLoader: _fileLoader,
                controller: _LifespanScrubController.new,
                onLoaded: _onRiveLoaded,
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
          const SizedBox(height: Margins.spacingM),
          Center(
            child: SingleChildScrollView(
              child: OnboardingStaggeredColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Texts.onboardingXlBold(Strings.onboarding08Title),
                  const SizedBox(height: Margins.spacingM),
                  LifespanSlider(
                    value: controller.lifespan,
                    min: controller.currentAge,
                    label: Strings.onboarding08LifespanLabel,
                    onChanged: (v) {
                      controller.setLifespan(v);
                      _onSliderChanged(v);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryMediumSoft(
                        context,
                        Strings.onboarding08Subtitle,
                      ),
                      const SizedBox(height: Margins.spacingM),
                    ],
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

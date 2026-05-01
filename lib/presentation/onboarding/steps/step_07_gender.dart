import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step07Gender extends OnboardingStep {
  const Step07Gender();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  bool canContinue(OnboardingFormController controller) => controller.gender != null;

  @override
  Widget buildContent(BuildContext context) => const _Step07GenderContent();
}

class _Step07GenderContent extends StatefulWidget {
  const _Step07GenderContent();

  @override
  State<_Step07GenderContent> createState() => _Step07GenderContentState();
}

class _Step07GenderContentState extends State<_Step07GenderContent> {
  late final FileLoader _fileLoader;
  ViewModelInstance? _vmi;
  Brightness? _lastBrightness;

  @override
  void initState() {
    super.initState();
    _fileLoader = FileLoader.fromAsset(
      "assets/animations/outline_gender.riv",
      riveFactory: Factory.flutter,
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final initialGender = OnboardingScope.of(context).gender;
      _applyGender(initialGender);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (_lastBrightness != brightness) {
      _lastBrightness = brightness;
      _applyTheme(brightness);
    }
  }

  @override
  void dispose() {
    _vmi?.dispose();
    _fileLoader.dispose();
    super.dispose();
  }

  void _onRiveLoaded(RiveWidgetController riveController) {
    _vmi = riveController.dataBind(DataBind.auto());
    if (_lastBrightness != null) {
      _applyTheme(_lastBrightness!);
    }
  }

  void _applyTheme(Brightness brightness) {
    final vmi = _vmi;
    if (vmi == null) return;
    final isDark = brightness == Brightness.dark;
    final color = isDark ? AppColors.content(context) : AppColors.contentSoft(context);
    vmi.color('theme')?.value = color;
  }

  void _applyGender(Gender? gender) {
    final vmi = _vmi;
    if (vmi == null) return;

    final sexeVisible = vmi.boolean('scotchSexeVisible');
    final busteVisible = vmi.boolean('scotchBusteVisible');

    switch (gender) {
      case Gender.male:
        sexeVisible?.value = true;
        busteVisible?.value = false;
      case Gender.female:
        sexeVisible?.value = true;
        busteVisible?.value = true;
      default:
        sexeVisible?.value = false;
        busteVisible?.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);

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
                onLoaded: (state) => _onRiveLoaded(state.controller),
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
          Center(
            child: SingleChildScrollView(
              child: OnboardingStaggeredColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Texts.xlBold(Strings.onboarding07Title),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryMediumSoft(
                        context,
                        Strings.onboarding07Subtitle,
                      ),
                      const SizedBox(height: Margins.spacingM),
                      Row(
                        spacing: Margins.spacingBase,
                        children: [
                          for (final g in Gender.values)
                            Expanded(
                              child: _GenderChip(
                                label: g.titleCase,
                                selected: controller.gender == g,
                                onTap: () {
                                  controller.setGender(g);
                                  _applyGender(g);
                                },
                              ),
                            ),
                        ],
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

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? AppColors.content(context) : AppColors.strokeColor(context);
    final fgColor = selected ? AppColors.contentMuted(context) : AppColors.contentSoftOnSoft(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: Margins.spacingM),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Margins.spacingBase),
        ),
        alignment: Alignment.center,
        child: Texts.primaryMedium(
          label,
          color: fgColor,
        ),
      ),
    );
  }
}

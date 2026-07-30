import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/rive_theme_mixin.dart';
import 'package:weeksalive/presentation/widgets/gender_picker.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step09Gender extends OnboardingStep {
  const Step09Gender();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  bool canContinue(OnboardingFormController controller) => controller.gender != null;

  @override
  Widget buildContent(BuildContext context) => const _Step09GenderContent();
}

class _Step09GenderContent extends StatefulWidget {
  const _Step09GenderContent();

  @override
  State<_Step09GenderContent> createState() => _Step09GenderContentState();
}

class _Step09GenderContentState extends State<_Step09GenderContent> with RiveThemeMixin<_Step09GenderContent> {
  late final FileLoader _fileLoader;

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
  void dispose() {
    _fileLoader.dispose();
    super.dispose(); // calls RiveThemeMixin.dispose → _vmi?.dispose()
  }

  void _applyGender(Gender? gender) {
    final currentVmi = vmi;
    if (currentVmi == null) return;

    final sexeVisible = currentVmi.boolean('scotchSexeVisible');
    final busteVisible = currentVmi.boolean('scotchBusteVisible');

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
                onLoaded: (state) => onRiveLoaded(state.controller),
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
                  Texts.onboardingXlBold(Strings.onboarding07Title),
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
                      GenderPicker(
                        selectedGender: controller.gender,
                        onGenderSelected: (g) {
                          controller.setGender(g);
                          _applyGender(g);
                        },
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

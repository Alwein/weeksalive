import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:rive/rive.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/arched_name_input.dart';
import 'package:weeksalive/presentation/onboarding/widgets/rive_theme_mixin.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step06Name extends OnboardingStep {
  const Step06Name();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  bool canContinue(OnboardingFormController controller) => (controller.name ?? '').trim().isNotEmpty;

  @override
  Widget buildContent(BuildContext context) => const _Step06NameContent();
}

class _Step06NameContent extends StatefulWidget {
  const _Step06NameContent();

  @override
  State<_Step06NameContent> createState() => _Step06NameContentState();
}

class _Step06NameContentState extends State<_Step06NameContent> with RiveThemeMixin<_Step06NameContent> {
  final FocusNode _nameFocusNode = FocusNode();
  late final FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();
    _fileLoader = FileLoader.fromAsset(
      "assets/animations/outline_standing.riv",
      riveFactory: Factory.flutter,
    );
  }

  @override
  void dispose() {
    _nameFocusNode.unfocus();
    _nameFocusNode.dispose();
    _fileLoader.dispose();
    super.dispose();
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
          Texts.onboardingHugeBold(Strings.onboarding05Title),
          const SizedBox(height: Margins.spacingS),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const archedNameHeight = 0.0;
                final mascotSize = (constraints.maxHeight - archedNameHeight).clamp(
                  0.0,
                  constraints.maxWidth,
                );
                return Center(
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: mascotSize + archedNameHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: archedNameHeight + Margins.spacingBase,
                          child: SizedBox(
                            width: mascotSize,
                            height: mascotSize,
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
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: ArchedNameInput(
                            initialValue: controller.name,
                            autofocus: true,
                            color: AppColors.content(context),
                            focusNode: _nameFocusNode,
                            onChanged: controller.setName,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _nameFocusNode,
              builder: (context, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: _nameFocusNode.hasFocus
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: Margins.spacingM),
                          child: SecondaryButton(
                            text: Strings.editName,
                            onPressed: () => _nameFocusNode.requestFocus(),
                            icon: MingCuteIcons.mgc_pencil_line,
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

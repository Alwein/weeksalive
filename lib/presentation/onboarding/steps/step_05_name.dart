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
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step05Name extends OnboardingStep {
  const Step05Name();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  bool canContinue(OnboardingFormController controller) => (controller.name ?? '').trim().isNotEmpty;

  @override
  Widget buildContent(BuildContext context) => const _Step05NameContent();
}

class _Step05NameContent extends StatefulWidget {
  const _Step05NameContent();

  @override
  State<_Step05NameContent> createState() => _Step05NameContentState();
}

class _Step05NameContentState extends State<_Step05NameContent> {
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
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const archedNameHeight = 10.0;
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
                          top: archedNameHeight,
                          child: SizedBox(
                            width: mascotSize,
                            height: mascotSize,
                            child: RiveWidgetBuilder(
                              fileLoader: _fileLoader,
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
                        Positioned(
                          bottom: -Margins.spacingM,
                          left: 0,
                          right: 0,
                          child: Center(
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
                                      : SecondaryButton(
                                          text: Strings.edit,
                                          onPressed: () => _nameFocusNode.requestFocus(),
                                          icon: MingCuteIcons.mgc_pencil_line,
                                        ),
                                );
                              },
                            ),
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
            child: OnboardingStaggeredColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Texts.hugeBold(Strings.onboarding05Title),
                const SizedBox(height: Margins.spacingM),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

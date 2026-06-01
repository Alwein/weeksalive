import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uuid/uuid.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_steps.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_progress_bar.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
    this.steps = kOnboardingSteps,
  });

  final List<OnboardingStep> steps;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final OnboardingFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingFormController(totalSteps: widget.steps.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  Future<void> _handlePrimary(OnboardingStep step) async {
    _dismissKeyboard();
    final override = step.onPrimary;
    if (override != null) {
      await override(context, _controller);
      return;
    }

    if (_controller.isLast) {
      _submit();
      return;
    }

    await _controller.goNext();
  }

  void _submit() {
    final user = _controller.buildUser(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
    );
    if (user == null) return;

    StoreProvider.of<AppState>(context, listen: false).dispatch(
      SetUserAction(user),
    );

    StoreProvider.of<AppState>(
      context,
      listen: false,
    ).dispatch(SetWeeklyIntentSelectionAction(_controller.selectedIntentIds.toList()));
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScope(
      controller: _controller,
      onSubmit: _submit,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final step = widget.steps[_controller.currentIndex];

          return PopScope(
            canPop: _controller.isFirst,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop && !_controller.isFirst) {
                _dismissKeyboard();
                _controller.goPrevious();
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.bg(context),

              body: SafeArea(
                top: true,
                child: Column(
                  children: [
                    _OnboardingAppBar(
                      controller: _controller,
                      hideBack: _controller.isFirst,
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 520,
                        ),
                        child: PageView.builder(
                          controller: _controller.pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.steps.length,
                          onPageChanged: _controller.onPageChanged,
                          itemBuilder: (context, index) => widget.steps[index].buildContent(context),
                        ),
                      ),
                    ),
                    _Footer(
                      step: step,
                      controller: _controller,
                      onPrimary: () {
                        SensorialFeedback.navigationChanged();
                        _handlePrimary(step);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingAppBar extends StatelessWidget {
  const _OnboardingAppBar({required this.controller, required this.hideBack});

  final OnboardingFormController controller;
  final bool hideBack;

  @override
  Widget build(BuildContext context) {
    final bool hideBackButton = hideBack || controller.isFirst;
    return Padding(
      padding: EdgeInsets.only(
        left: hideBackButton ? Margins.spacingM : Margins.spacingS,
        right: Margins.spacingM,
        top: Margins.spacingS,
        bottom: Margins.spacingS,
      ),
      child: Row(
        children: [
          AnimatedCrossFade(
            duration: AnimationDurations.short,
            firstChild: const SizedBox(height: 48.0), // IconButton height is 48.0
            secondChild: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                FocusScope.of(context).unfocus();
                controller.goPrevious();
              },
            ),
            crossFadeState: hideBackButton ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            sizeCurve: Curves.easeOut,
          ),
          Expanded(
            child: OnboardingProgressBar(
              currentIndex: controller.currentIndex,
              totalSteps: controller.totalSteps,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.step,
    required this.controller,
    required this.onPrimary,
  });

  final OnboardingStep step;
  final OnboardingFormController controller;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    final canContinue = step.canContinue(controller);

    return Padding(
      padding: const EdgeInsets.only(
        left: Margins.spacingM,
        right: Margins.spacingM,
        bottom: Margins.spacingS,
        top: Margins.spacingS,
      ),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          text: step.primaryLabel(context),
          onPressed: canContinue ? onPrimary : null,
        ),
      ),
    );
  }
}

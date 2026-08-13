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
import 'package:weeksalive/presentation/redux/analytics/analytics_actions.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _dispatch(const OnboardingStartedAction());
      _trackStepViewed(0);
    });
  }

  void _dispatch(Object action) =>
      StoreProvider.of<AppState>(context, listen: false).dispatch(action);

  void _trackStepViewed(int index) {
    _dispatch(
      OnboardingStepViewedAction(stepIndex: index, stepName: widget.steps[index].analyticsName),
    );
  }

  void _onPageChanged(int index) {
    _controller.onPageChanged(index);
    _trackStepViewed(index);
  }

  void _goPrevious() {
    final index = _controller.currentIndex;
    _dispatch(
      OnboardingBackPressedAction(stepIndex: index, stepName: widget.steps[index].analyticsName),
    );
    _controller.goPrevious();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  Future<void> _handlePrimary(OnboardingStep step) async {
    _dismissKeyboard();
    _dispatch(
      OnboardingStepCompletedAction(
        stepIndex: _controller.currentIndex,
        stepName: step.analyticsName,
      ),
    );
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
    if (_controller.notificationTimes.isEmpty) return;

    final user = _controller.buildUser(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
    );
    if (user == null) return;

    final store = StoreProvider.of<AppState>(context, listen: false);
    store.dispatch(SetUserAction(user));
    store.dispatch(UpdateNotificationSettingsAction(_controller.slots));
    store.dispatch(SetWeeklyIntentSelectionAction(_controller.selectedIntentIds.toList()));
    store.dispatch(
      OnboardingProfileSubmittedAction(
        user: user,
        slots: _controller.slots,
        intentsCount: _controller.selectedIntentIds.length,
      ),
    );
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
                _goPrevious();
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
                      onBack: _goPrevious,
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
                          onPageChanged: _onPageChanged,
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
  const _OnboardingAppBar({
    required this.controller,
    required this.hideBack,
    required this.onBack,
  });

  final OnboardingFormController controller;
  final bool hideBack;
  final VoidCallback onBack;

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
              icon: Icon(Icons.arrow_back, color: AppColors.content(context)),
              onPressed: () {
                FocusScope.of(context).unfocus();
                onBack();
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

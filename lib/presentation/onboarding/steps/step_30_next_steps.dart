import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step30NextSteps extends OnboardingStep {
  const Step30NextSteps();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: Margins.spacingS),
              Texts.xlBold(Strings.onboarding24Title),
              const SizedBox(height: Margins.spacingM),
              const _Illustration(),
              const SizedBox(height: Margins.spacingM),
            ],
          ),
        ),
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
          child: LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxWidth / 2,
              child: const ParallaxRive(
                maxOffset: 0,
                assetPath: "assets/animations/outline_landed.riv",
              ),
            ),
          ),
        ),
        const _PlanCard(),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        border: Border.all(color: AppColors.strokeColor(context), width: Dimens.strokeWidthS),
      ),
      clipBehavior: Clip.hardEdge,
      child: const OnboardingStaggeredColumn(
        children: [
          _PlanHeader(),
          _TodaySection(),
          _Divider(),
          _ThisWeekSection(),
          _Divider(),
          _NextWeek(),
        ],
      ),
    );
  }
}

class _PlanHeader extends StatelessWidget {
  const _PlanHeader();

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Margins.spacingBase),
      color: AppColors.bgSoft(context),
      child: Texts.primaryLargeBold(Strings.onboarding24PlanHeader(controller.name ?? "")),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Margins.spacingBase),
      height: 1,
      width: double.infinity,
      color: AppColors.strokeColor(context),
    );
  }
}

class _TodaySection extends StatelessWidget {
  const _TodaySection();

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return _Section(
          index: "01",
          title: Strings.onboarding24TodaySection,
          description: Strings.onboarding24TodayDescription(_preferredNotificationTime(controller)),
        );
      },
    );
  }
}

class _ThisWeekSection extends StatelessWidget {
  const _ThisWeekSection();

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return StoreConnector<AppState, List<WeeklyIntent>>(
      converter: (store) => store.state.weeklyIntentState.availableIntents,
      builder: (context, intents) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final labels = _selectedIntentLabels(controller, intents);
            return _Section(
              index: "02",
              title: Strings.onboarding24ThisWeekSection,
              description: Strings.onboarding24ThisWeekDescription(labels),
            );
          },
        );
      },
    );
  }
}

class _NextWeek extends StatelessWidget {
  const _NextWeek();

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return _Section(
          index: "03",
          title: Strings.onboarding24NextWeekSection,
          description: Strings.onboarding24NextWeekDescription(_weekCloseWeekday(controller.weekStartDay)),
        );
      },
    );
  }
}

String _formatNotificationTime(TimeOfDay time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String _preferredNotificationTime(OnboardingFormController controller) {
  final times = controller.notificationTimes;
  if (times.isNotEmpty) return _formatNotificationTime(times.first);
  final fallback = controller.slot1.enabled ? controller.slot1.time : controller.slot2.time;
  return _formatNotificationTime(fallback);
}

List<String> _selectedIntentLabels(OnboardingFormController controller, List<WeeklyIntent> intents) {
  final labels = <String>[];
  for (final id in controller.selectedIntentIds) {
    for (final intent in intents) {
      if (intent.id == id) {
        labels.add(intent.label);
        break;
      }
    }
  }
  return labels;
}

String _weekCloseWeekday(int weekStartDay) => Strings.weekdayFullNames[(weekStartDay - 1).clamp(0, 6)];

class _Section extends StatelessWidget {
  const _Section({required this.index, required this.title, required this.description});
  final String index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Margins.spacingBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(index, style: TextStyles.primaryMediumBold.copyWith(color: AppColors.contentExtraSoft(context))),
              const SizedBox(width: Margins.spacingS),
              Expanded(
                child: Texts.primaryMediumBold(title),
              ),
            ],
          ),
          const SizedBox(height: Margins.spacingXs),
          Texts.primaryMediumSoft(context, description),
        ],
      ),
    );
  }
}

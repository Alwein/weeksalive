import 'package:flutter/widgets.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step28Rating extends OnboardingStep {
  const Step28Rating();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  bool canContinue(OnboardingFormController controller) => controller.ratingReady;

  @override
  Widget buildContent(BuildContext context) => const _Step28Content();
}

class _Step28Content extends StatefulWidget {
  const _Step28Content();

  @override
  State<_Step28Content> createState() => _Step28ContentState();
}

class _Step28ContentState extends State<_Step28Content> {
  static const _reviewDelay = Duration(milliseconds: 500);
  static const _continueDelay = Duration(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    OnboardingScope.read(context).setRatingReady(false);

    Future<void>.delayed(_reviewDelay, () async {
      if (!mounted) return;
      await InAppReview.instance.requestReview();
    });

    Future<void>.delayed(_continueDelay, () {
      if (!mounted) return;
      OnboardingScope.of(context).setRatingReady(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Center(
              child: ParallaxRive(
                maxOffset: 0,
                assetPath: "assets/animations/outline_favor.riv",
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
                  Texts.xlBold(Strings.onboarding22Title1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: Margins.spacingM),
                      const SmallDivider(),
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryMediumSoft(context, Strings.onboarding22Subtitle),
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

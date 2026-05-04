import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step23Attribution extends OnboardingStep {
  const Step23Attribution();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Future<void> Function(BuildContext, OnboardingFormController)? get onPrimary =>
      (context, controller) async {
        await AppTrackingTransparency.requestTrackingAuthorization();
        await controller.goNext();
      };

  @override
  Widget buildContent(BuildContext context) {
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
                  Texts.xlBold(Strings.onboarding23Title),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: Margins.spacingM),
                      const SmallDivider(),
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryMediumSoft(context, Strings.onboarding23Subtitle),
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

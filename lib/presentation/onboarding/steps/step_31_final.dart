import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step31Final extends OnboardingStep {
  const Step31Final();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Center(
        child: SingleChildScrollView(
          child: OnboardingStaggeredColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Texts.onboardingXlBold(Strings.onboarding25Title1),
              Texts.onboardingXlBold(Strings.onboarding25Title2),
              Text(
                Strings.onboarding25Title3,
                style: TextStyles.onboardingXlBold.copyWith(color: AppColors.contentSoftOnSoft(context)),
              ),
              Text(
                Strings.onboarding25Title4,
                style: TextStyles.onboardingXlBold.copyWith(color: AppColors.contentSoftOnSoft(context)),
              ),
              Texts.onboardingXlBoldSoft(context, Strings.onboarding25Title5),
              Texts.onboardingXlBoldSoft(context, Strings.onboarding25Title6),
              const SizedBox(height: Margins.spacingHuge),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Expanded(child: SmallDivider()),
                  const SizedBox(width: Margins.spacingM),
                  Texts.primaryMediumSoft(
                    context,
                    Strings.onboarding25Footer,
                  ),
                  const SizedBox(width: Margins.spacingM),
                  const Expanded(child: SmallDivider()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

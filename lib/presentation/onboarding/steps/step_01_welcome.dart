import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step01Welcome extends OnboardingStep {
  const Step01Welcome();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/weeksalive_logo.webp",
              width: 96,
              height: 96,
            ),
            const SizedBox(height: Margins.spacingXl),
            Texts.xlBold(Strings.appName),
            const SizedBox(height: Margins.spacingM),
            Texts.primaryMediumSoft(
              context,
              Strings.onboarding01Subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

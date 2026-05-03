import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/widgets/circle.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step14BestMemories extends OnboardingStep {
  const Step14BestMemories();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: SingleChildScrollView(
        child: OnboardingStaggeredColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Margins.spacingM,
          children: [
            Texts.xlBold(Strings.onboarding14Title),
            Texts.primaryMediumSoft(context, Strings.onboarding14Subtitle),
            const SmallDivider(),
            _BulletedLine(text: Strings.onboarding14Item1),
            const SmallDivider(),
            _BulletedLine(text: Strings.onboarding14Item2),
            const SmallDivider(),
            _BulletedLine(text: Strings.onboarding14Item3),
            const SmallDivider(),
            Texts.primaryMediumSoft(context, Strings.onboarding14Footer),
          ],
        ),
      ),
    );
  }
}

class _BulletedLine extends StatelessWidget {
  const _BulletedLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _circle(context),
        const SizedBox(width: Margins.spacingBase),
        Flexible(child: Texts.primaryMediumBold(text)),
      ],
    );
  }

  Widget _circle(BuildContext context) => Circle(
    size: 16,
    color: AppColors.content(context),
  );
}

import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step15WeeksThatStay extends OnboardingStep {
  const Step15WeeksThatStay();

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
            Texts.xlBold(Strings.onboarding15Title1),
            Texts.xlBoldSoft(context, Strings.onboarding15Title2),
            _Illustration(),
            const SmallDivider(),
            Texts.primaryMediumSoft(context, Strings.onboarding15Footer),
          ],
        ),
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Margins.spacingM),
        Row(
          spacing: Margins.spacingBase,
          children: [
            Expanded(
              child: _Card(
                title: Strings.onboarding15Caption1,
                value1: Strings.onboarding15Caption1Value1,
                value2: Strings.onboarding15Caption1Value2,
                value3: Strings.onboarding15Caption1Value3,
                foregroundColor: AppColors.contentMuted(context),
                backgroundColor: AppColors.content(context),
              ),
            ),
            Expanded(
              child: _Card(
                title: Strings.onboarding15Caption2,
                value1: Strings.onboarding15Caption2Value1,
                value2: Strings.onboarding15Caption2Value2,
                value3: Strings.onboarding15Caption2Value3,
                foregroundColor: AppColors.contentSoftOnSoft(context),
                backgroundColor: AppColors.bgSoft(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: Margins.spacingBase),
        const _GradientIllustration(),
        const SizedBox(height: Margins.spacingM),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.foregroundColor,
    required this.backgroundColor,
  });
  final String title;
  final String value1;
  final String value2;
  final String value3;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM, vertical: Margins.spacingL),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(Dimens.radiusL),
          ),
          child: Column(
            spacing: Margins.spacingBase,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.primaryRegular.copyWith(color: foregroundColor)),
              Text("•  $value1", style: TextStyles.primaryMediumMedium.copyWith(color: foregroundColor)),
              Text("•  $value2", style: TextStyles.primaryMediumMedium.copyWith(color: foregroundColor)),
              Text("•  $value3", style: TextStyles.primaryMediumMedium.copyWith(color: foregroundColor)),
            ],
          ),
        ),
      ],
    );
  }
}

class _GradientIllustration extends StatelessWidget {
  const _GradientIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(360),
        gradient: LinearGradient(
          colors: [
            AppColors.content(context),
            AppColors.bgSoft(context),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circle(AppColors.content(context)),
          _circle(AppColors.bgSoft(context)),
        ],
      ),
    );
  }

  Widget _circle(Color color) => Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(360),
    ),
  );
}

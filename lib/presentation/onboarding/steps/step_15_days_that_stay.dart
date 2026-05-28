import 'package:flutter/material.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: OnboardingStaggeredColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: Margins.spacingM,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Texts.xlBold(Strings.onboarding15Title1),
                    Texts.xlBoldSoft(context, Strings.onboarding15Title2),
                  ],
                ),
                _Illustration(),
                const SmallDivider(),
                Texts.primaryMediumSoft(context, Strings.onboarding15Footer),
              ],
            ),
          ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
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
              flex: 1,
              child: _Card(
                title: Strings.onboarding15Caption2,
                value1: Strings.onboarding15Caption2Value1,
                value2: Strings.onboarding15Caption2Value2,
                value3: Strings.onboarding15Caption2Value3,
                small: true,
                foregroundColor: AppColors.contentSoftOnSoft(context),
                backgroundColor: AppColors.bgSoft(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: Margins.spacingM),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.title,
    required this.value1,
    required this.value2,
    required this.value3,
    this.small = false,
  });
  final String title;
  final String value1;
  final String value2;
  final String value3;
  final bool small;
  final Color foregroundColor;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    final hPadding = small ? Margins.spacingBase : Margins.spacingM;
    final vPadding = small ? Margins.spacingM : Margins.spacingL;
    final titleStyle = small ? TextStyles.primarySmallRegular : TextStyles.primaryRegularBold;
    final valueStyle = small ? TextStyles.primarySmallMedium : TextStyles.primaryLargeBold;
    return AspectRatio(
      aspectRatio: 9 / 12,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Dimens.radiusL),
        ),
        child: Column(
          spacing: small ? Margins.spacingXs : Margins.spacingBase,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: titleStyle.copyWith(color: foregroundColor)),
            Text("•  $value1", style: valueStyle.copyWith(color: foregroundColor)),
            Text("•  $value2", style: valueStyle.copyWith(color: foregroundColor)),
            Text("•  $value3", style: valueStyle.copyWith(color: foregroundColor)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/circle.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step18OneMinute extends OnboardingStep {
  const Step18OneMinute();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: Margins.spacingS),
            Texts.xlBold(Strings.onboarding18Title),
            const SizedBox(height: Margins.spacingS),
            Texts.primaryMediumSoft(context, Strings.onboarding18Subtitle),
            const SizedBox(height: Margins.spacingM),
            const Expanded(child: _Illustration()),
            const SizedBox(height: Margins.spacingM),
          ],
        ),
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Margins.spacingL),
          child: AspectRatio(
            aspectRatio: 2,
            child: ParallaxRive(
              maxOffset: 0,
              assetPath: "assets/animations/outline_landed.riv",
            ),
          ),
        ),
        _WeekCard(),
      ],
    );
  }
}

class _WeekCard extends StatelessWidget {
  const _WeekCard();

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
          _WeekHeader(),
          _FeelingSection(),
          _Divider(),
          _MeaningSection(),
          _Divider(),
          _NewExperienceSection(),
          _Divider(),
          _LivingIntentionsSection(),
        ],
      ),
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader();

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return Container(
      padding: const EdgeInsets.all(Margins.spacingBase),
      color: AppColors.bgSoft(context),
      child: Row(
        children: [
          Circle(size: 24, color: AppColors.content(context)),
          const SizedBox(width: Margins.spacingBase),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Texts.primaryMediumCounter(
                      context,
                      Strings.dayLabel,
                      controller.totalDaysLived.toString(),
                      softColor: AppColors.contentSoftOnSoft(context),
                    ),
                    Texts.primaryMediumCounter(
                      context,
                      Strings.archivedLabel,
                      null,
                      softColor: AppColors.contentSoftOnSoft(context),
                    ),
                  ],
                ),
                const SizedBox(height: Margins.spacingS),
                Texts.primaryLargeBold(TimeUtils.formatDate(context, DateTime.now())),
              ],
            ),
          ),
        ],
      ),
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

class _FeelingSection extends StatelessWidget {
  const _FeelingSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      index: "01",
      title: Strings.feelingSectionTitle,
      value: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(MingCuteIcons.mgc_emoji_line, size: Dimens.iconSizeBase, color: AppColors.content(context)),
          const SizedBox(width: Margins.spacingS),
          Texts.primaryXsBold(Strings.feelingSectionValueGood),
        ],
      ),
    );
  }
}

class _MeaningSection extends StatelessWidget {
  const _MeaningSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      index: "02",
      title: Strings.meaningSectionTitle,
      value: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            spacing: 2,
            children: [
              Circle(size: 4, color: AppColors.content(context)),
              Circle(size: 4, color: AppColors.content(context)),
              Circle(size: 4, color: AppColors.content(context)),
              Circle(size: 4, color: AppColors.content(context)),
              Circle(size: 4, color: AppColors.contentSoft(context)),
            ],
          ),
          const SizedBox(width: Margins.spacingS),
          Texts.primaryXsBold(Strings.feelingSectionValueGood),
        ],
      ),
    );
  }
}

class _NewExperienceSection extends StatelessWidget {
  const _NewExperienceSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      index: "03",
      title: Strings.newExperienceSectionTitle,
      value: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Texts.primaryXsBold(Strings.newExperienceSectionValueYes),
        ],
      ),
    );
  }
}

class _LivingIntentionsSection extends StatelessWidget {
  const _LivingIntentionsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      index: "04",
      title: Strings.livingIntentionsSectionTitle,
      value: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Texts.primaryXsBold(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              "${Strings.livingIntentionsSectionValueExplore}, ${Strings.livingIntentionsSectionValueConnect}, ${Strings.livingIntentionsSectionValueBePresent}",
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.index, required this.title, required this.value});
  final String index;
  final String title;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Margins.spacingBase),
      child: Row(
        children: [
          Text(index, style: TextStyles.primaryRegularBold.copyWith(color: AppColors.contentSoft(context))),
          const SizedBox(width: Margins.spacingS),
          Text(title, style: TextStyles.primaryRegularMedium.copyWith(color: AppColors.contentSoftOnSoft(context))),
          const SizedBox(width: Margins.spacingM),
          Expanded(child: value),
        ],
      ),
    );
  }
}

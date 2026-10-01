import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/rewards/reward_condition.dart';
import 'package:weeksalive/domain/rewards/reward_display.dart';
import 'package:weeksalive/domain/rewards/reward_rule.dart';
import 'package:weeksalive/domain/rewards/reward_rules.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/paywall/show_in_app_paywall.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';
import 'package:weeksalive/presentation/streak/widgets/reward_preview.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

part 'streaks_page.freezed.dart';

@freezed
abstract class StreaksPageViewModel with _$StreaksPageViewModel {
  const StreaksPageViewModel._();

  const factory StreaksPageViewModel({
    required int currentStreak,
    required int bestStreak,
    required bool isPro,
    required List<StreakRewardItem> rewards,
  }) = _StreaksPageViewModel;

  /// A free user who has not earned every reward can still get them all at
  /// once with Pro.
  bool get canUnlockAllWithPro =>
      !isPro && rewards.any((item) => !item.isAvailable);

  factory StreaksPageViewModel.create(Store<AppState> store) {
    final streak = store.state.streakState;
    final earned = store.state.rewardsState.unlocked;
    final isPro = store.state.purchaseState.isPro;

    final rules = RewardRules.streakMilestonesSorted;

    final firstLockedIndex = rules.indexWhere(
      (rule) => !earned.contains(rule.id),
    );

    final rewards = [
      for (var i = 0; i < rules.length; i++)
        StreakRewardItem(
          rule: rules[i],
          isReached: earned.contains(rules[i].id),
          isAvailable: isPro || earned.contains(rules[i].id),
          isActive: i == firstLockedIndex,
          isLast: i == rules.length - 1,
        ),
    ];

    return StreaksPageViewModel(
      currentStreak: streak.count,
      bestStreak: streak.bestEver,
      isPro: isPro,
      rewards: rewards,
    );
  }
}

@freezed
abstract class StreakRewardItem with _$StreakRewardItem {
  const StreakRewardItem._();

  const factory StreakRewardItem({
    required RewardRule rule,

    /// The streak has reached this milestone, so the reward is earned for
    /// good, Pro or not.
    required bool isReached,

    /// The reward can be used now: earned, or included in Pro.
    required bool isAvailable,

    /// The next milestone the streak is heading for.
    required bool isActive,
    required bool isLast,
  }) = _StreakRewardItem;

  int get minDays => (rule.condition as StreakMilestoneCondition).minDays;
}

class StreaksPage extends StatelessWidget {
  const StreaksPage({super.key});

  static Route<void> route() => MaterialPageRoute<void>(builder: (_) => const StreaksPage());

  static Future<void> show(BuildContext context) => Navigator.of(context).push(route());

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StreaksPageViewModel>(
      converter: StreaksPageViewModel.create,
      distinct: true,
      builder: (context, vm) => _StreaksView(viewModel: vm),
    );
  }
}

class _StreaksView extends StatelessWidget {
  const _StreaksView({required this.viewModel});

  final StreaksPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.streaksPageTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Margins.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              currentStreak: viewModel.currentStreak,
              bestStreak: viewModel.bestStreak,
              isPro: viewModel.isPro,
            ),
            if (viewModel.canUnlockAllWithPro) ...[
              const SizedBox(height: Margins.spacingM),
              SecondaryButton(
                text: Strings.streaksUnlockAllWithPro,
                onPressed: () =>
                    showInAppPaywall(context, feature: 'streak_rewards_cta'),
              ),
            ],
            const _SectionDivider(),
            ...viewModel.rewards.map(
              (item) => _RewardTimelineRow(item: item),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.currentStreak,
    required this.bestStreak,
    required this.isPro,
  });

  final int currentStreak;
  final int bestStreak;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Texts.primaryRegularMedium(
                isPro
                    ? Strings.streaksPageSubtitlePro(bestStreak)
                    : Strings.streaksPageSubtitle(bestStreak),
                color: AppColors.contentSoft(context),
              ),
              if (currentStreak > 0) ...[
                const SizedBox(height: Margins.spacingM),
                Texts.primaryXsCounter(
                  context,
                  Strings.streaksCurrentStreak,
                  "$currentStreak ${currentStreak == 1 ? Strings.dayLabel : Strings.daysLabel}",
                  softColor: AppColors.contentSoft(context),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: Margins.spacingM),
        SmallDivider(width: double.infinity),
        SizedBox(height: Margins.spacingM),
      ],
    );
  }
}

class _RewardTimelineRow extends StatelessWidget {
  const _RewardTimelineRow({required this.item});

  final StreakRewardItem item;

  @override
  Widget build(BuildContext context) {
    const dotSize = Dimens.iconSizeM;
    const lineWidth = Dimens.strokeWidthS;

    final Widget dotWidget;
    if (item.isReached) {
      dotWidget = Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.content(context)),
        child: Icon(MingCuteIcons.mgc_check_line, size: Dimens.iconSizeXs, color: AppColors.bg(context)),
      );
    } else if (item.isActive) {
      dotWidget = Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.accentOrange(context)),
        child: const Icon(MingCuteIcons.mgc_fire_fill, size: Dimens.iconSizeXs, color: Colors.white),
      );
    } else {
      dotWidget = Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.strokeColor(context), width: lineWidth),
        ),
        child: item.isAvailable
            ? null
            : Icon(MingCuteIcons.mgc_lock_line, size: Dimens.iconSizeXs, color: AppColors.contentSoft(context)),
      );
    }

    final labelColor = item.isReached ? AppColors.contentSoft(context) : AppColors.content(context);
    final rewardId = item.rule.id;

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: dotSize, child: dotWidget),
            const SizedBox(width: Margins.spacingBase),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Margins.spacingS),
                  Text(
                    Strings.themeLockedStreakHint(item.minDays),
                    style: TextStyles.primaryMediumBlack.copyWith(
                      color: labelColor,
                      decoration: item.isReached ? TextDecoration.lineThrough : null,
                      decorationColor: labelColor,
                    ),
                  ),
                  const SizedBox(height: Margins.spacingXs),
                  Text(
                    rewardId.description,
                    style: TextStyles.primaryRegular.copyWith(color: AppColors.contentSoft(context)),
                  ),
                  if (item.isAvailable && !item.isReached) ...[
                    const SizedBox(height: Margins.spacingXs),
                    Text(
                      Strings.streaksIncludedInPro,
                      style: TextStyles.primarySmallRegular.copyWith(color: AppColors.contentSoft(context)),
                    ),
                  ],
                  const SizedBox(height: Margins.spacingM),
                  RewardPreview(
                    rewardId: rewardId,
                    locked: !item.isAvailable,
                    onTap: item.isAvailable
                        ? () => showRewardPicker(context, rewardId)
                        : () => showInAppPaywall(context, feature: 'streak_reward'),
                  ),
                  const SizedBox(height: Margins.spacingM),
                ],
              ),
            ),
          ],
        ),
        if (!item.isLast)
          Positioned(
            left: (dotSize - lineWidth) / 2,
            top: dotSize,
            bottom: 0,
            child: Container(
              width: lineWidth,
              color: AppColors.strokeColor(context),
            ),
          ),
      ],
    );
  }
}

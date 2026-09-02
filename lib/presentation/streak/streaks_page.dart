import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/streak/widgets/reward_preview.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class StreaksPageViewModel {
  const StreaksPageViewModel({
    required this.currentStreak,
    required this.bestStreak,
    required this.rewards,
  });

  final int currentStreak;
  final int bestStreak;
  final List<StreakRewardItem> rewards;

  static StreaksPageViewModel create(Store<AppState> store) {
    final streak = store.state.streakState;
    final unlocked = store.state.rewardsState.unlocked;

    final rules = RewardRules.streakMilestonesSorted;

    final firstLockedIndex = rules.indexWhere((rule) => !unlocked.contains(rule.id));

    final rewards = [
      for (var i = 0; i < rules.length; i++)
        StreakRewardItem(
          rule: rules[i],
          isUnlocked: unlocked.contains(rules[i].id),
          isActive: i == firstLockedIndex,
          isLast: i == rules.length - 1,
        ),
    ];

    return StreaksPageViewModel(
      currentStreak: streak.count,
      bestStreak: streak.bestEver,
      rewards: rewards,
    );
  }
}

class StreakRewardItem {
  const StreakRewardItem({
    required this.rule,
    required this.isUnlocked,
    required this.isActive,
    required this.isLast,
  });

  final RewardRule rule;
  final bool isUnlocked;
  final bool isActive;
  final bool isLast;

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
            ),
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
  });

  final int currentStreak;
  final int bestStreak;

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
                Strings.streaksPageSubtitle(bestStreak),
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
    if (item.isUnlocked) {
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
        child: Icon(MingCuteIcons.mgc_lock_line, size: Dimens.iconSizeXs, color: AppColors.contentSoft(context)),
      );
    }

    final labelColor = item.isUnlocked ? AppColors.contentSoft(context) : AppColors.content(context);

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
                      decoration: item.isUnlocked ? TextDecoration.lineThrough : null,
                      decorationColor: labelColor,
                    ),
                  ),
                  const SizedBox(height: Margins.spacingXs),
                  Text(
                    item.rule.id.description,
                    style: TextStyles.primaryRegular.copyWith(color: AppColors.contentSoft(context)),
                  ),
                  const SizedBox(height: Margins.spacingM),
                  RewardPreview(rewardId: item.rule.id, locked: !item.isUnlocked),
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

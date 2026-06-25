import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:redux/redux.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/rewards/reward_display.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/domain/rewards/reward_rules.dart';
import 'package:weeksalive/presentation/home/widgets/fire_rive_player.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';
import 'package:weeksalive/presentation/streak/widgets/reward_preview.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';

class TodayStreakViewModel {
  const TodayStreakViewModel({
    required this.streakCount,
    required this.newlyUnlockedRewards,
    this.nextRewardId,
    this.daysUntilNextReward,
  });

  final int streakCount;
  final List<RewardId> newlyUnlockedRewards;
  final RewardId? nextRewardId;
  final int? daysUntilNextReward;

  static TodayStreakViewModel fromStore(Store<AppState> store) {
    final streakCount = store.state.streakState.count;
    final newlyUnlockedRewards = RewardRules.sortByMilestone(
      store.state.rewardsState.pendingCelebration,
    );

    final next = newlyUnlockedRewards.isEmpty
        ? RewardRules.findNextStreakReward(
            currentStreak: streakCount,
            unlocked: store.state.rewardsState.unlocked,
          )
        : null;

    return TodayStreakViewModel(
      streakCount: streakCount,
      newlyUnlockedRewards: newlyUnlockedRewards,
      nextRewardId: next?.rewardId,
      daysUntilNextReward: next?.daysRemaining,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodayStreakViewModel &&
          other.streakCount == streakCount &&
          other.newlyUnlockedRewards.length == newlyUnlockedRewards.length &&
          other.newlyUnlockedRewards.toSet().containsAll(newlyUnlockedRewards) &&
          other.nextRewardId == nextRewardId &&
          other.daysUntilNextReward == daysUntilNextReward;

  @override
  int get hashCode => Object.hash(
    streakCount,
    Object.hashAllUnordered(newlyUnlockedRewards),
    nextRewardId,
    daysUntilNextReward,
  );
}

/// Écran affiché après la sauvegarde du jour, montrant le compteur de streak actuel.
class TodayStreakPage extends StatefulWidget {
  const TodayStreakPage({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<TodayStreakPage> createState() => _TodayStreakPageState();
}

class _TodayStreakPageState extends State<TodayStreakPage> {
  late final FlutterHaptic _haptic;

  static const _patterns = [150, 10, 150, 10, 150];

  @override
  void initState() {
    super.initState();
    _haptic = FlutterHaptic.instance;
    Future.delayed(const Duration(milliseconds: 100), () {
      _haptic
          .playPattern(
            HapticPattern.custom(
              pattern: _patterns,
              intensities: [0.3, 0.6, 0.9],
            ),
          )
          .then((_) {
            final totalDuration = _patterns.reduce((a, b) => a + b);
            Future.delayed(Duration(milliseconds: totalDuration + 50), () {
              HapticFeedback.heavyImpact();
            });
          });
    });
  }

  void _handleClose(BuildContext context) {
    final store = StoreProvider.of<AppState>(context, listen: false);
    if (store.state.rewardsState.pendingCelebration.isNotEmpty) {
      store.dispatch(const RewardsCelebrationDismissedAction());
    }
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TodayStreakViewModel>(
      converter: TodayStreakViewModel.fromStore,
      distinct: true,
      builder: (context, vm) => _StreakPageContent(
        viewModel: vm,
        onClose: () => _handleClose(context),
      ),
    );
  }
}

class _StreakPageContent extends StatelessWidget {
  const _StreakPageContent({
    required this.viewModel,
    required this.onClose,
  });

  final TodayStreakViewModel viewModel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final streakCount = viewModel.streakCount;
    final newlyUnlockedRewards = viewModel.newlyUnlockedRewards;
    final nextRewardId = viewModel.nextRewardId;
    final daysUntilNextReward = viewModel.daysUntilNextReward;

    return SheetContentScaffold(
      backgroundColor: AppColors.bg(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingL,
          vertical: Margins.spacingM,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Margins.spacingM),
            _FireIcon(),
            const SizedBox(height: Margins.spacingBase),
            Text(
              "$streakCount ${streakCount == 1 ? Strings.consecutiveDay : Strings.consecutiveDays}",
              style: TextStyles.primarySemiBold.copyWith(
                color: AppColors.content(context),
              ),
              textAlign: TextAlign.center,
            ),
            if (newlyUnlockedRewards.isNotEmpty) ...[
              const SizedBox(height: Margins.spacingXl),
              const SmallDivider(width: double.infinity),
              const SizedBox(height: Margins.spacingL),
              Text(
                Strings.streaksRewardUnlockedTitle(newlyUnlockedRewards.length),
                style: TextStyles.primaryBold.copyWith(
                  color: AppColors.content(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Margins.spacingXs),
              Text(
                Strings.streaksRewardUnlockedBody,
                style: TextStyles.primaryRegular.copyWith(
                  color: AppColors.contentSoft(context),
                ),
                textAlign: TextAlign.center,
              ),
              for (final rewardId in newlyUnlockedRewards) ...[
                const SizedBox(height: Margins.spacingL),
                _UnlockedRewardCard(rewardId: rewardId),
              ],
            ] else if (nextRewardId != null && daysUntilNextReward != null) ...[
              const SizedBox(height: Margins.spacingXl),
              const SmallDivider(width: double.infinity),
              const SizedBox(height: Margins.spacingL),
              Text(
                Strings.streaksNextRewardIn(daysUntilNextReward),
                style: TextStyles.primaryBold.copyWith(
                  color: AppColors.contentSoft(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Margins.spacingXs),
              Text(
                nextRewardId.description,
                style: TextStyles.primaryRegular.copyWith(
                  color: AppColors.contentSoft(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Margins.spacingBase),
              RewardPreview(rewardId: nextRewardId),
            ],
            const SizedBox(height: Margins.spacingXl),
            PrimaryButton(
              text: Strings.congratulations,
              onPressed: onClose,
            ),
            const SizedBox(height: Margins.spacingM),
          ],
        ),
      ),
    );
  }
}

class _UnlockedRewardCard extends StatelessWidget {
  const _UnlockedRewardCard({required this.rewardId});

  final RewardId rewardId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          rewardId.description,
          style: TextStyles.primarySemiBold.copyWith(
            color: AppColors.content(context),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacingBase),
        RewardPreviewContent(rewardId: rewardId),
        const SizedBox(height: Margins.spacingBase),
        SecondaryButton(
          text: rewardId.pickerButtonLabel,
          icon: MingCuteIcons.mgc_right_line,
          iconRight: true,
          onPressed: () => openRewardPicker(context, rewardId),
        ),
      ],
    );
  }
}

class _FireIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.bgSoft(context),
          shape: BoxShape.circle,
        ),
        child: const OverflowBox(
          maxWidth: 110,
          maxHeight: 110,
          alignment: Alignment.bottomCenter,
          child: Center(
            child: FireRivePlayer(),
          ),
        ),
      ),
    );
  }
}

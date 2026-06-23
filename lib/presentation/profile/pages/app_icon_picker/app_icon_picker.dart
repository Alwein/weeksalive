import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/rewards/reward_condition.dart';
import 'package:weeksalive/domain/rewards/reward_rules.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_actions.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class AppIconPickerViewModel {
  const AppIconPickerViewModel({
    required this.selectedIcon,
    required this.unlockedIcons,
  });

  final AppIconId selectedIcon;
  final Set<AppIconId> unlockedIcons;
}

class AppIconPicker extends StatelessWidget {
  const AppIconPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppIconPickerViewModel>(
      converter: (store) => AppIconPickerViewModel(
        selectedIcon: store.state.appIconState.selectedIcon,
        unlockedIcons: store.state.appIconState.unlockedIcons,
      ),
      builder: (context, viewModel) {
        return _AppIconGrid(viewModel: viewModel);
      },
    );
  }
}

class _AppIconGrid extends StatelessWidget {
  const _AppIconGrid({required this.viewModel});

  final AppIconPickerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      itemCount: AppIconId.all.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        mainAxisSpacing: Margins.spacingBase,
        crossAxisSpacing: Margins.spacingBase,
      ),
      itemBuilder: (context, index) {
        final iconId = AppIconId.all[index];
        return _AppIconCard(
          iconId: iconId,
          selected: iconId == viewModel.selectedIcon,
          locked: !viewModel.unlockedIcons.contains(iconId),
          onTap: () {
            if (!viewModel.unlockedIcons.contains(iconId)) return;
            SensorialFeedback.selectionChanged();
            StoreProvider.of<AppState>(context).dispatch(SetAppIconAction(iconId));
          },
        );
      },
    );
  }
}

class _AppIconCard extends StatelessWidget {
  const _AppIconCard({
    required this.iconId,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final AppIconId iconId;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? AppColors.content(context) : AppColors.bgSoft(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AnimationDurations.short,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Dimens.radiusL),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.radiusL - Dimens.strokeWidthBase),
          child: _AppIconCardContent(
            iconId: iconId,
            selected: selected,
            locked: locked,
          ),
        ),
      ),
    );
  }
}

class _AppIconCardContent extends StatelessWidget {
  const _AppIconCardContent({
    required this.iconId,
    required this.selected,
    required this.locked,
  });

  static const _illustrationSize = 96.0;

  final AppIconId iconId;
  final bool selected;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? AppColors.contentMuted(context) : AppColors.content(context);
    final hintColor = selected ? AppColors.contentMuted(context) : AppColors.contentSoftOnSoft(context);

    return Padding(
      padding: const EdgeInsets.all(Margins.spacingBase),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: _AppIconIllustration(
              iconId: iconId,
              size: _illustrationSize,
            ),
          ),
          const SizedBox(height: Margins.spacingBase),
          SizedBox(
            child: Center(
              child: locked
                  ? _LockedLabel(iconId: iconId, textColor: textColor, hintColor: hintColor)
                  : Texts.primaryMediumBold(
                      iconId.label,
                      color: textColor,
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedLabel extends StatelessWidget {
  const _LockedLabel({
    required this.iconId,
    required this.textColor,
    required this.hintColor,
  });

  final AppIconId iconId;
  final Color textColor;
  final Color hintColor;

  String? get _unlockHint {
    final rule = RewardRules.ruleForAppIcon(iconId);
    if (rule == null) return null;
    return switch (rule.condition) {
      StreakMilestoneCondition(:final minDays) => Strings.themeLockedStreakHint(minDays),
      TotalDaysLoggedCondition(:final minDays) => Strings.themeLockedStreakHint(minDays),
    };
  }

  @override
  Widget build(BuildContext context) {
    final hint = _unlockHint;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(MingCuteIcons.mgc_lock_line, color: textColor, size: Dimens.iconSizeS),
            const SizedBox(width: Margins.spacingS),
            Flexible(
              child: Texts.primaryMediumBold(
                iconId.label,
                color: textColor,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        if (hint != null) ...[
          const SizedBox(height: Margins.spacingS),
          Texts.primaryRegular(hint, color: hintColor, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}

class _AppIconIllustration extends StatelessWidget {
  const _AppIconIllustration({
    required this.iconId,
    required this.size,
  });

  final AppIconId iconId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        iconId.illustrationAsset,
        fit: BoxFit.contain,
      ),
    );
  }
}

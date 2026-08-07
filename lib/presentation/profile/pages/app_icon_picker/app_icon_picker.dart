import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

const _androidIconHintShownKey = 'app_icon_android_hint_shown_v1';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = Margins.spacingM * 2;
        const crossSpacing = Margins.spacingBase;
        final cellWidth = (constraints.maxWidth - horizontalPadding - crossSpacing) / 2;
        final cellHeight = (cellWidth / 0.85).clamp(155.0, 200.0);

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          itemCount: AppIconId.all.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: cellHeight,
            mainAxisSpacing: Margins.spacingBase,
            crossAxisSpacing: Margins.spacingBase,
          ),
          itemBuilder: (context, index) {
            final iconId = AppIconId.all[index];
            return _AppIconCard(
              iconId: iconId,
              selected: iconId == viewModel.selectedIcon,
              locked: !viewModel.unlockedIcons.contains(iconId),
              onTap: () => _onIconSelected(context, viewModel, iconId),
            );
          },
        );
      },
    );
  }

  Future<void> _onIconSelected(
    BuildContext context,
    AppIconPickerViewModel viewModel,
    AppIconId iconId,
  ) async {
    if (!viewModel.unlockedIcons.contains(iconId)) return;
    if (iconId == viewModel.selectedIcon) return;

    SensorialFeedback.selectionChanged();
    StoreProvider.of<AppState>(context).dispatch(SetAppIconAction(iconId));

    if (Platform.isAndroid) {
      await _maybeShowAndroidIconHint(context);
    }
  }

  Future<void> _maybeShowAndroidIconHint(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getBool(_androidIconHintShownKey) ?? false) return;
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _AndroidIconHintDialog(dialogContext: dialogContext),
    );

    await preferences.setBool(_androidIconHintShownKey, true);
  }
}

class _AndroidIconHintDialog extends StatelessWidget {
  const _AndroidIconHintDialog({required this.dialogContext});

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        side: BorderSide(color: AppColors.strokeColor(context)),
      ),
      backgroundColor: AppColors.bg(context),
      title: Texts.primaryMediumBold(Strings.appIconAndroidHintTitle),
      content: Texts.primaryRegularMedium(
        Strings.appIconAndroidHintMessage,
        color: AppColors.contentSoft(context),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              text: Strings.appIconAndroidHintButton,
            ),
          ],
        ),
      ],
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _AppIconIllustration(
                    iconId: iconId,
                    size: _illustrationSize.clamp(0, constraints.biggest.shortestSide),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: Margins.spacingS),
          locked
              ? _LockedLabel(iconId: iconId, textColor: textColor, hintColor: hintColor)
              : Texts.primaryMediumBold(
                  iconId.label,
                  color: textColor,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
      mainAxisSize: MainAxisSize.min,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (hint != null) ...[
          const SizedBox(height: Margins.spacingXs),
          Texts.primaryRegular(
            hint,
            color: hintColor,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
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

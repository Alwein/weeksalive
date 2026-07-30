import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';
import 'package:weeksalive/core/styles/themes/default_theme_tokens.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/rewards/reward_condition.dart';
import 'package:weeksalive/domain/rewards/reward_rules.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

enum ThemePickerScope { onboarding, all }

class ThemePickerViewModel {
  const ThemePickerViewModel({
    required this.selectedTheme,
    required this.unlockedThemes,
  });

  final AppThemeId selectedTheme;
  final Set<AppThemeId> unlockedThemes;
}

class ThemePicker extends StatelessWidget {
  const ThemePicker({
    super.key,
    this.scope = ThemePickerScope.all,
  });

  final ThemePickerScope scope;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ThemePickerViewModel>(
      converter: (store) => ThemePickerViewModel(
        selectedTheme: store.state.themeState.selectedTheme,
        unlockedThemes: store.state.themeState.unlockedThemes,
      ),
      builder: (context, viewModel) {
        final themes = scope == ThemePickerScope.onboarding ? AppThemeId.alwaysUnlocked : AppThemeId.all;
        return _ThemeGrid(
          themes: themes,
          viewModel: viewModel,
        );
      },
    );
  }
}

class _ThemeGrid extends StatelessWidget {
  const _ThemeGrid({
    required this.themes,
    required this.viewModel,
  });

  final List<AppThemeId> themes;
  final ThemePickerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = Margins.spacingM * 2;
        const crossSpacing = Margins.spacingBase;
        final cellWidth = (constraints.maxWidth - horizontalPadding - crossSpacing) / 2;
        final cellHeight = (cellWidth * 1.15).clamp(155.0, 190.0);

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          itemCount: themes.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: cellHeight,
            mainAxisSpacing: Margins.spacingBase,
            crossAxisSpacing: Margins.spacingBase,
          ),
          itemBuilder: (context, index) => _ThemeCard(
            themeId: themes[index],
            selected: themes[index] == viewModel.selectedTheme,
            locked: !viewModel.unlockedThemes.contains(themes[index]),
            onTap: () {
              if (!viewModel.unlockedThemes.contains(themes[index])) {
                return;
              }
              _selectTheme(context, themes[index]);
            },
          ),
        );
      },
    );
  }
}

void _selectTheme(BuildContext context, AppThemeId themeId) {
  SensorialFeedback.selectionChanged();
  StoreProvider.of<AppState>(context).dispatch(SetAppThemeAction(themeId));
}

extension AppThemeIdLabels on AppThemeId {
  String get label => switch (this) {
    AppThemeId.system => Strings.themeSystem,
    AppThemeId.dark => Strings.themeDark,
    AppThemeId.light => Strings.themeLight,
    AppThemeId.petale => Strings.themePetale,
    AppThemeId.pivoine => Strings.themePivoine,
    AppThemeId.cafe => Strings.themeCafe,
    AppThemeId.matcha => Strings.themeMatcha,
    AppThemeId.lavande => Strings.themeLavande,
    AppThemeId.terracotta => Strings.themeTerracotta,
    AppThemeId.ardoise => Strings.themeArdoise,
  };

  IconData get icon => switch (this) {
    AppThemeId.system => MingCuteIcons.mgc_shadow_line,
    AppThemeId.light => MingCuteIcons.mgc_sun_line,
    AppThemeId.dark => MingCuteIcons.mgc_moon_line,
    _ => MingCuteIcons.mgc_palette_line,
  };
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.themeId,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final AppThemeId themeId;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppThemes.of(themeId);
    final tokens = _resolveTokens(appTheme);
    final accentColor = appTheme.previewColor;

    final borderDecoration = BoxDecoration(
      color: tokens.bg,
      borderRadius: BorderRadius.circular(Dimens.radiusL),
      border: Border.all(
        color: tokens.strokeColor,
        width: Dimens.strokeWidthBase,
      ),
    );

    if (themeId == AppThemeId.system) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AnimationDurations.short,
          curve: Curves.easeInOut,
          decoration: borderDecoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.radiusL - Dimens.strokeWidthBase),
            child: _SystemFullCardContent(selected: selected, locked: locked),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AnimationDurations.short,
        curve: Curves.easeInOut,
        decoration: borderDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.radiusL - Dimens.strokeWidthBase),
          child: _FullCardContent(
            tokens: tokens,
            themeId: themeId,
            accentColor: accentColor,
            selected: selected,
            locked: locked,
          ),
        ),
      ),
    );
  }

  AppColorTokens _resolveTokens(AppTheme appTheme) {
    if (appTheme.isDynamic) return appTheme.lightTokens!;
    return appTheme.tokens!;
  }
}

class _FullCardContent extends StatelessWidget {
  const _FullCardContent({
    required this.tokens,
    required this.themeId,
    required this.accentColor,
    required this.selected,
    required this.locked,
  });

  final AppColorTokens tokens;
  final AppThemeId themeId;
  final Color accentColor;
  final bool selected;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tokens.bg,
      padding: const EdgeInsets.all(Margins.spacingBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (selected) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: _SelectedPill(tokens: tokens),
            ),
            const SizedBox(height: Margins.spacingXs),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Margins.spacingXs),
            child: Texts.primaryMediumBold(
              themeId.label,
              color: tokens.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: Margins.spacingS),
          Expanded(
            child: locked
                ? _LockedBarrier(tokens: tokens, themeId: themeId)
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: _MiniPreview(tokens: tokens),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SystemFullCardContent extends StatelessWidget {
  const _SystemFullCardContent({
    required this.selected,
    required this.locked,
  });

  final bool selected;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    const light = DefaultThemeTokens.light;
    const dark = DefaultThemeTokens.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        _FullCardContent(
          tokens: light,
          themeId: AppThemeId.system,
          accentColor: AppThemes.system.previewColor,
          selected: selected,
          locked: locked,
        ),
        ClipPath(
          clipper: const _DiagonalRightClipper(),
          child: _FullCardContent(
            tokens: dark,
            themeId: AppThemeId.system,
            accentColor: AppThemes.system.previewColor,
            selected: selected,
            locked: locked,
          ),
        ),
      ],
    );
  }
}

class _DiagonalRightClipper extends CustomClipper<Path> {
  const _DiagonalRightClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.42, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.58, size.height)
      ..close();
  }

  @override
  bool shouldReclip(_DiagonalRightClipper old) => false;
}

class _MiniPreview extends StatelessWidget {
  const _MiniPreview({required this.tokens});

  final AppColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MiniWeekGrid(tokens: tokens),
        const SizedBox(width: Margins.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              _FakeLine(tokens: tokens, widthFraction: 0.9, height: 12, color: tokens.content),
              _FakeLine(tokens: tokens, widthFraction: 0.7, height: 6, color: tokens.contentSoft),
              _FakeLine(tokens: tokens, widthFraction: 0.55, height: 6, color: tokens.contentSoft),
              _FakeLine(tokens: tokens, widthFraction: 0.8, height: 4, color: tokens.contentExtraSoft),
              _FakeLine(tokens: tokens, widthFraction: 0.9, height: 4, color: tokens.contentExtraSoft),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniWeekGrid extends StatelessWidget {
  const _MiniWeekGrid({required this.tokens});

  final AppColorTokens tokens;

  static const _rows = 4;
  static const _cols = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Margins.spacingXs,
      children: [
        for (var r = 0; r < _rows; r++)
          Row(
            spacing: Margins.spacingXs,
            children: [
              for (var c = 0; c < _cols; c++)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: r == 0 && c == 0 ? tokens.content : (r < 2 ? tokens.contentExtraSoft : Colors.transparent),
                    shape: BoxShape.circle,
                    border: r < 2 ? null : Border.all(color: tokens.strokeColor, width: Dimens.strokeWidthS),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _FakeLine extends StatelessWidget {
  const _FakeLine({
    required this.tokens,
    required this.widthFraction,
    required this.height,
    required this.color,
  });

  final AppColorTokens tokens;
  final double widthFraction;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: constraints.maxWidth * widthFraction,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }
}

class _SelectedPill extends StatelessWidget {
  const _SelectedPill({required this.tokens});

  final AppColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingS, vertical: Margins.spacingXs),
      decoration: BoxDecoration(
        color: tokens.content,
        borderRadius: BorderRadius.circular(Margins.spacingBase),
      ),
      child: Texts.primaryXsMedium(Strings.themeSelectedLabel, color: tokens.contentMuted),
    );
  }
}

class _LockedBarrier extends StatelessWidget {
  const _LockedBarrier({required this.tokens, required this.themeId});

  final AppColorTokens tokens;
  final AppThemeId themeId;

  String? get _unlockHint {
    final rule = RewardRules.ruleForTheme(themeId);
    if (rule == null) return null;
    return switch (rule.condition) {
      StreakMilestoneCondition(:final minDays) => Strings.themeLockedStreakHint(minDays),
      TotalDaysLoggedCondition(:final minDays) => Strings.themeLockedStreakHint(minDays),
    };
  }

  @override
  Widget build(BuildContext context) {
    final hint = _unlockHint;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(MingCuteIcons.mgc_lock_line, color: tokens.content, size: Dimens.iconSizeM),
          if (hint != null) ...[
            const SizedBox(height: Margins.spacingS),
            Texts.primaryRegular(
              hint,
              color: tokens.content,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

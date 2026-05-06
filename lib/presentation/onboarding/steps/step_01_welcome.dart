import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step01Welcome extends OnboardingStep {
  const Step01Welcome();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/weeksalive_logo.webp",
                    width: 96,
                    height: 96,
                  ),
                  const SizedBox(height: Margins.spacingXl),
                  Texts.xlBold(Strings.appName),
                  const SizedBox(height: Margins.spacingM),
                  Texts.primaryMediumSoft(
                    context,
                    Strings.onboarding01Subtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Margins.spacingM),
            const _ThemePicker(),
            const SizedBox(height: Margins.spacingM),
          ],
        ),
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ThemeMode>(
      converter: (store) => store.state.themeState.themeMode,
      builder: (context, currentThemeMode) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Texts.primaryMediumSoft(context, Strings.themePickerTitle),
          const SizedBox(height: Margins.spacingS),
          Row(
            spacing: Margins.spacingBase,
            children: [
              for (final option in ThemeOption.values)
                Expanded(
                  child: _ThemeChip(
                    option: option,
                    selected: option.themeMode == currentThemeMode,
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(
                        SetThemeModeAction(option.themeMode),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

enum ThemeOption { system, light, dark }

extension ThemeOptionExtension on ThemeOption {
  String get label => switch (this) {
    ThemeOption.system => Strings.themeSystem,
    ThemeOption.light => Strings.themeLight,
    ThemeOption.dark => Strings.themeDark,
  };

  IconData get icon => switch (this) {
    ThemeOption.system => MingCuteIcons.mgc_shadow_line,
    ThemeOption.light => MingCuteIcons.mgc_sun_line,
    ThemeOption.dark => MingCuteIcons.mgc_moon_line,
  };

  ThemeMode get themeMode => switch (this) {
    ThemeOption.system => ThemeMode.system,
    ThemeOption.light => ThemeMode.light,
    ThemeOption.dark => ThemeMode.dark,
  };
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ThemeOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? AppColors.content(context) : AppColors.bgSoft(context);
    final fgColor = selected ? AppColors.contentMuted(context) : AppColors.contentSoftOnSoft(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: Margins.spacingM),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Margins.spacingBase),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(option.icon, size: Dimens.iconSizeS, color: fgColor),
            const SizedBox(width: Margins.spacingS),
            Texts.primaryXsBold(
              option.label,
              color: fgColor,
            ),
          ],
        ),
      ),
    );
  }
}

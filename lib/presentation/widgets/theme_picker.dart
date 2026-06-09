import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key});

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
                      SensorialFeedback.selectionChanged();
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
        duration: AnimationDurations.short,
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/streak/streak_page.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';

class DayFormConfirmationPage extends StatelessWidget {
  const DayFormConfirmationPage({
    super.key,
    required this.entry,
    required this.isFirstEntry,
    required this.onClose,
  });

  final DayEntry entry;
  final bool isFirstEntry;
  final VoidCallback onClose;

  void _saveAndFinish(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(SaveDayAction(entry));

    if (isFirstEntry || 1 == 1) {
      SensorialFeedback.navigationChanged();
      Navigator.of(context).push(
        PagedSheetRoute<void>(
          builder: (_) => StreakPage(onClose: onClose),
        ),
      );
    } else {
      onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              Strings.dayFormConfirmationTitle,
              style: TextStyles.primaryHugeBold.copyWith(
                color: AppColors.content(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Margins.spacingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MingCuteIcons.mgc_check_line,
                  size: Dimens.iconSizeS,
                  color: AppColors.content(context),
                ),
                const SizedBox(width: Margins.spacingXs),
                Text(
                  Strings.dayFormConfirmationSubtitle,
                  style: TextStyles.primaryLargeMedium.copyWith(
                    color: AppColors.content(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: Margins.spacingM),
            _IllustrationBuilder(sizeLevel: entry.sizeLevel),
            const _PositiveAffirmation(),
            const SizedBox(height: Margins.spacingM),
            PrimaryButton(
              text: Strings.dayFormConfirmationSave,
              onPressed: () => _saveAndFinish(context),
            ),
            const SizedBox(height: Margins.spacingM),
          ],
        ),
      ),
    );
  }
}

class _IllustrationBuilder extends StatelessWidget {
  const _IllustrationBuilder({required this.sizeLevel});

  final int sizeLevel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
      child: switch (sizeLevel) {
        0 => const _RoughIllustration(),
        1 => const _LowIllustration(),
        2 => const _OkIllustration(),
        3 => const _GoodIllustration(),
        _ => const _AwesomeIllustration(),
      },
    );
  }
}

class _RoughIllustration extends StatelessWidget {
  const _RoughIllustration();

  @override
  Widget build(BuildContext context) {
    return const _IllustrationSizer(
      maxHeight: 300,
      child: ParallaxRive(
        alignment: Alignment.bottomCenter,
        maxOffset: 0,
        assetPath: "assets/animations/outline_love.riv",
      ),
    );
  }
}

class _LowIllustration extends StatelessWidget {
  const _LowIllustration();

  @override
  Widget build(BuildContext context) {
    return const _IllustrationSizer(
      maxHeight: 300,
      child: ParallaxRive(
        alignment: Alignment.bottomCenter,
        maxOffset: 0,
        assetPath: "assets/animations/outline_floating.riv",
      ),
    );
  }
}

class _OkIllustration extends StatelessWidget {
  const _OkIllustration();

  @override
  Widget build(BuildContext context) {
    return const _IllustrationSizer(
      maxHeight: 300,
      child: ParallaxRive(
        alignment: Alignment.bottomCenter,
        maxOffset: 0,
        assetPath: "assets/animations/outline_sky.riv",
      ),
    );
  }
}

class _GoodIllustration extends StatelessWidget {
  const _GoodIllustration();

  @override
  Widget build(BuildContext context) {
    return _IllustrationSizer(
      maxHeight: 200,
      child: OverflowBox(
        alignment: Alignment.bottomCenter,
        maxHeight: 300,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SvgPicture.asset(
              "assets/images/outline_meditate_2_bg.svg",
              colorFilter: ColorFilter.mode(AppColors.contentExtraSoft(context), BlendMode.srcIn),
            ),
            const ParallaxRive(
              alignment: Alignment.bottomCenter,
              maxOffset: 0,
              assetPath: "assets/animations/outline_meditate_2.riv",
            ),
          ],
        ),
      ),
    );
  }
}

class _AwesomeIllustration extends StatelessWidget {
  const _AwesomeIllustration();

  @override
  Widget build(BuildContext context) {
    return _IllustrationSizer(
      maxHeight: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SvgPicture.asset(
            "assets/images/outline_landed_bg.svg",
            colorFilter: ColorFilter.mode(AppColors.contentExtraSoft(context), BlendMode.srcIn),
            fit: BoxFit.fitWidth,
          ),
          const ParallaxRive(
            alignment: Alignment.bottomCenter,
            maxOffset: 0,
            assetPath: "assets/animations/outline_landed.riv",
          ),
        ],
      ),
    );
  }
}

class _IllustrationSizer extends StatelessWidget {
  const _IllustrationSizer({required this.child, required this.maxHeight});
  final Widget child;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: min(constraints.maxWidth, maxHeight),
          child: child,
        );
      },
    );
  }
}

class _PositiveAffirmation extends StatelessWidget {
  const _PositiveAffirmation();

  @override
  Widget build(BuildContext context) {
    final day = DateTime.now().day;
    return Container(
      padding: const EdgeInsets.all(Margins.spacingBase),
      decoration: BoxDecoration(
        color: AppColors.bgSoft(context),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
      ),
      child: Text(
        '"${Strings.dayFormConfirmationPositiveAffirmations[day]}"',
        textAlign: TextAlign.center,
        style: TextStyles.primaryLargeMedium.copyWith(
          color: AppColors.contentSoftOnSoft(context),
        ),
      ),
    );
  }
}

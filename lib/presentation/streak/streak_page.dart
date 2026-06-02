import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/streak/streak_state.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';

/// Écran placeholder affiché après la sauvegarde du jour,
/// montrant le compteur de streak actuel.
class StreakPage extends StatelessWidget {
  const StreakPage({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StreakState>(
      converter: (store) => store.state.streakState,
      builder: (context, streak) => _StreakPageContent(
        streakCount: streak.count,
        onClose: onClose,
      ),
    );
  }
}

class _StreakPageContent extends StatelessWidget {
  const _StreakPageContent({
    required this.streakCount,
    required this.onClose,
  });

  final int streakCount;
  final VoidCallback onClose;

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
            _FireIcon(),
            const SizedBox(height: Margins.spacingBase),
            Text(
              '$streakCount',
              style: TextStyles.primaryXxlBold.copyWith(
                color: AppColors.content(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Margins.spacingS),
            Text(
              streakCount == 1 ? 'jour consécutif' : 'jours consécutifs',
              style: TextStyles.primarySemiBold.copyWith(
                color: AppColors.contentSoft(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Margins.spacingXl),
            PrimaryButton(
              text: 'Fermer',
              onPressed: onClose,
            ),
            const SizedBox(height: Margins.spacingM),
          ],
        ),
      ),
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
        child: const Center(
          child: Icon(
            MingCuteIcons.mgc_fire_fill,
            size: Dimens.iconSizeHuge,
            color: AppColors.accentOrange,
          ),
        ),
      ),
    );
  }
}

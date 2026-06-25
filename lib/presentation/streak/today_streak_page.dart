import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/home/widgets/fire_rive_player.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/streak/streak_state.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';

/// Écran placeholder affiché après la sauvegarde du jour,
/// montrant le compteur de streak actuel.
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
              pattern: _patterns, // vibrate, pause, vibrate, pause, vibrate
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StreakState>(
      converter: (store) => store.state.streakState,
      builder: (context, streak) => _StreakPageContent(
        streakCount: streak.count,
        onClose: widget.onClose,
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
              streakCount == 1 ? Strings.consecutiveDay : Strings.consecutiveDays,
              style: TextStyles.primarySemiBold.copyWith(
                color: AppColors.contentSoft(context),
              ),
              textAlign: TextAlign.center,
            ),
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

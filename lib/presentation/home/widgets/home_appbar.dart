import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/home/view_model/home_page_view_model.dart';
import 'package:weeksalive/presentation/home/widgets/fire_rive_player.dart';
import 'package:weeksalive/presentation/paywall/show_in_app_paywall.dart';
import 'package:weeksalive/presentation/profile/profile_page.dart';
import 'package:weeksalive/presentation/streak/streaks_page.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.vm, required this.tabController});
  final HomePageViewModel vm;
  final TabController tabController;

  static const Duration streakHoldDuration = Duration(seconds: 1);
  static const Duration streakTransitionDuration = Duration(milliseconds: 350);

  @override
  State<HomeAppBar> createState() => HomeAppBarState();
}

class HomeAppBarState extends State<HomeAppBar> with SingleTickerProviderStateMixin {
  late final AnimationController _fireController;
  bool _showFire = false;

  @override
  void initState() {
    super.initState();
    _fireController = AnimationController(
      vsync: this,
      duration: HomeAppBar.streakTransitionDuration,
    );
    widget.tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _fireController.dispose();
    super.dispose();
  }

  Future<void> playStreakReveal() async {
    setState(() => _showFire = true);
    await _fireController.forward(from: 0);
    if (!mounted) return;
    await Future<void>.delayed(HomeAppBar.streakHoldDuration);
    if (!mounted) return;
    await _fireController.reverse();
    if (!mounted) return;
    setState(() => _showFire = false);
  }

  @override
  Widget build(BuildContext context) {
    final isLifeGridMode = widget.tabController.index == 0;
    return Material(
      color: AppColors.bg(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: AnimationDurations.short,
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: isLifeGridMode
                  ? _UserNameTitle(userName: widget.vm.userName, grid: widget.vm.lifeWeekGrid)
                  : const _YearGridTitle(),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!widget.vm.isPro) ...[
                const _PremiumButton(),
                const SizedBox(width: Margins.spacingS),
              ],
              if (widget.vm.streakCount > 0)
                _StreaksButton(
                  streaks: widget.vm.streakCount,
                  showFire: _showFire,
                  fireAnimation: _fireController,
                  isYesterdayGracePeriod: widget.vm.isYesterdayGracePeriod,
                ),
              const SizedBox(width: Margins.spacingS),
              const _ProfileButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserNameTitle extends StatelessWidget {
  const _UserNameTitle({
    required this.userName,
    required this.grid,
  });

  final String userName;
  final LifeWeekGrid grid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.homePageTitle(userName),
          style: TextStyles.primarySemiBold.copyWith(color: AppColors.content(context)),
        ),
        const SizedBox(height: Margins.spacingXs),
        Texts.primaryXsCounter(
          context,
          Strings.progressLabel,
          '${(grid.progressFraction * 100).toStringAsFixed(1)}%',
        ),
      ],
    );
  }
}

class _YearGridTitle extends StatelessWidget {
  const _YearGridTitle();

  @override
  Widget build(BuildContext context) {
    final String year = DateTime.now().year.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(year, style: TextStyles.primarySemiBold.copyWith(color: AppColors.content(context))),
        const SizedBox(height: Margins.spacingXs),
        Texts.primaryXsCounter(
          context,
          Strings.dayLabel,
          _getYearProgress(),
        ),
      ],
    );
  }

  String _getYearProgress() {
    final now = DateTime.now();
    final year = now.year;
    final totalDays = daysInGregorianYear(year);
    final livedDays = dayOfYearIndex(now) + 1;
    return '$livedDays / $totalDays';
  }
}

class _StreaksButton extends StatelessWidget {
  const _StreaksButton({
    required this.streaks,
    required this.showFire,
    required this.fireAnimation,
    required this.isYesterdayGracePeriod,
  });
  final int streaks;
  final bool showFire;
  final Animation<double> fireAnimation;
  final bool isYesterdayGracePeriod;

  @override
  Widget build(BuildContext context) {
    final streakIcon = isYesterdayGracePeriod ? MingCuteIcons.mgc_hours_line : MingCuteIcons.mgc_fire_fill;

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingBase,
          vertical: Margins.spacingS,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200))),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.content(context),
        textStyle: TextStyles.primaryRegularBold,
        backgroundColor: AppColors.bgSoft(context),
        surfaceTintColor: Colors.transparent,
      ),
      onPressed: () => StreaksPage.show(context),
      child: Row(
        children: [
          SizedBox(
            width: Dimens.iconSizeBase,
            height: Dimens.iconSizeBase,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    streakIcon,
                    color: AppColors.content(context),
                  ),
                ),
                if (showFire && !isYesterdayGracePeriod)
                  OverflowBox(
                    maxWidth: 70,
                    maxHeight: 70,
                    alignment: Alignment.bottomCenter,
                    child: FadeTransition(
                      opacity: fireAnimation,
                      child: ScaleTransition(
                        scale: fireAnimation,
                        alignment: Alignment.bottomCenter,
                        child: const FireRivePlayer(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Margins.spacingXs),
          Text(streaks.toString(), style: TextStyles.primaryRegularBold),
        ],
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  const _PremiumButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: IconButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingS, vertical: Margins.spacingS),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200))),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.accentOrange(context),
        backgroundColor: AppColors.bgSoft(context),
        surfaceTintColor: Colors.transparent,
      ),
      onPressed: () => showInAppPaywall(context),
      child: Icon(
        MingCuteIcons.mgc_diamond_2_line,
        color: AppColors.content(context),
        size: Dimens.iconSizeBase,
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: IconButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingS, vertical: Margins.spacingS),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200))),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.content(context),
        backgroundColor: AppColors.bgSoft(context),
        surfaceTintColor: Colors.transparent,
      ),
      onPressed: () => Navigator.of(context).push(ProfilePage.route()),
      child: Icon(
        MingCuteIcons.mgc_user_4_fill,
        color: AppColors.content(context),
        size: Dimens.iconSizeBase,
      ),
    );
  }
}

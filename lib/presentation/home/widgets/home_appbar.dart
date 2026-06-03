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
import 'package:weeksalive/presentation/widgets/texts.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.vm, required this.tabController});
  final HomePageViewModel vm;
  final TabController tabController;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() {});
    });
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
              _StreaksButton(streaks: widget.vm.streakCount),
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
        Text(Strings.homePageTitle(userName), style: TextStyles.primarySemiBold),
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
        Text(year, style: TextStyles.primarySemiBold),
        const SizedBox(height: Margins.spacingXs),
        Texts.primaryXsCounter(
          context,
          Strings.progressLabel,
          _getYearProgress(),
        ),
      ],
    );
  }

  String _getYearProgress() {
    final now = DateTime.now();
    final year = now.year;
    final totalDays = daysInGregorianYear(year);
    final livedDays = now.difference(DateTime(year, 1, 1)).inDays;
    return '${(livedDays / totalDays * 100).toStringAsFixed(1)}%';
  }
}

class _StreaksButton extends StatelessWidget {
  const _StreaksButton({required this.streaks});
  final int streaks;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingBase,
          vertical: Margins.spacingS,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.content(context),
        textStyle: TextStyles.primaryRegularBold,
        backgroundColor: AppColors.bgSoft(context),
        surfaceTintColor: Colors.transparent,
      ),
      onPressed: () {},
      child: Row(
        children: [
          SizedBox(
            width: Dimens.iconSizeBase,
            height: Dimens.iconSizeBase,
            child: Stack(
              children: [
                Center(
                  child: Icon(MingCuteIcons.mgc_fire_fill, color: AppColors.content(context)),
                ),
                // const OverflowBox(
                //   maxWidth: 70,
                //   maxHeight: 70,
                //   alignment: Alignment.bottomCenter,
                //   child: FireRivePlayer(),
                // ),
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

class _ProfileButton extends StatelessWidget {
  const _ProfileButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingS, vertical: Margins.spacingS),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.content(context),
        backgroundColor: AppColors.bgSoft(context),
        surfaceTintColor: Colors.transparent,
      ),
      onPressed: () {},
      icon: Icon(MingCuteIcons.mgc_user_4_fill, color: AppColors.content(context)),
    );
  }
}

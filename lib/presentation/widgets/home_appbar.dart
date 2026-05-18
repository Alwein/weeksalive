import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/home/view_model/home_page_view_model.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.vm});
  final HomePageViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg(context),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _Title(userName: vm.userName, grid: vm.lifeWeekGrid),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StreaksButton(streaks: vm.streakCount),
                const SizedBox(width: Margins.spacingXs),
                const _ProfileButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.userName,
    required this.grid,
  });

  final String userName;
  final LifeWeekGrid grid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.homePageTitle(userName), style: TextStyles.primarySemiBold),
        const SizedBox(height: Margins.spacingXs),
        Texts.primaryXsCounter(
          context,
          Strings.progressLabel,
          '${(grid.progressFraction * 100).toStringAsFixed(0)}%',
        ),
      ],
    );
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
          Icon(MingCuteIcons.mgc_fire_fill, color: AppColors.content(context)),
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

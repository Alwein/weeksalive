import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.userName, required this.streak});
  final String userName;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: Margins.spacingL,
      actionsPadding: const EdgeInsets.only(right: Margins.spacingL),
      elevation: 0,
      shadowColor: Colors.transparent,
      title: _Title(userName: userName),
      actions: [
        _StreaksButton(streaks: streak),
        const SizedBox(width: Margins.spacingXs),
        const _ProfileButton(),
      ],
      backgroundColor: AppColors.bg(context),
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Title extends StatelessWidget {
  const _Title({
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Texts.primaryRegularMedium(Strings.appName, color: AppColors.contentSoft(context)),
        Text(Strings.homePageTitle(userName), style: TextStyles.primarySemiBold),
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
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Margins.spacingBase, vertical: Margins.spacingS),
        ),
        foregroundColor: WidgetStateProperty.all(AppColors.content(context)),
        textStyle: WidgetStateProperty.all(TextStyles.primaryRegularBold),
        backgroundColor: WidgetStateProperty.all(AppColors.bgSoft(context)),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
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
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: Margins.spacingS, vertical: Margins.spacingS),
        ),
        foregroundColor: WidgetStateProperty.all(AppColors.content(context)),
        backgroundColor: WidgetStateProperty.all(AppColors.bgSoft(context)),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      ),
      onPressed: () {},
      icon: Icon(MingCuteIcons.mgc_user_4_fill, color: AppColors.content(context)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({super.key, required this.title, this.actions, this.onLeadingPressed});
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onLeadingPressed;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool useCloseButton = parentRoute?.fullscreenDialog ?? false;
    return AppBar(
      centerTitle: false,
      title: Texts.hugeBold(title),
      backgroundColor: AppColors.bg(context),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      leading: IconButton(
        onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
        icon: Icon(
          useCloseButton ? MingCuteIcons.mgc_close_line : MingCuteIcons.mgc_left_line,
          color: AppColors.content(context),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:flutter_fast_template/core/styles/app_colors.dart';
import 'package:flutter_fast_template/core/texts/strings.dart';
import 'package:flutter_fast_template/presentation/widgets/texts.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Texts.appTitle(Strings.appName),
      backgroundColor: AppColors.getBackgroundColor(context),
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

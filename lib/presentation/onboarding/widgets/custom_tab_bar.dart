import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onTap,
    this.tabHeight,
  });

  final List<Tab> tabs;
  final TabController controller;

  final ValueChanged<int>? onTap;

  final double? tabHeight;

  @override
  Widget build(BuildContext context) {
    final height = tabHeight ?? kTextTabBarHeight;
    return SizedBox(
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSoft(context),
          borderRadius: const BorderRadius.all(Radius.circular(360)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(360)),
          child: TabBar(
            controller: controller,
            onTap: onTap,
            labelColor: AppColors.content(context),
            unselectedLabelColor: AppColors.contentSoftOnSoft(context),
            tabs: tabs,
            indicator: BoxDecoration(
              color: AppColors.bg(context),
              borderRadius: const BorderRadius.all(Radius.circular(360)),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            indicatorPadding: const EdgeInsets.all(2),
          ),
        ),
      ),
    );
  }
}

class CustomTabController extends TabController {
  CustomTabController({
    required super.length,
    required super.vsync,
  });

  @override
  void animateTo(int value, {Duration? duration, Curve curve = Curves.ease}) {
    super.animateTo(
      value,
      duration: AnimationDurations.short,
      curve: curve,
    );
  }
}

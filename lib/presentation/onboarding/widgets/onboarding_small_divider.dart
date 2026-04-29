import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';

class SmallDivider extends StatelessWidget {
  const SmallDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: 50,
      color: AppColors.strokeColor(context),
    );
  }
}

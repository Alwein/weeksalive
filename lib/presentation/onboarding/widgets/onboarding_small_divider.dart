import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';

class SmallDivider extends StatelessWidget {
  const SmallDivider({super.key, this.width = 50});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: width,
      color: AppColors.strokeColor(context),
    );
  }
}

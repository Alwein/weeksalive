import 'package:flutter/material.dart';
import 'package:flutter_fast_template/core/styles/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
    );
  }
}

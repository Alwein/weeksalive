import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const WidgetsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.profilePageWidgets),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Margins.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Texts.primaryRegularMedium(
              Strings.profilePageWidgetsLifeGrid,
              color: AppColors.contentSoft(context),
            ),
            const SizedBox(height: Margins.spacingM),
            const _WidgetSection(assetName: 'assets/images/life_small_1x.webp', widthFactor: 0.5),
            const SizedBox(height: Margins.spacingM),
            const _WidgetSection(assetName: 'assets/images/life_large_1x.webp'),
            const _Divider(),
            Texts.primaryRegularMedium(
              Strings.profilePageWidgetsYearGrid,
              color: AppColors.contentSoft(context),
            ),
            const SizedBox(height: Margins.spacingM),
            const _WidgetSection(assetName: 'assets/images/year_medium_1x.webp'),
            const SizedBox(height: Margins.spacingM),
            const _WidgetSection(assetName: 'assets/images/year_large_1x.webp'),
            const SizedBox(height: Margins.spacingM),
          ],
        ),
      ),
    );
  }
}

class _WidgetSection extends StatelessWidget {
  const _WidgetSection({required this.assetName, this.widthFactor = 1.0});
  final String assetName;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Image.asset(assetName, width: (MediaQuery.of(context).size.width - 2 * Margins.spacingM) * widthFactor);
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: Margins.spacingM),
        SmallDivider(width: double.infinity),
        SizedBox(height: Margins.spacingM),
      ],
    );
  }
}

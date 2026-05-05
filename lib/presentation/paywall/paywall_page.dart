import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

const _trialWeeks = 2;
const _pricePerYear = '49,99 €';
const _pricePerWeek = '0,96 €';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (context) => const PaywallPage());

  @override
  Widget build(BuildContext context) {
    return const _PaywallView(trialWeeks: _trialWeeks);
  }
}

class _PaywallView extends StatelessWidget {
  const _PaywallView({required this.trialWeeks});
  final int trialWeeks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: SafeArea(
        top: true,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Margins.spacingM),
                  Texts.xlBold('Try WeeksAlive free for $trialWeeks weeks.'),
                  const SizedBox(height: Margins.spacingL),
                  _TrialTimeline(trialWeeks: trialWeeks),
                  const SizedBox(height: Margins.spacingHuge),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(color: AppColors.bg(context)),
                child: Column(
                  children: [
                    const SmallDivider(width: double.infinity),
                    const SizedBox(height: Margins.spacingBase),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
                      child: Column(
                        children: [
                          _PriceBlock(
                            trialWeeks: trialWeeks,
                            pricePerYear: _pricePerYear,
                            pricePerWeek: _pricePerWeek,
                          ),
                          const SizedBox(height: Margins.spacingBase),
                          _CtaButton(trialWeeks: trialWeeks, onTap: () {}),
                          const SizedBox(height: Margins.spacingBase),
                          _Footer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestoreAndLinks extends StatelessWidget {
  const _RestoreAndLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FooterLink(label: 'Terms', onTap: () {}),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '·',
            style: TextStyles.primaryXsRegular.copyWith(
              color: AppColors.contentSoftOnSoft(context),
            ),
          ),
        ),
        _FooterLink(label: 'Privacy', onTap: () {}),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '·',
            style: TextStyles.primaryXsRegular.copyWith(
              color: AppColors.contentSoftOnSoft(context),
            ),
          ),
        ),
        _FooterLink(label: 'Restore', onTap: () {}),
      ],
    );
  }
}

class _TrialTimeline extends StatelessWidget {
  const _TrialTimeline({required this.trialWeeks});
  final int trialWeeks;

  @override
  Widget build(BuildContext context) {
    final reminderWeek = trialWeeks == 2 ? 'Week 1' : 'Week 3';

    final steps = [
      const _TimelineItem(
        isActive: false,
        isDone: true,
        label: 'Download the app',
        sublabel: 'You chose to see your life differently.',
      ),
      const _TimelineItem(
        isActive: true,
        label: 'Today — Free trial starts',
        sublabel: 'Get full access. Start shaping your grid.',
      ),
      _TimelineItem(
        isActive: false,
        label: '$reminderWeek — Feel your first wins',
        sublabel: "Your first week is already on the grid. You'll remember this one.",
      ),
      _TimelineItem(
        isActive: false,
        label: 'Week $trialWeeks — End of trial period',
        sublabel:
            "Watch your grid growing. Cancel anytime before ${DateFormat('MMM d').format(DateTime.now().add(Duration(days: trialWeeks * 7)))} you won't be charged.",
        isLast: true,
      ),
    ];

    return Column(
      children: steps.map((s) => _TimelineRow(item: s)).toList(),
    );
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.isActive,
    required this.label,
    required this.sublabel,
    this.isDone = false,
    this.isLast = false,
  });
  final bool isActive;
  final bool isDone;
  final String label;
  final String sublabel;
  final bool isLast;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item});
  final _TimelineItem item;

  static const double _dotSize = 20.0;
  static const double _lineWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final Color dotColor;
    final Widget dotWidget;

    if (item.isDone) {
      dotColor = AppColors.content(context);
      dotWidget = Container(
        width: _dotSize,
        height: _dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.content(context),
        ),
        child: const Icon(Icons.check, size: 16, color: Colors.white),
      );
    } else if (item.isActive) {
      dotColor = AppColors.highlightColor;
      dotWidget = Container(
        width: _dotSize,
        height: _dotSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.highlightColor,
        ),
      );
    } else {
      dotColor = AppColors.strokeColor(context);
      dotWidget = Container(
        width: _dotSize,
        height: _dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: dotColor, width: 1.5),
        ),
      );
    }

    final labelColor = item.isDone
        ? AppColors.contentSoft(context)
        : item.isActive
        ? AppColors.content(context)
        : AppColors.content(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                const SizedBox(height: 3),
                dotWidget,
                if (!item.isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: _lineWidth,
                        color: AppColors.strokeColor(context),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Margins.spacingBase),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: item.isLast ? 0 : Margins.spacingL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyles.primaryMediumBlack.copyWith(
                      color: labelColor,
                      decoration: item.isDone ? TextDecoration.lineThrough : null,
                      decorationColor: labelColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.sublabel,
                    style: TextStyles.primaryRegular.copyWith(
                      color: AppColors.contentSoft(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({
    required this.trialWeeks,
    required this.pricePerYear,
    required this.pricePerWeek,
  });
  final int trialWeeks;
  final String pricePerYear;
  final String pricePerWeek;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$trialWeeks weeks free, then $pricePerYear / year',
          style: TextStyles.primaryRegular.copyWith(
            color: AppColors.contentSoft(context),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacingXs),
        Text(
          'Only $pricePerWeek / week',
          style: TextStyles.primaryMediumBlack.copyWith(
            color: AppColors.content(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.trialWeeks, required this.onTap});
  final int trialWeeks;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.content(context),
          borderRadius: BorderRadius.circular(200),
        ),
        alignment: Alignment.center,
        child: Text(
          'Start my $trialWeeks-week free trial',
          style: TextStyles.mediumBold.copyWith(
            color: AppColors.bg(context),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Cancel anytime. Billed via App Store.',
          style: TextStyles.primaryXsRegular.copyWith(
            color: AppColors.contentSoft(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyles.primaryXsRegular.copyWith(
          color: AppColors.contentSoft(context),
          decoration: TextDecoration.underline,
          decorationColor: AppColors.contentSoft(context),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/paywall/paywall_view_model.dart';

class PaywallPlanPicker extends StatelessWidget {
  const PaywallPlanPicker({
    super.key,
    required this.plans,
    required this.selected,
    required this.onSelect,
    required this.isLoading,
  });

  final List<PaywallPlanOption> plans;
  final PaywallPlanKind? selected;
  final ValueChanged<PaywallPlanKind> onSelect;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      if (!isLoading) return const SizedBox.shrink();
      return const Column(
        children: [
          _PlanCardSkeleton(),
          SizedBox(height: Margins.spacingS),
          _PlanCardSkeleton(),
          SizedBox(height: Margins.spacingS),
          _PlanCardSkeleton(),
        ],
      );
    }

    return Column(
      children: [
        for (var i = 0; i < plans.length; i++) ...[
          if (i > 0) const SizedBox(height: Margins.spacingS),
          _PlanCard(
            plan: plans[i],
            selected: plans[i].kind == selected,
            onTap: isLoading ? null : () => onSelect(plans[i].kind),
          ),
        ],
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final PaywallPlanOption plan;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title = switch (plan.kind) {
      PaywallPlanKind.annual => Strings.paywallPlanAnnual,
      PaywallPlanKind.weekly => Strings.paywallPlanWeekly,
      PaywallPlanKind.lifetime => Strings.paywallPlanLifetime,
    };
    final price = switch (plan.kind) {
      PaywallPlanKind.annual => Strings.paywallPlanPricePerYear(plan.price),
      PaywallPlanKind.weekly => Strings.paywallPlanPricePerWeek(plan.price),
      PaywallPlanKind.lifetime => Strings.paywallPlanPriceOnce(plan.price),
    };
    final equivalent = plan.equivalentWeeklyPrice;

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AnimationDurations.short,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: Margins.spacingBase,
            vertical: Margins.spacingBase,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.bgSoft(context) : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimens.radiusBase),
            border: Border.all(
              color: selected
                  ? AppColors.content(context)
                  : AppColors.strokeColor(context),
              width: Dimens.strokeWidthBase,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.primaryMediumBlack.copyWith(
                        color: AppColors.content(context),
                      ),
                    ),
                    const SizedBox(height: Margins.spacingXs),
                    Text(
                      price,
                      style: TextStyles.primaryRegular.copyWith(
                        color: AppColors.content(context),
                      ),
                    ),
                    if (equivalent != null) ...[
                      const SizedBox(height: Margins.spacingXs),
                      Text(
                        Strings.paywallPricePerWeek(equivalent),
                        style: TextStyles.primarySmallRegular.copyWith(
                          color: AppColors.contentSoft(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (plan.savingsPercent != null)
                _SaveBadge(percent: plan.savingsPercent!),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveBadge extends StatelessWidget {
  const _SaveBadge({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Margins.spacingS,
        vertical: Margins.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.content(context),
        borderRadius: BorderRadius.circular(Dimens.radiusXs),
      ),
      child: Text(
        Strings.paywallPlanSavePercent(percent),
        style: TextStyles.primaryXsBold.copyWith(color: AppColors.bg(context)),
      ),
    );
  }
}

class _PlanCardSkeleton extends StatelessWidget {
  const _PlanCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.strokeColor(context),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
      ),
    );
  }
}

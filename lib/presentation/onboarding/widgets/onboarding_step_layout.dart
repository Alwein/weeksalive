import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/margins.dart';

class OnboardingStepLayout extends StatelessWidget {
  const OnboardingStepLayout({
    super.key,
    this.title,
    this.subtitle,
    this.illustration,
    this.body,
    this.footer,
    this.input,
  });

  final String? title;
  final String? subtitle;
  final Widget? illustration;
  final Widget? body;
  final Widget? footer;
  final Widget? input;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final children = <Widget>[
      if (title != null) ...[
        Text(
          title!,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: Margins.spacingBase),
      ],
      if (subtitle != null) ...[
        Text(
          subtitle!,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: Margins.spacingM),
      ],
      if (illustration != null) ...[
        illustration!,
        const SizedBox(height: Margins.spacingM),
      ],
      if (body != null) ...[
        body!,
        const SizedBox(height: Margins.spacingBase),
      ],
      if (input != null) ...[
        input!,
        const SizedBox(height: Margins.spacingBase),
      ],
      if (footer != null) ...[
        const SizedBox(height: Margins.spacingBase),
        DefaultTextStyle.merge(
          style: theme.textTheme.bodySmall ?? const TextStyle(),
          child: footer!,
        ),
      ],
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

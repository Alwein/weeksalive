import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/utils/display_state.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconRight = false,
  }) : _displayState = null;

  const PrimaryButton.animated({
    super.key,
    required this.text,
    required this.onPressed,
    required DisplayState displayState,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconRight = false,
  }) : _displayState = displayState;

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool iconRight;
  final DisplayState? _displayState;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: TextStyles.primaryRegularBold.copyWith(color: textColor ?? AppColors.contentMuted(context)),
    );
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        foregroundColor: WidgetStateProperty.all(Colors.transparent),
        textStyle: WidgetStateProperty.all(TextStyles.mediumBold),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? AppColors.content(context).withValues(alpha: 0.5)
              : backgroundColor ?? AppColors.content(context);
        }),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        alignment: Alignment.center,
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200))),
        ),
        overlayColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.1)),
      ),
      onPressed: _displayState?.isLoading == true ? null : onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM, vertical: Margins.spacingBase),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Margins.spacingS,
          children: [
            if (icon != null && !iconRight) Icon(icon, color: textColor ?? AppColors.contentMuted(context)),
            if (_displayState?.isLoading == true)
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(opacity: 0, child: textWidget),
                  _LoadingDots(textColor: textColor ?? AppColors.contentMuted(context)),
                ],
              )
            else
              textWidget,
            if (icon != null && iconRight) Icon(icon, color: textColor ?? AppColors.contentMuted(context)),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots({required this.textColor});

  final Color textColor;

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _animations = List.generate(3, (index) {
      final delay = index * 0.2;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, delay + 0.4, curve: Curves.easeInOutCubic),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final value = _animations[index].value;
            final yOffset = value < 0.5 ? -6 * (value * 2) : -6 * ((1 - value) * 2);
            return Transform.translate(
              offset: Offset(0, yOffset),
              child: Text(
                '·',
                style: TextStyles.primaryRegularBold.copyWith(color: widget.textColor),
              ),
            );
          },
        );
      }),
    );
  }
}

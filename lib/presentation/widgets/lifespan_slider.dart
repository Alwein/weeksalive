import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class LifespanSlider extends StatefulWidget {
  const LifespanSlider({
    super.key,
    required this.value,
    required this.min,
    required this.onChanged,
    this.label,
  });

  static const int max = 130;

  final int value;
  final int min;
  final ValueChanged<int> onChanged;
  final String? label;

  @override
  State<LifespanSlider> createState() => _LifespanSliderState();
}

class _LifespanSliderState extends State<LifespanSlider> {
  int? _lastSoundValue;

  void _handleChanged(double v) {
    final rounded = v.round();
    if (rounded != _lastSoundValue) {
      _lastSoundValue = rounded;
      SensorialFeedback.sliderChanged();
    }
    widget.onChanged(rounded);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMin = widget.min.clamp(0, LifespanSlider.max - 1);
    final effectiveValue = widget.value.clamp(effectiveMin, LifespanSlider.max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Row(
            children: [
              Expanded(child: Texts.primaryMedium(widget.label!)),
              Texts.primaryMedium('$effectiveValue years'),
            ],
          )
        else
          Align(
            alignment: Alignment.centerRight,
            child: Texts.primaryMedium('$effectiveValue years'),
          ),
        const SizedBox(height: Margins.spacingM),
        Slider(
          padding: EdgeInsets.zero,
          min: effectiveMin.toDouble(),
          max: LifespanSlider.max.toDouble(),
          divisions: LifespanSlider.max - effectiveMin,
          value: effectiveValue.toDouble(),
          onChanged: _handleChanged,
          thumbColor: AppColors.content(context),
          activeColor: AppColors.content(context),
          inactiveColor: AppColors.bgSoft(context),
        ),
      ],
    );
  }
}

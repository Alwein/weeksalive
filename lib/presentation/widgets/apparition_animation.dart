import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/dimens.dart';

class ApparitionAnimation extends StatefulWidget {
  const ApparitionAnimation({super.key, required this.child});
  final Widget child;

  @override
  State<ApparitionAnimation> createState() => _ApparitionAnimationState();
}

class _ApparitionAnimationState extends State<ApparitionAnimation> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: AnimationDurations.medium,
      child: widget.child,
    );
  }
}

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiWrapper extends StatefulWidget {
  const ConfettiWrapper({super.key, required this.builder});
  final Widget Function(BuildContext context, ConfettiController confettiController) builder;

  @override
  State<ConfettiWrapper> createState() => _ConfettiWrapperState();
}

class _ConfettiWrapperState extends State<ConfettiWrapper> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(context, _confettiController),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            gravity: 0.2,
            numberOfParticles: 50,
          ),
        ),
      ],
    );
  }
}

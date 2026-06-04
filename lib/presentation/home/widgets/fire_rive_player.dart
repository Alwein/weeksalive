import 'package:flutter/material.dart' hide Animation;
import 'package:rive/rive.dart';

/// Plays the "Reveal" animation once, then loops "idle" forever.
///
/// Show/hide transitions (scale + fade) are handled by the parent so the Rive
/// artboard only ever plays forward.
class FireRivePlayer extends StatefulWidget {
  const FireRivePlayer({super.key});

  @override
  State<FireRivePlayer> createState() => _FireRivePlayerState();
}

class _FireRivePlayerState extends State<FireRivePlayer> {
  File? _file;
  Artboard? _artboard;
  _FireSequencePainter? _painter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final file = await File.asset(
      'assets/animations/rive_fire.riv',
      riveFactory: Factory.flutter,
    );
    if (file == null || !mounted) return;
    final artboard = file.defaultArtboard();
    if (artboard == null) {
      file.dispose();
      return;
    }
    final painter = _FireSequencePainter();
    setState(() {
      _file = file;
      _artboard = artboard;
      _painter = painter;
    });
  }

  @override
  void dispose() {
    _painter?.dispose();
    _artboard?.dispose();
    _file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artboard = _artboard;
    final painter = _painter;
    if (artboard == null || painter == null) return const SizedBox.shrink();
    return RiveArtboardWidget(
      artboard: artboard,
      painter: painter,
    );
  }
}

/// Custom painter that plays "Reveal" once, then loops "idle".
base class _FireSequencePainter extends BasicArtboardPainter {
  Animation? _current;
  Animation? _idle;
  bool _revealDone = false;

  @override
  void artboardChanged(Artboard artboard) {
    super.artboardChanged(artboard);
    _revealDone = false;
    _current = artboard.animationNamed('Reveal');
    _idle = artboard.animationNamed('idle');
    notifyListeners();
  }

  @override
  bool advance(double elapsedSeconds) {
    final current = _current;
    if (current == null) return false;

    final keepGoing = current.advanceAndApply(elapsedSeconds);

    if (!keepGoing && !_revealDone) {
      _revealDone = true;
      _current = _idle;
    }

    return true;
  }
}

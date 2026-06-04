import 'package:flutter/services.dart';

class SensorialFeedback {
  static void sliderChanged() {
    SystemSound.play(SystemSoundType.tick);
    HapticFeedback.lightImpact();
  }

  static void selectionChanged() {
    HapticFeedback.lightImpact();
  }

  static void navigationChanged() {
    HapticFeedback.lightImpact();
  }

  /// Haptic whose intensity grows with the recorded day [sizeLevel] (0..4).
  static void dayAppear(int sizeLevel) {
    switch (sizeLevel.clamp(0, 4)) {
      case 0:
      case 1:
        HapticFeedback.lightImpact();
      case 2:
      case 3:
        HapticFeedback.mediumImpact();
      default:
        HapticFeedback.heavyImpact();
    }
  }
}

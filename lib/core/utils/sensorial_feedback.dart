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
}

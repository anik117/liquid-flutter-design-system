import 'package:flutter/services.dart';

/// What kind of feedback a moment deserves.
enum LqHaptic {
  /// No feedback.
  none,

  /// A value ticked over: picker rows, slider steps, segments.
  selection,

  /// A tap on a control.
  light,

  /// A commitment: saving, starting a drive.
  medium,

  /// Something finished well.
  success,

  /// Something needs attention.
  warning,
}

/// Plays haptics in one place so every component feels the same.
abstract final class LqHaptics {
  static void play(LqHaptic haptic) {
    switch (haptic) {
      case LqHaptic.none:
        break;
      case LqHaptic.selection:
        HapticFeedback.selectionClick();
      case LqHaptic.light:
        HapticFeedback.lightImpact();
      case LqHaptic.medium:
        HapticFeedback.mediumImpact();
      case LqHaptic.success:
        HapticFeedback.mediumImpact();
      case LqHaptic.warning:
        HapticFeedback.heavyImpact();
    }
  }
}

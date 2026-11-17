import 'package:flutter/widgets.dart';

/// Motion tokens. Every movement has a cause (a press, an arrival, a data
/// change) and settles on a spring rather than a linear ramp.
abstract final class LqMotion {
  /// Color, border and shadow changes on controls (BoardUI 150ms).
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 420);

  /// Slow, repeating ambient motion: a live pulse, a shimmer sweep.
  static const Duration ambient = Duration(milliseconds: 1800);

  /// Press release: BoardUI's 420ms cubic-bezier(0.4, 0, 0.2, 1).
  static const Curve release = Cubic(0.4, 0, 0.2, 1);

  /// Pressing in is quick so the control feels attached to the finger.
  static const Duration pressIn = Duration(milliseconds: 90);

  /// Scale a pressed control shrinks to.
  static const double pressScale = 0.97;

  /// Default spring: a soft bounce for pills, thumbs and sheets.
  static const SpringDescription spring = SpringDescription(
    mass: 1,
    stiffness: 420,
    damping: 30,
  );

  /// Curve approximation of [spring] for implicit animations.
  static const Curve springCurve = Cubic(0.34, 1.36, 0.64, 1);

  /// Snappy settle with no overshoot.
  static const Curve emphasized = Cubic(0.2, 0, 0, 1);

  /// Scale a glass control swells to while held (iOS 26 glass grows under
  /// the finger instead of sinking).
  static const double glassPressScale = 1.1;

  /// True when the person turned on Reduce Motion in system settings.
  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// [duration], or zero under Reduce Motion: the state still changes, it
  /// just doesn't travel or bounce.
  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}

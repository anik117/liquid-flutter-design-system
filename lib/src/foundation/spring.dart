import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../tokens/motion.dart';

/// Real spring physics for drag-driven motion. When a finger lets go of a
/// slider thumb, a sheet or a swipe row, the motion continues with the
/// finger's speed and settles on a spring, instead of restarting on a
/// fixed curve.
abstract final class LqSpring {
  /// Soft settle with a little bounce: thumbs, pills, rows snapping back.
  static const SpringDescription soft = LqMotion.spring;

  /// Firmer and quicker, no visible bounce: sheets, drawers.
  static const SpringDescription firm = SpringDescription(
    mass: 1,
    stiffness: 600,
    damping: 46,
  );

  /// Animates [controller] from its current value to [target], carrying
  /// [velocity] (in controller units per second). Under Reduce Motion it
  /// jumps straight to the target.
  static TickerFuture animate(
    AnimationController controller,
    double target, {
    double velocity = 0,
    SpringDescription spring = soft,
    BuildContext? context,
  }) {
    if (context != null && LqMotion.reduced(context)) {
      controller.value = target;
      return TickerFuture.complete();
    }
    // snapToEnd lands exactly on the target, so a closed row or sheet is
    // never left a fraction of a pixel open.
    return controller.animateWith(
      SpringSimulation(
        spring,
        controller.value,
        target,
        velocity,
        snapToEnd: true,
      ),
    );
  }
}

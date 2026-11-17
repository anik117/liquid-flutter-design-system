import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';

/// Ring diameters and stroke widths.
enum LqProgressRingSize {
  /// 28pt, inline next to a row title.
  small(28, 3.5),

  /// 64pt, in a card beside a stat.
  medium(64, 7),

  /// 120pt, the one big ring on a screen.
  large(120, 11);

  const LqProgressRingSize(this.diameter, this.stroke);

  /// Outer diameter of the ring.
  final double diameter;

  /// Width of the track and the sweep.
  final double stroke;
}

/// A circular determinate progress ring: an accent-gradient sweep with
/// round caps over a sunken track, springing to each new value. Put a
/// short label in the middle with [child], e.g. "72%".
class LqProgressRing extends StatelessWidget {
  const LqProgressRing({
    super.key,
    required this.value,
    this.size = LqProgressRingSize.medium,
    this.child,
    this.semanticLabel,
  });

  /// Progress from 0 to 1.
  final double value;

  /// Diameter and stroke preset.
  final LqProgressRingSize size;

  /// Centered content, usually the percentage.
  final Widget? child;

  /// What the ring measures, e.g. "Trips reviewed".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final clamped = value.clamp(0.0, 1.0);
    return Semantics(
      label: semanticLabel,
      value: '${(clamped * 100).round()}%',
      child: SizedBox.square(
        dimension: size.diameter,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: clamped),
          duration: LqMotion.of(context, LqMotion.slow),
          curve: LqMotion.springCurve,
          builder: (context, v, child) => CustomPaint(
            painter: _RingPainter(
              value: v.clamp(0.0, 1.0),
              stroke: size.stroke,
              track: c.surfaceSunken,
              start: c.accentTop,
              end: c.accentBottom,
            ),
            child: child,
          ),
          child: child == null
              ? null
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(size.stroke + 4),
                    child: FittedBox(fit: BoxFit.scaleDown, child: child),
                  ),
                ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.stroke,
    required this.track,
    required this.start,
    required this.end,
  });

  final double value, stroke;
  final Color track, start, end;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.shortestSide - stroke) / 2;
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );
    if (value <= 0) return;
    final sweep = 2 * math.pi * value;
    // The round cap pokes back past 12 o'clock; start the gradient a cap's
    // width earlier so the cap keeps the light starting color.
    final cap = stroke / 2 / radius;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        endAngle: math.max(sweep + cap * 2, 0.01),
        colors: [start, end],
        transform: GradientRotation(-math.pi / 2 - cap),
      ).createShader(rect);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, paint);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.stroke != stroke ||
      old.track != track ||
      old.start != start ||
      old.end != end;
}

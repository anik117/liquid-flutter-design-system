import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/glass.dart';
import '../../theme/lq_theme.dart';

/// The glass circle of [LqRefresh]: an arrow that turns over as you pull,
/// a ring that fills toward the trigger point, then a spinner while the
/// refresh runs.
class RefreshBubble extends StatelessWidget {
  const RefreshBubble({
    super.key,
    required this.progress,
    required this.refreshing,
    required this.spin,
  });

  static const size = 40.0;

  /// Pull progress: 1 at the trigger distance.
  final double progress;

  /// Shows the spinner instead of the arrow and ring.
  final bool refreshing;

  /// Spinner rotation, 0…1 per turn.
  final Animation<double> spin;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final p = progress.clamp(0.0, 1.0);
    final armed = p >= 1;
    return Semantics(
      label: refreshing ? 'Refreshing' : null,
      liveRegion: refreshing,
      child: LqGlass(
        child: SizedBox.square(
          dimension: size,
          child: refreshing
              ? RotationTransition(
                  turns: spin,
                  child: CustomPaint(
                    painter: _Arc(from: 0, sweep: 0.72, color: c.accent, track: null),
                  ),
                )
              : CustomPaint(
                  painter: _Arc(from: 0, sweep: p, color: c.accent, track: c.separator),
                  child: Center(
                    child: Transform.rotate(
                      angle: p * math.pi,
                      child: Icon(
                        RemixIcons.arrow_down_line,
                        size: 18,
                        color: armed ? c.accent : c.iconSecondary,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _Arc extends CustomPainter {
  _Arc({required this.from, required this.sweep, required this.color, required this.track});

  final double from, sweep;
  final Color color;
  final Color? track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(5);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    if (track != null) canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track!);
    if (sweep > 0) {
      canvas.drawArc(rect, -math.pi / 2 + from * math.pi * 2, sweep * math.pi * 2, false,
          paint..color = color);
    }
  }

  @override
  bool shouldRepaint(_Arc old) =>
      old.sweep != sweep || old.color != color || old.track != track;
}

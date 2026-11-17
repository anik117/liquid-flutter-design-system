import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The Liquid Glass rim light, ported from BoardUI's conic stroke: bright
/// along the top edge where the light is, shaded down both sides where the
/// glass turns away, and a weaker bounce along the bottom. It never rotates;
/// a real edge just sits there catching the room. Achromatic on purpose.
class LqGlassRimPainter extends CustomPainter {
  const LqGlassRimPainter({
    required this.radius,
    required this.highlight,
    required this.shade,
    this.width = 1.5,
  });

  final double radius;
  final Color highlight;
  final Color shade;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final dim = highlight.withValues(alpha: highlight.a * 0.12);
    final bounce = highlight.withValues(alpha: highlight.a * 0.6);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = SweepGradient(
        // CSS conic gradients start at 12 o'clock; Flutter's start at 3.
        transform: const GradientRotation(-math.pi / 2),
        colors: [highlight, shade, dim, bounce, dim, shade, highlight],
        stops: const [0, 70 / 360, 140 / 360, 0.5, 220 / 360, 290 / 360, 1],
      ).createShader(rect);
    final r = math.min(radius, size.shortestSide / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(width / 2), Radius.circular(r)),
      paint,
    );
  }

  @override
  bool shouldRepaint(LqGlassRimPainter old) =>
      old.radius != radius ||
      old.highlight != highlight ||
      old.shade != shade ||
      old.width != width;
}

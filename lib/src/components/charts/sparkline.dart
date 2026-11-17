import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';
import 'chart_parts.dart';
import 'chart_scale.dart';

/// A tiny inline trend line with an end dot and no axes, for list rows and
/// stat tiles, e.g. miles over the last 14 days. It draws in once and
/// morphs when the values change.
class LqSparkline extends StatelessWidget {
  const LqSparkline({
    super.key,
    required this.values,
    this.color,
    this.width = 64,
    this.height = 24,
    this.fill = true,
    this.semanticLabel,
  });

  /// The points, oldest first.
  final List<double> values;

  /// Line color. Defaults to the brand accent; pass `lq.colors.caution`
  /// for a falling trend.
  final Color? color;

  /// Size of the line. Pass `double.infinity` as [width] to fill a tile.
  final double width, height;

  /// Adds the soft fill under the line.
  final bool fill;

  /// Read to screen readers, e.g. "Miles last 14 days, trending up".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final lo = values.isEmpty ? 0.0 : values.reduce(math.min);
    final hi = values.isEmpty ? 1.0 : values.reduce(math.max);
    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      excludeSemantics: true,
      child: ChartEntrance(
        duration: LqMotion.slow * 2,
        builder: (context, t) => ChartMorph(
          // The low end rides along as a one-value series so it morphs too.
          frame: ChartFrame([values, [lo]], hi),
          builder: (context, f) => CustomPaint(
            size: Size(width, height),
            painter: _SparkPainter(
              values: f.series.first,
              lo: f.series[1].first,
              hi: f.max,
              progress: LqMotion.emphasized.transform(t),
              color: color ?? c.accent,
              ring: c.surface,
              fill: fill,
            ),
          ),
        ),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter({
    required this.values,
    required this.lo,
    required this.hi,
    required this.progress,
    required this.color,
    required this.ring,
    required this.fill,
  });

  final List<double> values;
  final double lo, hi, progress;
  final Color color, ring;
  final bool fill;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    const dot = 3.0;
    final w = size.width - dot * 2;
    final h = size.height - dot * 2;
    final span = math.max(hi - lo, 1e-9);
    final pts = [
      for (var i = 0; i < values.length; i++)
        Offset(dot + w * i / (values.length - 1), dot + h * (1 - (values[i] - lo) / span)),
    ];
    final line = ChartPaint.smooth(pts);
    final metric = line.computeMetrics().first;
    final tip = metric.getTangentForOffset(metric.length * progress)?.position ?? pts.last;
    if (fill) {
      final area = ChartPaint.smooth(pts)
        ..lineTo(pts.last.dx, size.height)
        ..lineTo(pts.first.dx, size.height)
        ..close();
      canvas.save();
      canvas.clipRect(Rect.fromLTRB(0, 0, tip.dx, size.height));
      canvas.drawPath(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0)],
          ).createShader(Offset.zero & size),
      );
      canvas.restore();
    }
    canvas.drawPath(
      ChartPaint.trim(line, progress),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.75
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(tip, dot + 1, Paint()..color = ring);
    canvas.drawCircle(tip, dot - 0.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SparkPainter old) => true;
}

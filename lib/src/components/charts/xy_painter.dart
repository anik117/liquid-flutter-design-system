import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../tokens/colors.dart';
import 'chart_parts.dart';
import 'chart_scale.dart';

/// Where a line or area chart sits: pill strip on top, plot, label row.
class XYLayout {
  XYLayout(Size size, this.count, {required double top, required double labels})
    : plot = Rect.fromLTRB(pad, top, size.width - pad, size.height - labels);

  /// Keeps end dots inside the chart.
  static const pad = 6.0;
  final Rect plot;

  /// Number of x positions (labels).
  final int count;

  double get step => count < 2 ? 0 : plot.width / (count - 1);
  double x(int i) => count < 2 ? plot.center.dx : plot.left + step * i;

  /// Nearest x position, limited to [limit] points that have data.
  int? indexAt(Offset p, int limit) {
    if (limit <= 0) return null;
    if (count < 2) return 0;
    return ((p.dx - plot.left) / step).round().clamp(0, limit - 1);
  }
}

/// Paints one or more series as smooth lines with optional soft area fills,
/// drawn in along their length, plus the scrub guide and dots.
class XYPainter extends CustomPainter {
  XYPainter({
    required this.layout,
    required this.frame,
    required this.progress,
    required this.colors,
    required this.tones,
    required this.dashed,
    required this.fills,
    required this.labels,
    required this.labelStyle,
    required this.scaler,
    this.stacked = false,
    this.picked,
  });

  final XYLayout layout;
  final ChartFrame frame;

  /// Draw-in progress along the lines, 0…1.
  final double progress;
  final LqColors colors;
  final List<Color> tones;
  final List<bool> dashed, fills;
  final List<String> labels;
  final TextStyle labelStyle;
  final TextScaler scaler;

  /// Stacks series on top of each other (stacked area).
  final bool stacked;
  final int? picked;

  List<List<Offset>> _points() {
    final plot = layout.plot;
    final k = plot.height / math.max(frame.max, 1e-9);
    final out = <List<Offset>>[];
    List<double>? below;
    for (final s in frame.series) {
      final v = [
        for (var i = 0; i < s.length; i++)
          s[i] + (stacked && below != null && i < below.length ? below[i] : 0),
      ];
      out.add([for (var i = 0; i < v.length; i++) Offset(layout.x(i), plot.bottom - v[i] * k)]);
      below = v;
    }
    return out;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = colors;
    final plot = layout.plot;
    ChartPaint.dashedLine(canvas, Offset(0, plot.bottom), Offset(size.width, plot.bottom), c.border);
    final pts = _points();
    if (pts.isEmpty || pts.first.isEmpty) return;

    // Where the primary line's tip is, so fills reveal along with it.
    final lead = ChartPaint.smooth(pts.first).computeMetrics().toList();
    var tipX = size.width;
    if (progress < 1 && lead.isNotEmpty) {
      final m = lead.first;
      tipX = m.getTangentForOffset(m.length * progress)?.position.dx ?? 0;
    }

    for (var s = pts.length - 1; s >= 0; s--) {
      final p = pts[s];
      if (p.isEmpty) continue;
      final color = tones[s];
      final line = ChartPaint.smooth(p);
      if (fills[s]) {
        final area = ChartPaint.smooth(p);
        if (stacked && s > 0 && pts[s - 1].isNotEmpty) {
          ChartPaint.smooth(pts[s - 1].take(p.length).toList().reversed.toList(),
              into: area, connect: true);
        } else {
          area
            ..lineTo(p.last.dx, plot.bottom)
            ..lineTo(p.first.dx, plot.bottom);
        }
        area.close();
        canvas.save();
        canvas.clipRect(Rect.fromLTRB(0, 0, tipX, size.height));
        canvas.drawPath(
          area,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: stacked ? 0.42 : 0.24),
                color.withValues(alpha: stacked ? 0.12 : 0),
              ],
            ).createShader(plot),
        );
        canvas.restore();
      }
      final drawn = ChartPaint.trim(line, progress);
      canvas.drawPath(
        dashed[s] ? ChartPaint.dashed(drawn) : drawn,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = dashed[s] ? 2 : 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    final i = picked;
    if (i != null) {
      final x = layout.x(i);
      canvas.drawLine(Offset(x, plot.top - 4), Offset(x, plot.bottom),
          Paint()
            ..color = Color.lerp(c.surface, c.accent, 0.45)!
            ..strokeWidth = 1.5);
      for (var s = 0; s < pts.length; s++) {
        if (i >= pts[s].length) continue;
        canvas.drawCircle(pts[s][i], 6, Paint()..color = c.surface);
        canvas.drawCircle(pts[s][i], 4, Paint()..color = tones[s]);
      }
    }

    final step = ChartPaint.labelStep(labels, labelStyle, scaler, layout.step);
    for (var j = 0; j < math.min(layout.count, labels.length); j++) {
      final strong = j == picked;
      if (!ChartScale.showLabel(j, step, [picked])) continue;
      final edge = j == 0 ? 0.0 : (j == layout.count - 1 ? 1.0 : 0.5);
      ChartPaint.text(
        canvas,
        labels[j],
        labelStyle.copyWith(color: strong ? c.textPrimary : c.textSecondary),
        scaler,
        Offset(layout.x(j) + (edge - 0.5) * 2 * XYLayout.pad, plot.bottom + 6),
        alignX: edge,
      );
    }
  }

  @override
  bool shouldRepaint(XYPainter old) => true;
}

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../tokens/colors.dart';
import 'chart_parts.dart';
import 'chart_scale.dart';

/// Where everything sits in a vertical bar chart: a strip on top for the
/// value pill, the plot, and the label row under the dashed baseline.
class BarLayout {
  BarLayout(Size size, this.count, {required double top, required double labels, this.groups = 1})
    : plot = Rect.fromLTRB(0, top, size.width, size.height - labels);

  /// The bars' area; its bottom edge is the baseline.
  final Rect plot;

  /// Number of bars (or groups).
  final int count;

  /// Bars side by side in each slot (grouped mode), else 1.
  final int groups;

  double get slot => plot.width / math.max(count, 1);
  double center(int i) => slot * (i + 0.5);

  /// Width of one whole slot's bar or group.
  double get groupWidth => math.min(slot * (groups > 1 ? 0.76 : 0.58), groups > 1 ? 48 : 32);

  static const gap = 2.0;
  double get barWidth => (groupWidth - gap * (groups - 1)) / groups;

  int? indexAt(Offset p) {
    if (count == 0 || p.dx < 0 || p.dx > plot.width) return null;
    return (p.dx / slot).floor().clamp(0, count - 1);
  }
}

/// Paints vertical bars: single, stacked or grouped series, the tinted band
/// behind the picked bar, the dashed baseline and the labels.
class BarsPainter extends CustomPainter {
  BarsPainter({
    required this.layout,
    required this.frame,
    required this.entrance,
    required this.dim,
    required this.colors,
    required this.tones,
    required this.labels,
    required this.labelStyle,
    required this.scaler,
    this.stacked = true,
    this.picked,
    this.highlighted,
  });

  final BarLayout layout;
  final ChartFrame frame;

  /// First-view growth, 0…1 (staggered per bar).
  final double entrance;

  /// How far unpicked bars have stepped back to grey, 0…1.
  final double dim;
  final LqColors colors;

  /// One color per series.
  final List<Color> tones;
  final List<String> labels;
  final TextStyle labelStyle;
  final TextScaler scaler;
  final bool stacked;
  final int? picked, highlighted;

  Color _color(int i, int s) {
    final c = colors;
    final base = tones[s];
    if (picked != null && picked != i) {
      return Color.lerp(base, ChartScale.stepBack(c), dim * (tones.length > 1 ? 0.85 : 1))!;
    }
    // With a current period marked, the other bars step back to neutral so
    // the brand color lands on one bar only.
    if (picked == null && highlighted != null && highlighted != i) {
      return tones.length > 1 ? Color.lerp(base, c.surface, 0.45)! : ChartScale.stepBack(c);
    }
    return base;
  }

  void _bar(Canvas canvas, Rect r, Color color, double radius) {
    if (r.height <= 0) return;
    canvas.drawRRect(
      RRect.fromRectAndCorners(r,
          topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, Color.lerp(color, colors.surface, 0.35)!],
        ).createShader(r),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = colors;
    final plot = layout.plot;
    final n = layout.count;
    final scale = plot.height / math.max(frame.max, 1e-9);

    if (picked != null && picked! < n) {
      final band = Rect.fromLTWH(layout.slot * picked! + 2, plot.top - 2, layout.slot - 4, plot.height + 2);
      canvas.drawRRect(RRect.fromRectAndRadius(band, const Radius.circular(8)),
          Paint()..color = Color.lerp(c.surface, c.accentSoft, dim)!);
    }
    ChartPaint.dashedLine(canvas, plot.bottomLeft, plot.bottomRight, c.border);

    final bw = layout.barWidth;
    final radius = math.min(6.0, bw / 2);
    for (var i = 0; i < n; i++) {
      final g = ChartScale.stagger(entrance, i, n);
      if (stacked) {
        final left = layout.center(i) - bw / 2;
        var y = plot.bottom;
        final segs = <(Rect, Color)>[];
        for (var s = 0; s < frame.series.length; s++) {
          final v = i < frame.series[s].length ? math.max(0.0, frame.series[s][i]) : 0.0;
          final h = v * scale * g;
          if (h <= 0) continue;
          // A hairline of surface between stacked segments.
          final gap = segs.isEmpty ? 0.0 : 1.5;
          segs.add((Rect.fromLTRB(left, y - h, left + bw, y - gap), _color(i, s)));
          y -= h;
        }
        final whole = Rect.fromLTRB(left, y, left + bw, plot.bottom);
        canvas.save();
        canvas.clipRRect(RRect.fromRectAndCorners(whole,
            topLeft: Radius.circular(radius), topRight: Radius.circular(radius)));
        for (final (r, color) in segs) {
          _bar(canvas, r, color, 0);
        }
        canvas.restore();
      } else {
        final start = layout.center(i) - layout.groupWidth / 2;
        for (var s = 0; s < frame.series.length; s++) {
          final v = i < frame.series[s].length ? math.max(0.0, frame.series[s][i]) : 0.0;
          final left = start + s * (bw + BarLayout.gap);
          _bar(canvas, Rect.fromLTRB(left, plot.bottom - v * scale * g, left + bw, plot.bottom),
              _color(i, s), radius);
        }
      }
    }

    final step = ChartPaint.labelStep(labels, labelStyle, scaler, layout.slot);
    for (var i = 0; i < math.min(n, labels.length); i++) {
      final current = picked ?? highlighted;
      final strong = i == current;
      if (!ChartScale.showLabel(i, step, [current])) continue;
      ChartPaint.text(
        canvas,
        labels[i],
        labelStyle.copyWith(color: strong ? c.textPrimary : c.textSecondary),
        scaler,
        Offset(layout.center(i), plot.bottom + 6),
      );
    }
  }

  @override
  bool shouldRepaint(BarsPainter old) => true;
}

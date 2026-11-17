import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import '../feedback/badge.dart';
import 'chart_legend.dart';
import 'chart_scale.dart';

/// One slice of a [LqRingChart], e.g. Business 7,905 miles.
class LqRingSegment {
  const LqRingSegment({required this.label, required this.value, this.tone = LqTone.accent});

  /// Slice name, shown in the legend.
  final String label;

  /// Slice size; slices are drawn in proportion to the total.
  final double value;

  /// Color role: accent for the main slice, neutral and caution for others.
  final LqTone tone;
}

/// A donut of segments that sweeps in on first view and morphs to new
/// values, with an optional center (an [LqAmount] or text) and legend rows
/// with values and shares below.
class LqRingChart extends StatelessWidget {
  const LqRingChart({
    super.key,
    required this.segments,
    this.center,
    this.size = 180,
    this.thickness = 18,
    this.showLegend = true,
    this.valueLabel,
    this.semanticLabel,
  });

  /// The slices, clockwise from 12 o'clock.
  final List<LqRingSegment> segments;

  /// Shown inside the ring, e.g. the total miles.
  final Widget? center;

  /// Ring diameter and stroke width.
  final double size, thickness;

  /// Lists each segment under the ring with its value and share.
  final bool showLegend;

  /// Formats values for the legend and screen readers.
  final String Function(double value)? valueLabel;

  /// What the ring shows, e.g. "Miles by purpose".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final fmt = valueLabel ?? ChartScale.number;
    final total = segments.fold(0.0, (s, e) => s + math.max(0.0, e.value));
    String share(double v) => total <= 0 ? '0%' : '${(v / total * 100).round()}%';
    final tones = [for (final s in segments) ChartScale.tone(c, s.tone)];
    final summary = [for (final s in segments) '${s.label} ${fmt(s.value)}, ${share(s.value)}'].join('; ');

    final ring = ChartEntrance(
      duration: LqMotion.slow * 2,
      builder: (context, t) => ChartMorph(
        frame: ChartFrame([
          [for (final s in segments) math.max(0.0, s.value)],
        ], total),
        builder: (context, f) => CustomPaint(
          size: Size.square(size),
          painter: _RingPainter(
            values: f.series.first,
            sweep: LqMotion.emphasized.transform(t),
            tones: tones,
            track: c.surfaceSunken,
            thickness: thickness,
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      label: semanticLabel,
      value: summary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox.square(
              dimension: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ring,
                  if (center != null)
                    SizedBox.square(
                      // The largest square that fits inside the hole.
                      dimension: (size - thickness * 2) * 0.7,
                      child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: center)),
                    ),
                ],
              ),
            ),
          ),
          if (showLegend) ...[
            const SizedBox(height: LqSpace.x4),
            ExcludeSemantics(
              child: LqChartLegend(
                axis: Axis.vertical,
                entries: [
                  for (var i = 0; i < segments.length; i++)
                    LqLegendEntry(
                      label: segments[i].label,
                      color: tones[i],
                      value: '${fmt(segments[i].value)} · ${share(segments[i].value)}',
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.values,
    required this.sweep,
    required this.tones,
    required this.track,
    required this.thickness,
  });

  final List<double> values;
  final double sweep, thickness;
  final List<Color> tones;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final r = (size.shortestSide - thickness) / 2;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: r);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;
    canvas.drawCircle(rect.center, r, stroke..color = track);
    final total = values.fold(0.0, (a, b) => a + b);
    if (total <= 0) return;
    final shown = values.where((v) => v > 0).length;
    final gap = shown > 1 ? 3 / r : 0.0;
    var start = -math.pi / 2;
    final end = start + math.pi * 2 * sweep;
    for (var i = 0; i < values.length; i++) {
      final a = math.pi * 2 * values[i] / total;
      final from = start + gap / 2;
      final to = math.min(start + a - gap / 2, end);
      if (to > from) canvas.drawArc(rect, from, to - from, false, stroke..color = tones[i]);
      start += a;
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => true;
}

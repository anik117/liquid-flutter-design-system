import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../tokens/colors.dart';
import 'chart_parts.dart';
import 'chart_scale.dart';

/// Short names used by the heatmap's labels and pill.
const heatmapMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const heatmapDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Calendar grid geometry: one column per week (Mon at the top), the
/// newest week on the right, a month row above and weekday labels left.
class HeatmapLayout {
  HeatmapLayout({
    required this.width,
    required this.weeks,
    required this.end,
    required this.days,
    required this.labelWidth,
    required this.top,
  }) : cell = math.min(28, (width - labelWidth - gap * (weeks - 1)) / weeks);

  static const gap = 3.0;
  final double width, labelWidth, top, cell;
  final int weeks, days;

  /// The newest day (the last value).
  final DateTime end;

  double get height => top + cell * 7 + gap * 6;

  /// Grid slot (0 at the top-left Monday) of value [k], or negative when
  /// it falls before the first column.
  int slotOf(int k) => (weeks - 1) * 7 + (end.weekday - 1) - (days - 1 - k);

  Rect cellRect(int k) {
    final s = slotOf(k);
    final x = labelWidth + (s ~/ 7) * (cell + gap);
    return Rect.fromLTWH(x, top + (s % 7) * (cell + gap), cell, cell);
  }

  DateTime dateOf(int k) =>
      DateTime(end.year, end.month, end.day - (days - 1 - k));

  int? indexAt(Offset p) {
    final col = ((p.dx - labelWidth) / (cell + gap)).floor();
    final row = ((p.dy - top) / (cell + gap)).floor();
    if (col < 0 || col >= weeks || row < 0 || row > 6) return null;
    final k = col * 7 + row - ((weeks - 1) * 7 + (end.weekday - 1)) + days - 1;
    return k >= 0 && k < days && slotOf(k) >= 0 ? k : null;
  }
}

/// Paints the heatmap cells tinted along the accent ramp, plus labels.
class HeatmapPainter extends CustomPainter {
  HeatmapPainter({
    required this.layout,
    required this.values,
    required this.entrance,
    required this.colors,
    required this.labelStyle,
    required this.scaler,
    this.picked,
  });

  final HeatmapLayout layout;
  final List<double> values;

  /// First-view progress, staggered by week column.
  final double entrance;
  final LqColors colors;
  final TextStyle labelStyle;
  final TextScaler scaler;
  final int? picked;

  @override
  void paint(Canvas canvas, Size size) {
    final c = colors;
    final peak = values.fold(0.0, math.max);
    final style = labelStyle.copyWith(color: c.textSecondary);
    for (final row in const [0, 2, 4]) {
      final y = layout.top + row * (layout.cell + HeatmapLayout.gap) + layout.cell / 2;
      ChartPaint.text(canvas, heatmapDays[row].substring(0, 1), style, scaler, Offset(0, y),
          alignX: 0, alignY: 0.5);
    }
    var lastMonth = -1;
    for (var k = 0; k < values.length; k++) {
      if (layout.slotOf(k) < 0) continue;
      final r = layout.cellRect(k);
      final date = layout.dateOf(k);
      if (date.month != lastMonth && date.weekday == DateTime.monday) {
        lastMonth = date.month;
        ChartPaint.text(canvas, heatmapMonths[date.month - 1], style, scaler,
            Offset(r.left, 0), alignX: 0);
      }
      final g = ChartScale.stagger(entrance, layout.slotOf(k) ~/ 7, layout.weeks).clamp(0.0, 1.0);
      final v = values[k];
      final color = v <= 0
          ? c.surfaceSunken
          : Color.lerp(c.accentSoft, c.accent, 0.15 + 0.85 * (v / math.max(peak, 1e-9)))!;
      final cell = Rect.fromCenter(center: r.center, width: r.width * (0.5 + g / 2), height: r.height * (0.5 + g / 2));
      final rr = RRect.fromRectAndRadius(cell, Radius.circular(layout.cell * 0.25));
      canvas.drawRRect(rr, Paint()..color = Color.lerp(c.surface, color, g)!);
      if (k == picked) {
        canvas.drawRRect(rr.inflate(1.5), Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = c.textPrimary);
      }
    }
  }

  @override
  bool shouldRepaint(HeatmapPainter old) => true;
}

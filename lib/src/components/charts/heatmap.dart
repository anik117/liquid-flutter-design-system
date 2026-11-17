import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/typography.dart';
import 'chart_parts.dart';
import 'chart_pill.dart';
import 'chart_scale.dart';
import 'heatmap_painter.dart';

/// A calendar heatmap of daily activity, e.g. drives per day over the last
/// 12 weeks. Cells tint along the accent ramp by intensity; tap or drag
/// across a day to see its value in a pill. Weeks run left to right,
/// Monday at the top.
class LqHeatmap extends StatefulWidget {
  const LqHeatmap({
    super.key,
    required this.values,
    required this.end,
    this.weeks = 12,
    this.valueLabel,
    this.onSelected,
    this.semanticLabel,
  });

  /// One value per day, oldest first; the last one is [end].
  final List<double> values;

  /// The newest day shown.
  final DateTime end;

  /// Number of week columns.
  final int weeks;

  /// Formats a day's value, e.g. `(v) => '${v.round()} drives'`.
  final String Function(double value)? valueLabel;

  /// Called with the picked day, or null when the pick clears.
  final ValueChanged<DateTime?>? onSelected;

  /// What the grid shows, e.g. "Drives per day".
  final String? semanticLabel;

  @override
  State<LqHeatmap> createState() => _LqHeatmapState();
}

class _LqHeatmapState extends State<LqHeatmap> {
  int? _picked;

  String _day(DateTime d) =>
      '${heatmapDays[d.weekday - 1]}, ${heatmapMonths[d.month - 1]} ${d.day}';

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final scaler = MediaQuery.textScalerOf(context);
    final caption = LqTypography.numeric(lq.type.caption);
    final fmt = widget.valueLabel ?? ChartScale.number;
    final values = widget.values;
    final total = values.fold(0.0, (a, b) => a + b);
    final peak = values.isEmpty ? 0.0 : values.reduce(math.max);

    return LayoutBuilder(builder: (context, box) {
      final layout = HeatmapLayout(
        width: box.maxWidth,
        weeks: widget.weeks,
        end: widget.end,
        days: values.length,
        labelWidth: ChartPaint.label('M', caption, scaler).width + 8,
        top: ChartPaint.lineHeight(caption, scaler) + 6,
      );
      final picked = _picked != null && _picked! < values.length ? _picked : null;
      final busiest = values.indexOf(peak);
      return Semantics(
        container: true,
        label: widget.semanticLabel,
        value: values.isEmpty
            ? 'No data'
            : 'Total ${fmt(total)}. Busiest ${_day(layout.dateOf(busiest))}, ${fmt(peak)}',
        child: ChartPicker(
          indexAt: layout.indexAt,
          picked: picked,
          onPick: (i) {
            setState(() => _picked = i);
            widget.onSelected?.call(i == null ? null : layout.dateOf(i));
          },
          child: SizedBox(
            width: box.maxWidth,
            height: layout.height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ChartEntrance(
                  duration: ChartScale.entrance(widget.weeks),
                  builder: (context, t) => CustomPaint(
                    size: Size(box.maxWidth, layout.height),
                    painter: HeatmapPainter(
                      layout: layout,
                      values: values,
                      entrance: t,
                      colors: lq.colors,
                      labelStyle: caption,
                      scaler: scaler,
                      picked: picked,
                    ),
                  ),
                ),
                if (picked != null)
                  Positioned.fill(
                    child: ChartPillSlot(
                      x: layout.cellRect(picked).center.dx,
                      bottom: layout.cellRect(picked).top - 6,
                      child: LqChartPill(
                        title: _day(layout.dateOf(picked)),
                        value: fmt(values[picked]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

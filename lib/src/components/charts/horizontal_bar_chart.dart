import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/typography.dart';
import 'chart_scale.dart';

/// One row of a [LqHorizontalBarChart], e.g. DoorDash $1.32 per mile.
class LqBarItem {
  const LqBarItem({required this.label, required this.value});

  /// Row name, shown on the left.
  final String label;

  /// Bar length, relative to the largest row.
  final double value;
}

/// Ranked horizontal bars: label on the left, bar, value on the right, e.g.
/// earnings per mile by platform. The top row is drawn in the accent, the
/// rest in neutral grey. Bars grow in one after another on first view and
/// morph when values change.
class LqHorizontalBarChart extends StatelessWidget {
  const LqHorizontalBarChart({
    super.key,
    required this.items,
    this.sort = true,
    this.valueLabel,
    this.labelWidth = 96,
    this.semanticLabel,
  });

  /// The rows.
  final List<LqBarItem> items;

  /// Orders rows from largest to smallest.
  final bool sort;

  /// Formats the value on the right, e.g. `(v) => '\$${v.toStringAsFixed(2)}'`.
  final String Function(double value)? valueLabel;

  /// Width of the label column.
  final double labelWidth;

  /// What the chart ranks, e.g. "Earnings per mile by platform".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final fmt = valueLabel ?? ChartScale.number;
    final rows = [...items];
    if (sort) rows.sort((a, b) => b.value.compareTo(a.value));
    final peak = rows.fold(0.0, (m, r) => math.max(m, r.value));
    final top = rows.indexWhere((r) => r.value == peak);
    final numeric = LqTypography.numeric(lq.type.subheadMedium);

    return Semantics(
      container: true,
      label: semanticLabel,
      value: [for (final r in rows) '${r.label} ${fmt(r.value)}'].join(', '),
      child: ExcludeSemantics(
        child: ChartEntrance(
          duration: ChartScale.entrance(rows.length),
          builder: (context, t) => ChartMorph(
            frame: ChartFrame([
              [for (final r in rows) r.value],
            ], peak <= 0 ? 1 : peak),
            builder: (context, f) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < rows.length; i++)
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 36),
                    child: Row(
                      children: [
                        SizedBox(
                          width: labelWidth,
                          child: Text(rows[i].label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: lq.type.subhead.copyWith(color: c.textPrimary)),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: (f.series.first[i] / f.max *
                                      ChartScale.stagger(t, i, rows.length))
                                  .clamp(0.0, 1.0),
                              child: Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(LqRadius.full),
                                  gradient: LinearGradient(colors: [
                                    if (i == top) ...[
                                      Color.lerp(c.accentTop, c.surface, 0.35)!,
                                      c.accentTop,
                                    ] else ...[
                                      ChartScale.stepBack(c),
                                      ChartScale.stepBack(c),
                                    ],
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: LqSpace.x3),
                        Text(fmt(rows[i].value),
                            style: numeric.copyWith(
                                color: i == top ? c.textPrimary : c.textSecondary)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

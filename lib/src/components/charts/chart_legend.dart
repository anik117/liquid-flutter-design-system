import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/typography.dart';

/// One key in a chart legend or value pill: a colored dot (or dash), a
/// label and an optional value, e.g. "● Business 7,905 mi".
class LqLegendEntry {
  const LqLegendEntry({
    required this.label,
    required this.color,
    this.value,
    this.dashed = false,
  });

  /// Series or segment name.
  final String label;

  /// The mark's color, usually from the series tone.
  final Color color;

  /// Optional value shown after the label.
  final String? value;

  /// Draws a short dash instead of a dot, for dashed comparison lines.
  final bool dashed;
}

/// A chart legend. [Axis.horizontal] wraps compact keys on one or more
/// lines above a chart; [Axis.vertical] lists rows with values aligned on
/// the right, as under a ring chart.
class LqChartLegend extends StatelessWidget {
  const LqChartLegend({
    super.key,
    required this.entries,
    this.axis = Axis.horizontal,
  });

  /// The keys, in series order.
  final List<LqLegendEntry> entries;

  /// Wrap in a row, or list one per line.
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    if (axis == Axis.horizontal) {
      final style = lq.type.footnote.copyWith(color: c.textSecondary);
      return Wrap(
        spacing: LqSpace.x4,
        runSpacing: LqSpace.x1,
        children: [
          for (final e in entries)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LegendMark(color: e.color, dashed: e.dashed),
                const SizedBox(width: 6),
                Text(e.value == null ? e.label : '${e.label} ${e.value}', style: style),
              ],
            ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < entries.length; i++)
          Container(
            constraints: const BoxConstraints(minHeight: LqSize.control),
            decoration: BoxDecoration(
              border: i == 0
                  ? null
                  : Border(top: BorderSide(color: c.separator, width: 0.5)),
            ),
            child: Row(
              children: [
                LegendMark(color: entries[i].color, dashed: entries[i].dashed, size: 10),
                const SizedBox(width: LqSpace.x3),
                Expanded(
                  child: Text(entries[i].label,
                      style: lq.type.body.copyWith(color: c.textPrimary)),
                ),
                if (entries[i].value != null)
                  Text(
                    entries[i].value!,
                    style: LqTypography.numeric(lq.type.body)
                        .copyWith(color: c.textSecondary),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The small dot or dash that keys a series.
class LegendMark extends StatelessWidget {
  const LegendMark({super.key, required this.color, this.dashed = false, this.size = 8});

  /// Series color.
  final Color color;

  /// A short dash for dashed lines.
  final bool dashed;

  /// Dot diameter.
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: dashed ? size * 1.6 : size,
    height: dashed ? 2.5 : size,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(size),
    ),
  );
}

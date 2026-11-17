import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import 'chart_legend.dart';
import 'chart_scale.dart';
import 'xy_view.dart';

/// A filled area over time, e.g. cumulative deductions. Pass two or more
/// [series] to stack them (Business under Personal); each layer gets its
/// own gradient fill. Draws in, morphs and scrubs like [LqLineChart].
class LqAreaChart extends StatelessWidget {
  const LqAreaChart({
    super.key,
    required this.series,
    required this.labels,
    this.valueLabel,
    this.onSelected,
    this.height = 200,
    this.semanticLabel,
  });

  /// Layers from the baseline up. One series draws a single area.
  final List<LqChartSeries> series;

  /// One label per x position.
  final List<String> labels;

  /// Formats values for the pill and screen readers.
  final String Function(double value)? valueLabel;

  /// Called with the scrubbed index, or null when the finger lifts.
  final ValueChanged<int?>? onSelected;

  /// Height of the plot, including the pill strip and labels.
  final double height;

  /// What the chart shows, e.g. "Deductions so far".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final stacked = series.length > 1;
    final chart = XYView(
      series: series,
      labels: labels,
      height: height,
      stacked: stacked,
      valueLabel: valueLabel ?? ChartScale.number,
      fills: [for (final _ in series) true],
      onSelected: onSelected,
      semanticLabel: semanticLabel,
    );
    if (!stacked) return chart;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        LqChartLegend(entries: [
          for (final s in series) LqLegendEntry(label: s.label, color: ChartScale.tone(c, s.tone)),
        ]),
        const SizedBox(height: LqSpace.x2),
        chart,
      ],
    );
  }
}

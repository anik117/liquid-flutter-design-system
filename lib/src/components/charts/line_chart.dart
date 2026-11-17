import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../feedback/badge.dart';
import 'chart_legend.dart';
import 'chart_scale.dart';
import 'xy_view.dart';

/// One series over time with a soft area fill, plus an optional dashed
/// comparison, e.g. miles this year vs last year. The line draws itself in
/// on first view and morphs between datasets. Drag across to scrub: a
/// vertical guide, dots and a value pill follow the finger.
class LqLineChart extends StatelessWidget {
  const LqLineChart({
    super.key,
    required this.values,
    required this.labels,
    this.comparison,
    this.seriesLabel = 'This year',
    this.comparisonLabel = 'Last year',
    this.valueLabel,
    this.onSelected,
    this.height = 200,
    this.semanticLabel,
  });

  /// The main series; may be shorter than [labels] (a year in progress).
  final List<double> values;

  /// One label per x position, e.g. "Jan" … "Dec".
  final List<String> labels;

  /// A dashed grey series to compare against.
  final List<double>? comparison;

  /// Legend and pill names for the two series.
  final String seriesLabel, comparisonLabel;

  /// Formats values for the pill and screen readers.
  final String Function(double value)? valueLabel;

  /// Called with the scrubbed index, or null when the finger lifts.
  final ValueChanged<int?>? onSelected;

  /// Height of the plot, including the pill strip and labels.
  final double height;

  /// What the chart shows, e.g. "Miles by month".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final hasComparison = comparison != null;
    final series = [
      LqChartSeries(label: seriesLabel, values: values),
      if (hasComparison)
        LqChartSeries(label: comparisonLabel, values: comparison!, tone: LqTone.neutral, dashed: true),
    ];
    final chart = XYView(
      series: series,
      labels: labels,
      height: height,
      valueLabel: valueLabel ?? ChartScale.number,
      fills: [true, if (hasComparison) false],
      onSelected: onSelected,
      semanticLabel: semanticLabel,
    );
    if (!hasComparison) return chart;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        LqChartLegend(entries: [
          for (final s in series)
            LqLegendEntry(label: s.label, color: ChartScale.tone(c, s.tone), dashed: s.dashed),
        ]),
        const SizedBox(height: LqSpace.x2),
        chart,
      ],
    );
  }
}

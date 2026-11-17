import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import 'chart_legend.dart';
import 'chart_scale.dart';
import 'xy_view.dart';

/// Two to four lines on one axis with a legend, e.g. earnings per mile by
/// platform. Scrubbing shows every series' value at the picked x.
class LqMultiLineChart extends StatelessWidget {
  const LqMultiLineChart({
    super.key,
    required this.series,
    required this.labels,
    this.valueLabel,
    this.onSelected,
    this.height = 200,
    this.semanticLabel,
  });

  /// The lines, first drawn on top. Give each a distinct tone.
  final List<LqChartSeries> series;

  /// One label per x position.
  final List<String> labels;

  /// Formats values for the pill and screen readers.
  final String Function(double value)? valueLabel;

  /// Called with the scrubbed index, or null when the finger lifts.
  final ValueChanged<int?>? onSelected;

  /// Height of the plot, including the pill strip and labels.
  final double height;

  /// What the chart shows, e.g. "Earnings per mile by platform".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    assert(series.isNotEmpty && series.length <= 4, 'Use 1 to 4 series.');
    final c = context.lq.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        LqChartLegend(entries: [
          for (final s in series)
            LqLegendEntry(label: s.label, color: ChartScale.tone(c, s.tone), dashed: s.dashed),
        ]),
        const SizedBox(height: LqSpace.x2),
        XYView(
          series: series,
          labels: labels,
          height: height,
          valueLabel: valueLabel ?? ChartScale.number,
          fills: [for (final _ in series) false],
          onSelected: onSelected,
          semanticLabel: semanticLabel,
        ),
      ],
    );
  }
}

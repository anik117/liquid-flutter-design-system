import 'package:flutter/widgets.dart';

import 'bars_view.dart';
import 'chart_legend.dart';
import 'chart_scale.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';

/// Bars split into segments by series, e.g. Business / Personal / Commute
/// miles per month. Set [grouped] to put the series side by side instead.
/// Picking a bar shows a breakdown pill; a legend sits above the bars.
class LqStackedBarChart extends StatelessWidget {
  const LqStackedBarChart({
    super.key,
    required this.series,
    required this.labels,
    this.grouped = false,
    this.showLegend = true,
    this.highlighted,
    this.onSelected,
    this.valueLabel,
    this.height = 220,
    this.semanticLabel,
  });

  /// Segments from the baseline up (or left to right when grouped).
  final List<LqChartSeries> series;

  /// One short label per bar, e.g. "Jan".
  final List<String> labels;

  /// Side-by-side bars instead of stacks.
  final bool grouped;

  /// Shows the series legend above the chart.
  final bool showLegend;

  /// The current bar (this month), drawn strongest until one is picked.
  final int? highlighted;

  /// Called with the picked bar's index, or null when the pick clears.
  final ValueChanged<int?>? onSelected;

  /// Formats values for the pill and screen readers.
  final String Function(double value)? valueLabel;

  /// Height of the bars area, including the pill strip and labels.
  final double height;

  /// What the chart shows, e.g. "Miles by purpose".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLegend) ...[
          LqChartLegend(entries: [
            for (final s in series)
              LqLegendEntry(label: s.label, color: ChartScale.tone(c, s.tone)),
          ]),
          const SizedBox(height: LqSpace.x2),
        ],
        BarsView(
          series: series,
          labels: labels,
          height: height,
          stacked: !grouped,
          valueLabel: valueLabel ?? ChartScale.number,
          highlighted: highlighted,
          onSelected: onSelected,
          semanticLabel: semanticLabel,
        ),
      ],
    );
  }
}

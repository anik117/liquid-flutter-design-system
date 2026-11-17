import 'package:flutter/widgets.dart';

import 'bars_view.dart';
import 'chart_scale.dart';

/// Vertical bars with labels, e.g. deductions by month. Bars grow from the
/// baseline on first view and morph when the data changes. Tap or drag
/// across to pick a bar: a value pill floats above it and the others step
/// back to grey. [highlighted] marks the current period.
class LqBarChart extends StatelessWidget {
  const LqBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.highlighted,
    this.onSelected,
    this.valueLabel,
    this.height = 200,
    this.semanticLabel,
  });

  /// One value per bar.
  final List<double> values;

  /// One short label per bar, e.g. "Jan".
  final List<String> labels;

  /// The current bar (this month), drawn strongest until one is picked.
  final int? highlighted;

  /// Called with the picked bar's index, or null when the pick clears.
  final ValueChanged<int?>? onSelected;

  /// Formats values for the pill and screen readers, e.g. `(v) => '\$$v'`.
  final String Function(double value)? valueLabel;

  /// Total height, including the pill strip and labels.
  final double height;

  /// What the chart shows, e.g. "Deductions by month".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => BarsView(
    series: [LqChartSeries(label: semanticLabel ?? '', values: values)],
    labels: labels,
    height: height,
    valueLabel: valueLabel ?? ChartScale.number,
    highlighted: highlighted,
    onSelected: onSelected,
    semanticLabel: semanticLabel,
  );
}

import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'chart_data.dart';

class LineChartDemo extends StatefulWidget {
  const LineChartDemo({super.key});

  @override
  State<LineChartDemo> createState() => _LineChartDemoState();
}

class _LineChartDemoState extends State<LineChartDemo> {
  bool _dollars = false;

  @override
  Widget build(BuildContext context) {
    // 2026 at 72.5¢ / mi, 2025 at 70¢ / mi.
    final now = _dollars ? [for (final m in ChartData.miles2026) m * 0.725] : ChartData.miles2026;
    final then = _dollars ? [for (final m in ChartData.miles2025) m * 0.70] : ChartData.miles2025;
    return DemoColumn(
      children: [
        LqSection(
          title: 'This year vs last year',
          caption: 'Drag across to scrub. Switch the measure to watch the lines morph.',
          children: [
            LqSegmentedControl<bool>(
              segments: const [
                LqSegment(value: false, label: 'Miles'),
                LqSegment(value: true, label: 'Deductions'),
              ],
              value: _dollars,
              onChanged: (v) => setState(() => _dollars = v),
            ),
            LqCard(
              child: LqLineChart(
                values: now,
                comparison: then,
                labels: ChartData.months,
                seriesLabel: '2026',
                comparisonLabel: '2025',
                valueLabel: _dollars ? ChartData.dollars : ChartData.miles,
                semanticLabel: _dollars ? 'Deductions by month' : 'Business miles by month',
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Single series',
          caption: 'Business miles, last 8 weeks.',
          children: [
            LqCard(
              child: LqLineChart(
                values: const [182, 204, 196, 231, 218, 247, 239, 262],
                labels: const ['W39', 'W40', 'W41', 'W42', 'W43', 'W44', 'W45', 'W46'],
                valueLabel: ChartData.miles,
                height: 170,
                semanticLabel: 'Weekly business miles',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

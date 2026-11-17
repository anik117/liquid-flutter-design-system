import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'chart_data.dart';

class StackedBarDemo extends StatefulWidget {
  const StackedBarDemo({super.key});

  @override
  State<StackedBarDemo> createState() => _StackedBarDemoState();
}

class _StackedBarDemoState extends State<StackedBarDemo> {
  bool _grouped = false;

  @override
  Widget build(BuildContext context) {
    final half = ChartData.monthsSoFar.sublist(5);
    List<double> tail(List<double> v) => v.sublist(5);
    return DemoColumn(
      children: [
        LqSection(
          title: 'Miles by purpose',
          caption: 'Pick a month for the breakdown.',
          children: [
            LqCard(
              child: LqStackedBarChart(
                labels: ChartData.monthsSoFar,
                highlighted: 10,
                valueLabel: ChartData.miles,
                semanticLabel: 'Miles by purpose per month',
                series: const [
                  LqChartSeries(label: 'Business', values: ChartData.business),
                  LqChartSeries(label: 'Personal', values: ChartData.personal, tone: LqTone.neutral),
                  LqChartSeries(label: 'Commute', values: ChartData.commute, tone: LqTone.caution),
                ],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Grouped',
          caption: 'Business miles, this year beside last year.',
          children: [
            LqSegmentedControl<bool>(
              segments: const [
                LqSegment(value: false, label: 'Stacked'),
                LqSegment(value: true, label: 'Grouped'),
              ],
              value: _grouped,
              onChanged: (v) => setState(() => _grouped = v),
            ),
            LqCard(
              child: LqStackedBarChart(
                grouped: _grouped,
                labels: half,
                valueLabel: ChartData.miles,
                semanticLabel: 'Business miles, 2026 and 2025',
                series: [
                  LqChartSeries(label: '2026', values: tail(ChartData.miles2026)),
                  LqChartSeries(label: '2025', values: tail(ChartData.miles2025).sublist(0, 6), tone: LqTone.neutral),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

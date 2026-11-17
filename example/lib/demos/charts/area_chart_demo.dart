import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'chart_data.dart';

class AreaChartDemo extends StatelessWidget {
  const AreaChartDemo({super.key});

  @override
  Widget build(BuildContext context) {
    var running = 0.0;
    final cumulative = [for (final d in ChartData.deductions) running += d];
    return DemoColumn(
      children: [
        LqSection(
          title: 'Deductions so far',
          caption: 'Running total for 2026. Drag across to scrub.',
          children: [
            LqCard(
              child: LqAreaChart(
                labels: ChartData.monthsSoFar,
                valueLabel: ChartData.dollars,
                semanticLabel: 'Cumulative deductions, 2026',
                series: [LqChartSeries(label: 'Deductions', values: cumulative)],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Stacked',
          caption: 'Business miles under personal miles, per month.',
          children: [
            LqCard(
              child: LqAreaChart(
                labels: ChartData.monthsSoFar,
                valueLabel: ChartData.miles,
                semanticLabel: 'Business and personal miles per month',
                series: const [
                  LqChartSeries(label: 'Business', values: ChartData.business),
                  LqChartSeries(label: 'Personal', values: ChartData.personal, tone: LqTone.info),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

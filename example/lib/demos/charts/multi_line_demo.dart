import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'chart_data.dart';

class MultiLineDemo extends StatelessWidget {
  const MultiLineDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Earnings per mile',
          caption: 'By platform. Scrub to compare all three in one pill.',
          children: [
            LqCard(
              child: LqMultiLineChart(
                labels: ChartData.monthsSoFar,
                valueLabel: ChartData.perMile,
                semanticLabel: 'Earnings per mile by platform, 2026',
                series: const [
                  LqChartSeries(label: 'DoorDash', values: ChartData.doorDash),
                  LqChartSeries(label: 'Uber', values: ChartData.uber, tone: LqTone.info),
                  LqChartSeries(label: 'Lyft', values: ChartData.lyft, tone: LqTone.caution),
                ],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'With a target line',
          caption: 'A dashed series works as a goal.',
          children: [
            LqCard(
              child: LqMultiLineChart(
                labels: ChartData.monthsSoFar,
                valueLabel: ChartData.miles,
                height: 170,
                semanticLabel: 'Business miles against an 850 mile goal',
                series: [
                  const LqChartSeries(label: 'Business', values: ChartData.business),
                  LqChartSeries(
                    label: 'Goal',
                    values: List.filled(11, 850),
                    tone: LqTone.neutral,
                    dashed: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'chart_data.dart';

class ChartCardDemo extends StatefulWidget {
  const ChartCardDemo({super.key});

  @override
  State<ChartCardDemo> createState() => _ChartCardDemoState();
}

class _ChartCardDemoState extends State<ChartCardDemo> {
  String _period = 'Month';

  static const _week = (labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      values: <double>[24, 31, 28, 37, 44, 52, 9], delta: '18% vs last week', total: 225.0);
  static final _month = (labels: ['W42', 'W43', 'W44', 'W45', 'W46'],
      values: <double>[148, 162, 171, 158, 121], delta: '9% vs October', total: 760.0);
  static final _year = (labels: ChartData.monthsSoFar, values: ChartData.deductions,
      delta: '6% vs 2025', total: 6612.0);

  @override
  Widget build(BuildContext context) {
    final data = switch (_period) { 'Week' => _week, 'Year' => _year, _ => _month };
    return DemoColumn(
      children: [
        LqSection(
          title: 'Deductions block',
          caption: 'Title, big number, delta, period switch and chart in one card.',
          children: [
            LqChartCard(
              title: 'Deductions',
              value: data.total,
              prefix: r'$',
              delta: data.delta,
              periods: const ['Week', 'Month', 'Year'],
              period: _period,
              onPeriodChanged: (p) => setState(() => _period = p),
              chart: LqBarChart(
                values: data.values,
                labels: data.labels,
                highlighted: data.values.length - 1,
                valueLabel: ChartData.dollars,
                semanticLabel: 'Deductions by $_period'.toLowerCase(),
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Falling metric',
          children: [
            LqChartCard(
              title: 'Earnings per mile · Uber',
              value: 0.71,
              prefix: r'$',
              decimals: 2,
              delta: '13% since January',
              deltaTone: LqTone.caution,
              chart: LqLineChart(
                values: ChartData.uber,
                labels: ChartData.monthsSoFar,
                valueLabel: ChartData.perMile,
                height: 150,
                semanticLabel: 'Uber earnings per mile',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

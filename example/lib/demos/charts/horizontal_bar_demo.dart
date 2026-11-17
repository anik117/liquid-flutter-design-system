import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'chart_data.dart';

class HorizontalBarDemo extends StatefulWidget {
  const HorizontalBarDemo({super.key});

  @override
  State<HorizontalBarDemo> createState() => _HorizontalBarDemoState();
}

class _HorizontalBarDemoState extends State<HorizontalBarDemo> {
  bool _hourly = false;

  @override
  Widget build(BuildContext context) {
    final items = _hourly
        ? const [
            LqBarItem(label: 'DoorDash', value: 24.10),
            LqBarItem(label: 'Uber', value: 27.85),
            LqBarItem(label: 'Lyft', value: 22.40),
            LqBarItem(label: 'Instacart', value: 19.75),
          ]
        : const [
            LqBarItem(label: 'DoorDash', value: 1.32),
            LqBarItem(label: 'Uber', value: 0.71),
            LqBarItem(label: 'Lyft', value: 0.58),
            LqBarItem(label: 'Instacart', value: 0.94),
          ];
    return DemoColumn(
      children: [
        LqSection(
          title: 'Best platform',
          caption: 'Ranked, the leader in the accent. Switch the measure to watch them morph.',
          children: [
            LqSegmentedControl<bool>(
              segments: const [
                LqSegment(value: false, label: 'Per mile'),
                LqSegment(value: true, label: 'Per hour'),
              ],
              value: _hourly,
              onChanged: (v) => setState(() => _hourly = v),
            ),
            LqCard(
              child: LqHorizontalBarChart(
                items: items,
                valueLabel: ChartData.perMile,
                semanticLabel: _hourly ? 'Earnings per hour by platform' : 'Earnings per mile by platform',
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Unsorted',
          caption: 'Top routes in the order you saved them.',
          children: [
            LqCard(
              child: LqHorizontalBarChart(
                sort: false,
                labelWidth: 120,
                valueLabel: ChartData.miles,
                semanticLabel: 'Miles by saved route',
                items: const [
                  LqBarItem(label: 'Airport loop', value: 1240),
                  LqBarItem(label: 'Downtown', value: 860),
                  LqBarItem(label: 'Uptown runs', value: 1480),
                  LqBarItem(label: 'Warehouse', value: 410),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

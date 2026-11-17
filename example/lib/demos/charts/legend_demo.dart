import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class LegendDemo extends StatelessWidget {
  const LegendDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final keys = [
      LqLegendEntry(label: 'Business', color: c.accent, value: '7,905 mi'),
      LqLegendEntry(label: 'Personal', color: Color.lerp(c.border, c.borderStrong, 0.7)!, value: '1,210 mi'),
      LqLegendEntry(label: 'Commute', color: c.caution, value: '640 mi'),
    ];
    return DemoColumn(
      children: [
        LqSection(
          title: 'Horizontal',
          caption: 'Wraps above a chart. Dashes key dashed lines.',
          children: [
            LqChartLegend(entries: [
              LqLegendEntry(label: '2026', color: c.accent),
              LqLegendEntry(label: '2025', color: c.borderStrong, dashed: true),
              LqLegendEntry(label: 'Goal', color: c.caution, dashed: true),
            ]),
            LqChartLegend(entries: keys),
          ],
        ),
        LqSection(
          title: 'Vertical',
          caption: 'Rows with values on the right, as under a ring.',
          children: [
            LqCard(child: LqChartLegend(entries: keys, axis: Axis.vertical)),
          ],
        ),
        LqSection(
          title: 'Value pill',
          caption: 'Floats above a picked mark in every chart.',
          children: [
            const Row(
              children: [
                LqChartPill(title: 'Mar', value: r'$603'),
                SizedBox(width: LqSpace.x3),
                LqChartPill(title: 'Tue, Nov 4', value: '9 drives'),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: LqChartPill(title: 'Aug', value: '1,178 mi', entries: [
                for (final (e, v) in [(keys[0], '1,008'), (keys[1], '110'), (keys[2], '60')])
                  LqLegendEntry(label: e.label, color: e.color, value: v),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}

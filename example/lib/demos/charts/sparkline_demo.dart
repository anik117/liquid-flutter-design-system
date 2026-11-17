import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class SparklineDemo extends StatelessWidget {
  const SparklineDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    Widget tile(String title, double value, String? prefix, String? unit, List<double> trend,
            {Color? color}) =>
        Expanded(
          child: LqCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: lq.type.footnoteMedium.copyWith(color: c.textSecondary)),
                const SizedBox(height: LqSpace.x1),
                LqAmount(value: value, prefix: prefix, unit: unit, decimals: 0, style: lq.type.title3),
                const SizedBox(height: LqSpace.x3),
                LqSparkline(values: trend, width: double.infinity, height: 32, color: color),
              ],
            ),
          ),
        );

    return DemoColumn(
      children: [
        LqListGroup(
          header: 'Vehicles, last 14 days',
          children: [
            LqListRow(
              leading: const LqIconTile(icon: RemixIcons.roadster_line),
              title: 'Camry Hybrid',
              subtitle: '412 mi · business',
              trailing: const LqSparkline(
                values: [22, 31, 28, 40, 18, 0, 35, 44, 38, 29, 41, 47, 30, 49],
                semanticLabel: 'Camry Hybrid miles, trending up',
              ),
              onTap: () {},
            ),
            LqListRow(
              leading: const LqIconTile(icon: RemixIcons.car_line),
              title: 'Honda Fit',
              subtitle: '96 mi · mostly personal',
              trailing: LqSparkline(
                values: const [14, 12, 9, 11, 6, 8, 5, 7, 4, 6, 3, 5, 4, 2],
                color: c.caution,
                semanticLabel: 'Honda Fit miles, trending down',
              ),
              onTap: () {},
            ),
            LqListRow(
              leading: const LqIconTile(icon: RemixIcons.gas_station_line),
              title: 'Fuel cost per mile',
              subtitle: '\$0.11 this week',
              trailing: const LqSparkline(
                values: [0.12, 0.12, 0.13, 0.12, 0.11, 0.11, 0.12, 0.11, 0.10, 0.11, 0.11, 0.10, 0.11, 0.11],
                fill: false,
                semanticLabel: 'Fuel cost per mile, steady',
              ),
              onTap: () {},
            ),
          ],
        ),
        LqSection(
          title: 'Stat tiles',
          children: [
            Row(
              children: [
                tile('This week', 284, null, 'mi', const [31, 44, 38, 52, 47, 0, 72]),
                const SizedBox(width: LqSpace.x3),
                tile('Deducted', 206, r'$', null, const [22, 32, 28, 38, 34, 0, 52]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

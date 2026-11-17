import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class StatTileDemo extends StatelessWidget {
  const StatTileDemo({super.key});

  Widget _pair(Widget a, Widget b) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: a),
        const SizedBox(width: LqSpace.x3),
        Expanded(child: b),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'November so far',
          caption: 'Tap a tile to open its detail.',
          children: [
            _pair(
              LqStatTile(
                label: 'Deductions',
                value: 1639.85,
                prefix: r'$',
                decimals: 2,
                icon: RemixIcons.money_dollar_circle_line,
                delta: 12.4,
                onTap: () {},
              ),
              LqStatTile(
                label: 'Business miles',
                value: 2157.7,
                unit: 'mi',
                decimals: 1,
                icon: RemixIcons.road_map_line,
                delta: 8.1,
                onTap: () {},
              ),
            ),
            _pair(
              LqStatTile(
                label: 'Drives',
                value: 86,
                icon: RemixIcons.steering_2_line,
                delta: -4,
                deltaSuffix: '',
                onTap: () {},
              ),
              LqStatTile(
                label: 'Per hour',
                value: 42.69,
                prefix: r'$',
                unit: '/ hr',
                decimals: 2,
                icon: RemixIcons.timer_line,
                delta: 3.2,
                onTap: () {},
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Lower is better',
          caption: 'A rise in costs reads as caution, not success.',
          children: [
            _pair(
              const LqStatTile(
                label: 'Fuel spend',
                value: 212.40,
                prefix: r'$',
                decimals: 2,
                icon: RemixIcons.gas_station_line,
                delta: 6.5,
                higherIsBetter: false,
              ),
              const LqStatTile(
                label: 'Unclassified',
                value: 3,
                icon: RemixIcons.question_line,
                delta: -9,
                deltaSuffix: '',
                deltaLabel: 'vs last week',
                higherIsBetter: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class ListDemo extends StatefulWidget {
  const ListDemo({super.key});

  @override
  State<ListDemo> createState() => _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {
  bool _detect = true;

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqListGroup(
          header: 'Tracking',
          footer: 'Detection uses Bluetooth and motion. Location stays on this phone.',
          children: [
            LqListRow(
              leading: const LqIconTile(icon: RemixIcons.steering_2_line),
              title: 'Detect drives automatically',
              trailing: LqSwitch(value: _detect, onChanged: (v) => setState(() => _detect = v)),
              onTap: () => setState(() => _detect = !_detect),
            ),
            LqListRow(
              leading: const LqIconTile(icon: RemixIcons.road_map_fill),
              title: 'Saved routes',
              value: '4',
              onTap: () {},
            ),
            LqListRow(
              leading: const LqIconTile(icon: RemixIcons.money_dollar_circle_fill, tone: LqTone.accent),
              title: 'Tax profile',
              subtitle: 'Louisiana · Standard mileage method',
              onTap: () {},
            ),
          ],
        ),
        LqListGroup(
          header: 'Data',
          leadingInset: false,
          children: [
            LqListRow(title: 'Export all drives', onTap: () {}),
            LqListRow(title: 'Delete all drives', destructive: true, onTap: () {}),
          ],
        ),
      ],
    );
  }
}

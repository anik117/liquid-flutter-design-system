import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class SkeletonDemo extends StatefulWidget {
  const SkeletonDemo({super.key});

  @override
  State<SkeletonDemo> createState() => _SkeletonDemoState();
}

class _SkeletonDemoState extends State<SkeletonDemo> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    final rows = _loaded
        ? const [
            LqListRow(
              title: 'Downtown → Airport',
              subtitle: 'Uber · 8:42 AM',
              leading: LqIconTile(icon: RemixIcons.car_line),
              value: '18.4 mi',
            ),
            LqListRow(
              title: 'Airport → Home',
              subtitle: 'Lyft · 11:05 AM',
              leading: LqIconTile(icon: RemixIcons.car_line),
              value: '21.0 mi',
            ),
            LqListRow(
              title: 'Shell, Market St',
              subtitle: 'Fuel receipt',
              leading: LqIconTile(icon: RemixIcons.gas_station_line),
              value: r'$48.20',
            ),
          ]
        : const [LqSkeleton.row(), LqSkeleton.row(), LqSkeleton.row()];
    return DemoColumn(
      children: [
        LqSection(
          title: 'Loading a list',
          caption: 'One shimmer sweeps across every row together.',
          trailing: LqButton(
            label: _loaded ? 'Reload' : 'Load',
            variant: LqButtonVariant.plain,
            size: LqButtonSize.small,
            onPressed: () => setState(() => _loaded = !_loaded),
          ),
          children: [
            _loaded
                ? LqListGroup(children: rows)
                : LqShimmer(child: LqListGroup(children: rows)),
          ],
        ),
        const LqSection(
          title: 'Blocks',
          caption: 'Lines, circles and rectangles; still under Reduce Motion.',
          children: [
            LqShimmer(
              child: Row(
                children: [
                  LqSkeleton.circle(size: 44),
                  SizedBox(width: LqSpace.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LqSkeleton.line(width: 160, height: 14),
                        SizedBox(height: LqSpace.x2),
                        LqSkeleton.line(width: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            LqSkeleton.rect(height: 140),
          ],
        ),
      ],
    );
  }
}

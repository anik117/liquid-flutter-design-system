import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class BadgeDemo extends StatelessWidget {
  const BadgeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoColumn(
      children: [
        LqSection(
          title: 'Tones',
          caption: 'Color only when it means something.',
          children: [
            Wrap(
              spacing: LqSpace.x2,
              runSpacing: LqSpace.x2,
              children: [
                LqBadge(label: 'Personal'),
                LqBadge(label: 'Business', tone: LqTone.accent),
                LqBadge(label: r'+$13.83', tone: LqTone.positive),
                LqBadge(label: 'To review', tone: LqTone.caution, dot: true),
                LqBadge(label: 'Sync failed', tone: LqTone.danger),
                LqBadge(
                  label: 'Auto-detected',
                  tone: LqTone.info,
                  icon: RemixIcons.road_map_fill,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

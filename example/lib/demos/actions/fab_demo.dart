import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class FabDemo extends StatefulWidget {
  const FabDemo({super.key});

  @override
  State<FabDemo> createState() => _FabDemoState();
}

class _FabDemoState extends State<FabDemo> {
  final _scroll = ScrollController();
  bool _extended = true;
  int _started = 0;

  static const _drives = [
    ('Midtown → JFK Terminal 4', 'DoorDash · Tue 6:12 PM', '18.4 mi'),
    ('Astoria → Williamsburg', 'Uber · Tue 2:40 PM', '7.9 mi'),
    ('Home → Costco Sunnyside', 'Instacart · Tue 11:05 AM', '4.2 mi'),
    ('LaGuardia → Upper West Side', 'Lyft · Mon 9:31 PM', '9.6 mi'),
    ('Long Island City → Bushwick', 'DoorDash · Mon 7:02 PM', '5.3 mi'),
    ('Jackson Heights → Flushing', 'Uber · Mon 4:48 PM', '3.8 mi'),
    ('Home → Whole Foods Chelsea', 'Instacart · Mon 1:15 PM', '6.1 mi'),
    ('Park Slope → Newark EWR', 'Lyft · Sun 5:20 AM', '22.7 mi'),
  ];

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final quiet = lq.type.subhead.copyWith(color: c.textSecondary);
    return DemoColumn(
      children: [
        LqSection(
          title: 'Collapses while scrolling',
          caption: 'Scroll the drives down: it folds to a circle. Scroll up: it opens.',
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(lq.radius.xl),
              child: SizedBox(
                height: 340,
                child: Stack(
                  children: [
                    ColoredBox(
                      color: c.surface,
                      child: ListView.separated(
                        controller: _scroll,
                        padding: const EdgeInsets.only(bottom: 88),
                        itemCount: _drives.length,
                        separatorBuilder: (_, _) => Container(height: 1, color: c.separator),
                        itemBuilder: (context, i) => LqListRow(
                          leading: const LqIconTile(icon: RemixIcons.car_line),
                          title: _drives[i].$1,
                          subtitle: _drives[i].$2,
                          value: _drives[i].$3,
                        ),
                      ),
                    ),
                    Positioned(
                      right: LqSpace.x4,
                      bottom: LqSpace.x4,
                      child: LqFab(
                        icon: RemixIcons.steering_2_fill,
                        label: 'Start drive',
                        scrollController: _scroll,
                        onPressed: () => setState(() => _started++),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              _started == 0 ? 'No drive started' : 'Started $_started drive${_started == 1 ? '' : 's'}',
              style: quiet,
            ),
          ],
        ),
        LqSection(
          title: 'Driven by a bool',
          caption: 'Set extended yourself; the width settles on a spring.',
          children: [
            Row(
              children: [
                LqFab(
                  icon: RemixIcons.gas_station_fill,
                  label: 'Log fuel',
                  extended: _extended,
                  onPressed: () {},
                ),
                const Spacer(),
                LqSwitch(
                  value: _extended,
                  semanticLabel: 'Show label',
                  onChanged: (v) => setState(() => _extended = v),
                ),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'Glass and icon-only',
          caption: 'Glass for busy backgrounds like a map; disabled never takes taps.',
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 120),
              padding: const EdgeInsets.all(LqSpace.x4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(lq.radius.xl),
                gradient: LinearGradient(colors: [c.accentSoft, c.infoSoft, c.cautionSoft]),
              ),
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: LqSpace.x3,
                runSpacing: LqSpace.x3,
                children: [
                  LqFab(icon: RemixIcons.navigation_line, label: 'Recenter', glass: true, onPressed: () {}),
                  LqFab(icon: RemixIcons.add_line, semanticLabel: 'Add drive manually', onPressed: () {}),
                  const LqFab(icon: RemixIcons.camera_line, semanticLabel: 'Scan receipt', onPressed: null),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

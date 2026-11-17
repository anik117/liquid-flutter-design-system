import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class _Drive {
  _Drive(this.id, this.route, this.detail, this.miles, this.business);

  final int id;
  final String route;
  final String detail;
  final String miles;
  bool? business;
}

class SwipeRowDemo extends StatefulWidget {
  const SwipeRowDemo({super.key});

  @override
  State<SwipeRowDemo> createState() => _SwipeRowDemoState();
}

class _SwipeRowDemoState extends State<SwipeRowDemo> {
  List<_Drive> _seed() => [
    _Drive(1, 'Mission District → SoMa', 'Today · 6:12 PM · DoorDash', '6.4 mi', null),
    _Drive(2, 'Oakland → Emeryville', 'Today · 1:40 PM · Uber', '9.8 mi', true),
    _Drive(3, 'Home → Costco Daly City', 'Yesterday · 10:05 AM', '7.1 mi', false),
    _Drive(4, 'SFO → Union Square', 'Yesterday · 7:22 AM · Lyft', '14.2 mi', null),
  ];

  late List<_Drive> _drives = _seed();

  void _classify(_Drive d, bool business) => setState(() => d.business = business);

  void _delete(_Drive d) => setState(() => _drives.remove(d));

  Widget _badge(_Drive d) => switch (d.business) {
    true => const LqBadge(label: 'Business', tone: LqTone.accent),
    false => const LqBadge(label: 'Personal'),
    null => const LqBadge(label: 'To review', tone: LqTone.caution),
  };

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Classify drives',
          caption: 'Swipe right for Business, left for Personal or Delete. '
              'Swipe all the way to commit the outer action.',
          children: [
            LqSwipeGroup(
              child: LqListGroup(
                header: 'This week',
                children: [
                  for (final d in _drives)
                    LqSwipeRow(
                      key: ValueKey(d.id),
                      leadingActions: [
                        LqSwipeAction(
                          label: 'Business',
                          icon: RemixIcons.briefcase_4_fill,
                          tone: LqTone.accent,
                          onTap: () => _classify(d, true),
                        ),
                      ],
                      trailingActions: [
                        LqSwipeAction(
                          label: 'Delete',
                          icon: RemixIcons.delete_bin_fill,
                          tone: LqTone.danger,
                          onTap: () => _delete(d),
                        ),
                        LqSwipeAction(
                          label: 'Personal',
                          icon: RemixIcons.user_3_fill,
                          onTap: () => _classify(d, false),
                        ),
                      ],
                      child: LqListRow(
                        leading: const LqIconTile(icon: RemixIcons.steering_2_line),
                        title: d.route,
                        subtitle: d.detail,
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(d.miles),
                            const SizedBox(height: LqSpace.x1),
                            _badge(d),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                ],
              ),
            ),
            if (_drives.length < 4)
              LqButton(
                label: 'Restore deleted drives',
                variant: LqButtonVariant.secondary,
                onPressed: () => setState(() => _drives = _seed()),
              ),
          ],
        ),
        LqSection(
          title: 'Without full swipe',
          caption: 'The row resists past its actions and settles open.',
          children: [
            LqListGroup(
              children: [
                LqSwipeRow(
                  fullSwipe: false,
                  trailingActions: [
                    LqSwipeAction(
                      label: 'Archive',
                      icon: RemixIcons.archive_line,
                      tone: LqTone.info,
                      onTap: () {},
                    ),
                  ],
                  child: LqListRow(
                    leading: const LqIconTile(icon: RemixIcons.receipt_line),
                    title: 'Shell · Fuel receipt',
                    subtitle: 'Nov 14 · Toyota Prius',
                    value: r'$48.20',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

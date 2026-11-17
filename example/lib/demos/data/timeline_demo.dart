import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class TimelineDemo extends StatelessWidget {
  const TimelineDemo({super.key});

  static const _drive = [
    LqTimelineEvent(
      title: 'Started',
      time: '6:12 PM',
      body: 'Mission District · 24th St',
      icon: RemixIcons.play_fill,
    ),
    LqTimelineEvent(
      title: 'Stop',
      time: '6:19 PM',
      body: 'DoorDash pickup · Tartine',
      icon: RemixIcons.takeaway_line,
    ),
    LqTimelineEvent(
      title: 'Stop',
      time: '6:33 PM',
      body: 'Drop-off · Folsom St',
      icon: RemixIcons.map_pin_line,
    ),
    LqTimelineEvent(
      title: 'Ended',
      time: '6:41 PM',
      body: 'SoMa · 6.4 mi · \$4.86 deduction',
      icon: RemixIcons.flag_fill,
      tone: LqTone.accent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const DemoColumn(
      children: [
        LqSection(
          title: 'Finished drive',
          children: [LqCard(child: LqTimeline(events: _drive))],
        ),
        LqSection(
          title: 'Drive in progress',
          caption: 'The current stop pulses softly. Reduce Motion keeps it still.',
          children: [
            LqCard(
              child: LqTimeline(
                current: 2,
                events: [
                  LqTimelineEvent(title: 'Started', time: '9:02 AM', body: 'Home · Oakland'),
                  LqTimelineEvent(title: 'Pickup', time: '9:15 AM', body: 'Uber · Lake Merritt'),
                  LqTimelineEvent(title: 'Driving', time: 'Now', body: 'To Emeryville · 3.1 mi so far'),
                  LqTimelineEvent(title: 'Drop-off', body: 'Bay St · about 9:41 AM'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

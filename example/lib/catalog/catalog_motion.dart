import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demos/motion/counter_demo.dart';
import '../demos/motion/refresh_demo.dart';
import '../demos/motion/stagger_demo.dart';
import 'catalog.dart';

final motionEntries = <GalleryEntry>[
  GalleryEntry(
    name: 'Stagger',
    summary: 'Lists that fade and rise in, one row after another',
    icon: RemixIcons.list_ordered_2,
    builder: (_) => const StaggerDemo(),
  ),
  GalleryEntry(
    name: 'Pull to refresh',
    summary: 'A glass circle that fills as you pull, then spins',
    icon: RemixIcons.refresh_line,
    builder: (_) => const RefreshDemo(),
  ),
  GalleryEntry(
    name: 'Counter',
    summary: 'Odometer digits that roll on a spring',
    icon: RemixIcons.timer_flash_line,
    builder: (_) => const CounterDemo(),
  ),
];

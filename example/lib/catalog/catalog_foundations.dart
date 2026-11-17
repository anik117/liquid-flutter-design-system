import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demos/foundations/glass_demo.dart';
import 'catalog.dart';

final foundationsEntries = <GalleryEntry>[
  GalleryEntry(
    name: 'Liquid Glass',
    summary: 'Frosted, rim-lit surface for bars and floating controls',
    icon: RemixIcons.drop_line,
    builder: (_) => const GlassDemo(),
  ),
];

import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demos/navigation/back_button_demo.dart';
import '../demos/navigation/page_dots_demo.dart';
import '../demos/navigation/tab_bar_demo.dart';
import '../demos/navigation/tabs_demo.dart';
import 'catalog.dart';

final navigationEntries = <GalleryEntry>[
  GalleryEntry(
    name: 'Tab bar',
    summary: 'Floating glass tabs you can scrub across',
    icon: RemixIcons.layout_bottom_line,
    builder: (_) => const TabBarDemo(),
  ),
  GalleryEntry(
    name: 'Tabs',
    summary: 'In-page tabs with a sliding pill or underline',
    icon: RemixIcons.layout_top_line,
    builder: (_) => const TabsDemo(),
  ),
  GalleryEntry(
    name: 'Page dots',
    summary: 'A page indicator that stretches as you swipe',
    icon: RemixIcons.more_line,
    builder: (_) => const PageDotsDemo(),
  ),
  GalleryEntry(
    name: 'Back button',
    summary: 'Glass back button, round or with a title',
    icon: RemixIcons.arrow_left_s_line,
    builder: (_) => const BackButtonDemo(),
  ),
];

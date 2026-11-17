import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demos/feedback/badge_demo.dart';
import '../demos/feedback/banner_demo.dart';
import '../demos/feedback/count_badge_demo.dart';
import '../demos/feedback/empty_state_demo.dart';
import '../demos/feedback/progress_demo.dart';
import '../demos/feedback/skeleton_demo.dart';
import '../demos/feedback/toast_demo.dart';
import 'catalog.dart';

final feedbackEntries = <GalleryEntry>[
  GalleryEntry(
    name: 'Badge',
    summary: 'Small status labels; color only for meaning',
    icon: RemixIcons.price_tag_3_line,
    builder: (_) => const BadgeDemo(),
  ),
  GalleryEntry(
    name: 'Toast',
    summary: 'Short confirmation that leaves on its own',
    icon: RemixIcons.chat_check_line,
    builder: (_) => const ToastDemo(),
  ),
  GalleryEntry(
    name: 'Banner',
    summary: 'Inline alert that sits in the page',
    icon: RemixIcons.information_line,
    builder: (_) => const BannerDemo(),
  ),
  GalleryEntry(
    name: 'Progress',
    summary: 'Bars, rings and spinners for work in flight',
    icon: RemixIcons.progress_3_line,
    builder: (_) => const ProgressDemo(),
  ),
  GalleryEntry(
    name: 'Skeleton',
    summary: 'Shimmering placeholders while content loads',
    icon: RemixIcons.layout_masonry_line,
    builder: (_) => const SkeletonDemo(),
  ),
  GalleryEntry(
    name: 'Empty state',
    summary: 'A calm first screen with one next step',
    icon: RemixIcons.inbox_line,
    builder: (_) => const EmptyStateDemo(),
  ),
  GalleryEntry(
    name: 'Count badge',
    summary: 'A number on a button that pops when it changes',
    icon: RemixIcons.notification_3_line,
    builder: (_) => const CountBadgeDemo(),
  ),
];

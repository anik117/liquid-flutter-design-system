import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demos/data/avatar_demo.dart';
import '../demos/data/calendar_strip_demo.dart';
import '../demos/data/card_amount_demo.dart';
import '../demos/data/carousel_demo.dart';
import '../demos/data/disclosure_demo.dart';
import '../demos/data/key_value_demo.dart';
import '../demos/data/list_demo.dart';
import '../demos/data/stat_tile_demo.dart';
import '../demos/data/swipe_row_demo.dart';
import '../demos/data/timeline_demo.dart';
import 'catalog.dart';

final dataEntries = <GalleryEntry>[
  GalleryEntry(
    name: 'Card and amount',
    summary: 'Opaque content cards and the one big number',
    icon: RemixIcons.money_dollar_box_line,
    builder: (_) => const CardAmountDemo(),
  ),
  GalleryEntry(
    name: 'List',
    summary: 'Inset grouped rows with tiles, values and switches',
    icon: RemixIcons.list_check_2,
    builder: (_) => const ListDemo(),
  ),
  GalleryEntry(
    name: 'Swipe row',
    summary: 'Swipe a row to classify or delete it',
    icon: RemixIcons.arrow_left_right_line,
    builder: (_) => const SwipeRowDemo(),
  ),
  GalleryEntry(
    name: 'Avatar',
    summary: 'People and fleets as photos, initials or icons',
    icon: RemixIcons.account_circle_line,
    builder: (_) => const AvatarDemo(),
  ),
  GalleryEntry(
    name: 'Stat tile',
    summary: 'One metric with its change since last month',
    icon: RemixIcons.bar_chart_box_line,
    builder: (_) => const StatTileDemo(),
  ),
  GalleryEntry(
    name: 'Disclosure',
    summary: 'Rows that open to show more, like an FAQ',
    icon: RemixIcons.expand_up_down_line,
    builder: (_) => const DisclosureDemo(),
  ),
  GalleryEntry(
    name: 'Key-value list',
    summary: 'Summary lines with an emphasized total',
    icon: RemixIcons.file_list_3_line,
    builder: (_) => const KeyValueDemo(),
  ),
  GalleryEntry(
    name: 'Timeline',
    summary: "A drive's stops on a rail, live step highlighted",
    icon: RemixIcons.git_commit_line,
    builder: (_) => const TimelineDemo(),
  ),
  GalleryEntry(
    name: 'Carousel',
    summary: 'Paging cards with peeking neighbors',
    icon: RemixIcons.carousel_view,
    builder: (_) => const CarouselDemo(),
  ),
  GalleryEntry(
    name: 'Calendar strip',
    summary: 'A week of days for picking one',
    icon: RemixIcons.calendar_line,
    builder: (_) => const CalendarStripDemo(),
  ),
];

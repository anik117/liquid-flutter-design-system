import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demos/overlays/action_sheet_demo.dart';
import '../demos/overlays/dialog_demo.dart';
import '../demos/overlays/menu_demo.dart';
import '../demos/overlays/sheet_demo.dart';
import '../demos/overlays/tooltip_demo.dart';
import 'catalog.dart';

final overlaysEntries = <GalleryEntry>[
  GalleryEntry(
    name: 'Bottom sheet',
    summary: 'Forms and choices that keep the page in place',
    icon: RemixIcons.layout_top_2_line,
    builder: (_) => const SheetDemo(),
  ),
  GalleryEntry(
    name: 'Dialog',
    summary: 'A centered question with up to three answers',
    icon: RemixIcons.questionnaire_line,
    builder: (_) => const DialogDemo(),
  ),
  GalleryEntry(
    name: 'Action sheet',
    summary: 'Actions for one item, near the thumb',
    icon: RemixIcons.apps_2_line,
    builder: (_) => const ActionSheetDemo(),
  ),
  GalleryEntry(
    name: 'Menu',
    summary: 'A glass button that morphs into its menu',
    icon: RemixIcons.more_fill,
    builder: (_) => const MenuDemo(),
  ),
  GalleryEntry(
    name: 'Tooltip',
    summary: 'Names an icon button on long-press or hover',
    icon: RemixIcons.chat_3_line,
    builder: (_) => const TooltipDemo(),
  ),
];

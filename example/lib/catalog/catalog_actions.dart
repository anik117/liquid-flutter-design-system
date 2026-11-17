import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demos/actions/button_group_demo.dart';
import '../demos/actions/buttons_demo.dart';
import '../demos/actions/chips_demo.dart';
import '../demos/actions/fab_demo.dart';
import '../demos/actions/icon_buttons_demo.dart';
import '../demos/actions/toolbar_demo.dart';
import 'catalog.dart';

final actionsEntries = <GalleryEntry>[
  GalleryEntry(
    name: 'Button',
    summary: 'Primary, secondary, ghost, danger and plain, in three sizes',
    icon: RemixIcons.cursor_line,
    builder: (_) => const ButtonsDemo(),
  ),
  GalleryEntry(
    name: 'Icon button',
    summary: 'Round icon-only buttons, including glass',
    icon: RemixIcons.add_circle_line,
    builder: (_) => const IconButtonsDemo(),
  ),
  GalleryEntry(
    name: 'Chips',
    summary: 'Filter, choice and input chips, single or in groups',
    icon: RemixIcons.price_tag_3_line,
    builder: (_) => const ChipsDemo(),
  ),
  GalleryEntry(
    name: 'Button group',
    summary: 'Joined buttons sharing one face, text or icons',
    icon: RemixIcons.layout_column_line,
    builder: (_) => const ButtonGroupDemo(),
  ),
  GalleryEntry(
    name: 'Toolbar',
    summary: 'A floating glass capsule of icon actions',
    icon: RemixIcons.tools_line,
    builder: (_) => const ToolbarDemo(),
  ),
  GalleryEntry(
    name: 'Floating action button',
    summary: 'Extends with a label, folds while you scroll',
    icon: RemixIcons.add_circle_fill,
    builder: (_) => const FabDemo(),
  ),
];

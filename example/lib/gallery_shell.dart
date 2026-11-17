import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import 'catalog/catalog_page.dart';
import 'showcase/drives_page.dart';
import 'theme/theme_page.dart';

/// Liquid Gallery: a sample app screen built from the system, the full
/// component catalog, and the live theme switcher, on a floating glass
/// tab bar with the Start drive action beside it.
class GalleryShell extends StatefulWidget {
  const GalleryShell({super.key});

  @override
  State<GalleryShell> createState() => _GalleryShellState();
}

class _GalleryShellState extends State<GalleryShell> {
  int _tab = 0;

  static const _items = [
    LqTabItem(
      icon: RemixIcons.car_line,
      activeIcon: RemixIcons.car_fill,
      label: 'Showcase',
    ),
    LqTabItem(
      icon: RemixIcons.layout_grid_line,
      activeIcon: RemixIcons.layout_grid_fill,
      label: 'Components',
    ),
    LqTabItem(
      icon: RemixIcons.palette_line,
      activeIcon: RemixIcons.palette_fill,
      label: 'Theme',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom =
        MediaQuery.paddingOf(context).bottom + LqSize.tabBar + LqSpace.x4;
    final pages = [
      DrivesPage(bottomInset: bottom),
      CatalogPage(bottomInset: bottom),
      ThemePage(bottomInset: bottom),
    ];
    return Stack(
      children: [
        Positioned.fill(child: IndexedStack(index: _tab, children: pages)),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: LqTabBar(
            items: _items,
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
            action: LqIconButton(
              icon: RemixIcons.steering_2_fill,
              semanticLabel: 'Start drive',
              variant: LqIconButtonVariant.primary,
              size: LqSize.tabBar - 4,
              onPressed: () => LqToast.show(
                context,
                'Drive started',
                icon: RemixIcons.steering_2_fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

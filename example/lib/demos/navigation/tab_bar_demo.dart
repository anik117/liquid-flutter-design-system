import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({super.key});

  @override
  State<TabBarDemo> createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  int _tab = 0;

  static const _items = [
    LqTabItem(icon: RemixIcons.car_line, activeIcon: RemixIcons.car_fill, label: 'Drives'),
    LqTabItem(icon: RemixIcons.file_list_3_line, activeIcon: RemixIcons.file_list_3_fill, label: 'Taxes'),
    LqTabItem(icon: RemixIcons.bar_chart_2_line, activeIcon: RemixIcons.bar_chart_2_fill, label: 'Profit'),
    LqTabItem(icon: RemixIcons.safe_2_line, activeIcon: RemixIcons.safe_2_fill, label: 'Vault'),
  ];

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Four tabs and an action',
          caption: 'Tap a tab, or press and drag across to scrub.',
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(lq.radius.xl),
              child: Container(
                height: 150,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: LqSpace.x3),
                color: lq.colors.surfaceSunken,
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: LqTabBar(
                    items: _items,
                    index: _tab,
                    onChanged: (i) => setState(() => _tab = i),
                    action: LqIconButton(
                      icon: RemixIcons.steering_2_fill,
                      semanticLabel: 'Start drive',
                      variant: LqIconButtonVariant.primary,
                      size: LqSize.tabBar - 4,
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
            Text('Selected: ${_items[_tab].label}',
                style: lq.type.subhead.copyWith(color: lq.colors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

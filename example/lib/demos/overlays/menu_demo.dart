import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

enum _Sort { date, distance, deduction }

class MenuDemo extends StatefulWidget {
  const MenuDemo({super.key});

  @override
  State<MenuDemo> createState() => _MenuDemoState();
}

class _MenuDemoState extends State<MenuDemo> {
  _Sort _sort = _Sort.date;

  List<LqMenuEntry<Object>> get _entries => [
    const LqMenuHeader('Sort by'),
    LqMenuItem(
      label: 'Date',
      value: _Sort.date,
      checked: _sort == _Sort.date,
      icon: RemixIcons.calendar_line,
    ),
    LqMenuItem(
      label: 'Distance',
      value: _Sort.distance,
      checked: _sort == _Sort.distance,
      icon: RemixIcons.route_line,
    ),
    LqMenuItem(
      label: 'Deduction',
      value: _Sort.deduction,
      checked: _sort == _Sort.deduction,
      icon: RemixIcons.money_dollar_circle_line,
    ),
    const LqMenuDivider(),
    const LqMenuItem(
      label: 'Export CSV',
      value: 'export',
      icon: RemixIcons.download_2_line,
    ),
    const LqMenuItem(
      label: 'Clear filters',
      value: 'clear',
      icon: RemixIcons.filter_3_line,
    ),
  ];

  void _pick(Object value) {
    if (value is _Sort) {
      setState(() => _sort = value);
    } else {
      LqToast.show(
        context,
        value == 'export' ? 'Exporting 214 drives' : 'Filters cleared',
        icon: RemixIcons.check_line,
        clearance: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Morphing menu',
          caption: 'The glass button stretches into the menu and folds back.',
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Sorted by ${_sort.name}',
                    style: lq.type.body.copyWith(
                      color: lq.colors.textSecondary,
                    ),
                  ),
                ),
                LqMenuButton<Object>(
                  semanticLabel: 'Drive options',
                  entries: _entries,
                  onSelected: _pick,
                ),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'Capsule with a label',
          caption: 'Opens above when there is more room there.',
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: LqMenuButton<String>(
                semanticLabel: 'Vehicle',
                icon: RemixIcons.car_line,
                label: '2019 Prius',
                entries: const [
                  LqMenuItem(
                    label: '2019 Prius',
                    value: 'prius',
                    checked: true,
                  ),
                  LqMenuItem(label: '2021 Model 3', value: 'model3'),
                  LqMenuDivider(),
                  LqMenuItem(
                    label: 'Remove vehicle',
                    value: 'remove',
                    destructive: true,
                    icon: RemixIcons.delete_bin_line,
                  ),
                ],
                onSelected: (_) {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class ButtonGroupDemo extends StatefulWidget {
  const ButtonGroupDemo({super.key});

  @override
  State<ButtonGroupDemo> createState() => _ButtonGroupDemoState();
}

class _ButtonGroupDemoState extends State<ButtonGroupDemo> {
  int _range = 1;
  int _view = 0;
  String _last = 'Nothing exported yet';

  static const _ranges = ['Day', 'Week', 'Month'];
  static const _views = ['List', 'Map', 'Calendar'];

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final quiet = lq.type.subhead.copyWith(color: lq.colors.textSecondary);
    return DemoColumn(
      children: [
        LqSection(
          title: 'Text parts',
          caption: 'One bordered face, hairline dividers; one part tinted as current.',
          children: [
            LqButtonGroup(
              expand: true,
              selectedIndex: _range,
              items: [
                for (var i = 0; i < _ranges.length; i++)
                  LqButtonGroupItem(
                    label: _ranges[i],
                    onPressed: () => setState(() => _range = i),
                  ),
              ],
            ),
            Text('Miles by ${_ranges[_range].toLowerCase()}', style: quiet),
          ],
        ),
        LqSection(
          title: 'Icon parts',
          caption: 'A compact view switcher for the drives list.',
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: LqButtonGroup(
                selectedIndex: _view,
                items: [
                  for (final (i, icon) in const [
                    (0, RemixIcons.list_unordered),
                    (1, RemixIcons.map_2_line),
                    (2, RemixIcons.calendar_line),
                  ])
                    LqButtonGroupItem(
                      icon: icon,
                      semanticLabel: '${_views[i]} view',
                      onPressed: () => setState(() => _view = i),
                    ),
                ],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Actions',
          caption: 'Plain actions with no current part; small size.',
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: LqButtonGroup(
                small: true,
                items: [
                  LqButtonGroupItem(
                    label: 'CSV',
                    icon: RemixIcons.download_2_line,
                    onPressed: () => setState(() => _last = 'Exported 412 drives as CSV'),
                  ),
                  LqButtonGroupItem(
                    label: 'PDF',
                    icon: RemixIcons.file_chart_line,
                    onPressed: () => setState(() => _last = 'Built IRS mileage log (PDF)'),
                  ),
                  const LqButtonGroupItem(label: 'Email', onPressed: null),
                ],
              ),
            ),
            Text(_last, style: quiet),
          ],
        ),
      ],
    );
  }
}

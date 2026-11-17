import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class CalendarStripDemo extends StatefulWidget {
  const CalendarStripDemo({super.key});

  @override
  State<CalendarStripDemo> createState() => _CalendarStripDemoState();
}

class _CalendarStripDemoState extends State<CalendarStripDemo> {
  late DateTime _day = DateTime.now();

  // Demo data: drives on most weekdays and the odd Saturday.
  static bool _hasDrives(DateTime d) =>
      d.weekday <= 5 ? d.day % 4 != 0 : d.weekday == 6 && d.day.isEven;

  int _drivesOn(DateTime d) => _hasDrives(d) ? 2 + d.day % 5 : 0;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final count = _drivesOn(_day);
    final miles = count * 7.3;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Pick a day',
          caption: 'Tap a day; swipe for other weeks. Dots mark days with drives.',
          children: [
            LqCard(
              padding: const EdgeInsets.symmetric(
                horizontal: LqSpace.x2,
                vertical: LqSpace.x3,
              ),
              child: LqCalendarStrip(
                selected: _day,
                hasDrives: _hasDrives,
                onChanged: (d) => setState(() => _day = d),
              ),
            ),
            LqKeyValueList(
              items: [
                LqKeyValue('Drives', '$count'),
                LqKeyValue('Business miles', '${miles.toStringAsFixed(1)} mi'),
              ],
              total: LqKeyValue(
                'Deduction',
                '\$${(miles * 0.76).toStringAsFixed(2)}',
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Week starts Sunday',
          children: [
            LqCalendarStrip(
              selected: _day,
              firstWeekday: DateTime.sunday,
              hasDrives: _hasDrives,
              onChanged: (d) => setState(() => _day = d),
            ),
            Text(
              'Both strips share one selection.',
              style: lq.type.footnote.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

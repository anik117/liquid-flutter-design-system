import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class DateTimeDemo extends StatefulWidget {
  const DateTimeDemo({super.key});

  @override
  State<DateTimeDemo> createState() => _DateTimeDemoState();
}

class _DateTimeDemoState extends State<DateTimeDemo> {
  DateTime _start = DateTime(2026, 11, 17, 18, 41);
  DateTime? _end;

  @override
  Widget build(BuildContext context) {
    final endsBeforeStart = _end != null && _end!.isBefore(_start);
    return DemoColumn(
      children: [
        LqSection(
          title: 'Trip',
          caption: 'The system wheel on iOS, the Material calendar and clock on Android.',
          children: [
            LqDateField(
              label: 'Trip date',
              value: _start,
              lastDate: DateTime.now(),
              onChanged: (d) => setState(() => _start = d),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LqTimeField(
                    label: 'Started',
                    value: _start,
                    onChanged: (t) => setState(() => _start = t),
                  ),
                ),
                const SizedBox(width: LqSpace.x3),
                Expanded(
                  child: LqTimeField(
                    label: 'Ended',
                    value: _end,
                    placeholder: 'Add time',
                    minuteInterval: 5,
                    error: endsBeforeStart ? 'Before the start.' : null,
                    onChanged: (t) => setState(
                      () => _end = DateTime(_start.year, _start.month, _start.day, t.hour, t.minute),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'Disabled',
          children: [
            LqDateField(
              label: 'Filed on',
              value: DateTime(2026, 4, 15),
              onChanged: null,
              helper: 'Locked after your return is filed.',
            ),
          ],
        ),
      ],
    );
  }
}

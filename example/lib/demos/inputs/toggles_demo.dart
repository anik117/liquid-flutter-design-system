import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class TogglesDemo extends StatefulWidget {
  const TogglesDemo({super.key});

  @override
  State<TogglesDemo> createState() => _TogglesDemoState();
}

class _TogglesDemoState extends State<TogglesDemo> {
  bool _detect = true;
  bool _notify = false;
  bool _receipt = true;
  bool _tolls = false;

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Switch',
          caption: 'Tap, or swipe the knob across.',
          children: [
            LqListGroup(
              leadingInset: false,
              children: [
                LqListRow(
                  title: 'Detect drives automatically',
                  trailing: LqSwitch(value: _detect, onChanged: (v) => setState(() => _detect = v)),
                ),
                LqListRow(
                  title: 'Sunday review reminder',
                  trailing: LqSwitch(value: _notify, onChanged: (v) => setState(() => _notify = v)),
                ),
                const LqListRow(
                  title: 'Cloud backup (Pro)',
                  trailing: LqSwitch(value: true, onChanged: null),
                ),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'Checkbox',
          children: [
            LqCheckbox(
              value: _receipt,
              label: 'Attach fuel receipt',
              onChanged: (v) => setState(() => _receipt = v),
            ),
            LqCheckbox(
              value: _tolls,
              label: 'Include tolls and parking',
              onChanged: (v) => setState(() => _tolls = v),
            ),
            const LqCheckbox(value: false, label: 'Unavailable option', onChanged: null),
          ],
        ),
      ],
    );
  }
}

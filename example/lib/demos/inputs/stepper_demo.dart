import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class StepperDemo extends StatefulWidget {
  const StepperDemo({super.key});

  @override
  State<StepperDemo> createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  double _passengers = 1;
  double _tolls = 2;
  double _parking = 1.5;

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Counts',
          caption: 'Tap to step; hold to repeat faster. Ends grey out at their bounds.',
          children: [
            LqListGroup(
              leadingInset: false,
              children: [
                LqListRow(
                  title: 'Passengers',
                  subtitle: 'Up to 7',
                  trailing: LqStepper(
                    value: _passengers,
                    max: 7,
                    semanticLabel: 'Passengers',
                    onChanged: (v) => setState(() => _passengers = v),
                  ),
                ),
                LqListRow(
                  title: 'Toll plazas',
                  trailing: LqStepper(
                    value: _tolls,
                    max: 30,
                    semanticLabel: 'Toll plazas',
                    onChanged: (v) => setState(() => _tolls = v),
                  ),
                ),
                LqListRow(
                  title: 'Parking',
                  subtitle: 'Half-hour steps',
                  trailing: LqStepper(
                    value: _parking,
                    max: 12,
                    step: 0.5,
                    format: (v) => '${v.toStringAsFixed(1)} h',
                    semanticLabel: 'Parking hours',
                    onChanged: (v) => setState(() => _parking = v),
                  ),
                ),
              ],
            ),
          ],
        ),
        const LqSection(
          title: 'Disabled',
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: LqStepper(value: 2, onChanged: null, semanticLabel: 'Vehicles'),
            ),
          ],
        ),
      ],
    );
  }
}

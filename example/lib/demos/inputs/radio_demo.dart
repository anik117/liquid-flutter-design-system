import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class RadioDemo extends StatefulWidget {
  const RadioDemo({super.key});

  @override
  State<RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<RadioDemo> {
  String _method = 'standard';
  String _type = 'business';

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Grouped',
          caption: 'Options on one surface; the dot pops in on a spring.',
          children: [
            LqRadioGroup<String>(
              header: 'Tax method',
              footer: 'You can switch methods only in the first year you use a car for work.',
              value: _method,
              onChanged: (v) => setState(() => _method = v),
              options: const [
                LqRadioOption(
                  value: 'standard',
                  label: 'Standard mileage',
                  description: '76¢ per business mile in 2026. Simplest records.',
                ),
                LqRadioOption(
                  value: 'actual',
                  label: 'Actual expenses',
                  description: 'Gas, insurance, repairs and depreciation.',
                ),
                LqRadioOption(
                  value: 'fleet',
                  label: 'Fleet reimbursement',
                  description: 'Needs a Pro team plan.',
                  enabled: false,
                ),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'Plain',
          children: [
            LqRadioGroup<String>(
              grouped: false,
              value: _type,
              onChanged: (v) => setState(() => _type = v),
              options: const [
                LqRadioOption(value: 'business', label: 'Business'),
                LqRadioOption(value: 'personal', label: 'Personal'),
                LqRadioOption(
                  value: 'commute',
                  label: 'Commute',
                  description: 'Home to a regular workplace; not deductible.',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

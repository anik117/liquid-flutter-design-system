import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class SelectDemo extends StatefulWidget {
  const SelectDemo({super.key});

  @override
  State<SelectDemo> createState() => _SelectDemoState();
}

class _SelectDemoState extends State<SelectDemo> {
  String? _vehicle = 'prius';
  String? _platform;

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Pickers',
          caption: 'A wheel and Done on iOS; a list with a check on Android.',
          children: [
            LqSelect<String>(
              label: 'Vehicle',
              value: _vehicle,
              prefixIcon: RemixIcons.car_line,
              onChanged: (v) => setState(() => _vehicle = v),
              options: const [
                LqSelectOption(value: 'prius', label: '2022 Toyota Prius', description: '48,262 mi'),
                LqSelectOption(value: 'civic', label: '2019 Honda Civic', description: '91,407 mi'),
                LqSelectOption(value: 'model3', label: '2024 Tesla Model 3', description: '12,880 mi'),
              ],
            ),
            LqSelect<String>(
              label: 'Gig platform',
              placeholder: 'Choose a platform',
              helper: 'Used to split earnings per platform.',
              value: _platform,
              onChanged: (v) => setState(() => _platform = v),
              options: const [
                LqSelectOption(value: 'uber', label: 'Uber'),
                LqSelectOption(value: 'lyft', label: 'Lyft'),
                LqSelectOption(value: 'doordash', label: 'DoorDash'),
                LqSelectOption(value: 'instacart', label: 'Instacart'),
                LqSelectOption(value: 'amazon', label: 'Amazon Flex'),
              ],
            ),
          ],
        ),
        const LqSection(
          title: 'States',
          children: [
            LqSelect<String>(
              label: 'Business category',
              value: null,
              onChanged: _ignore,
              error: 'Pick a category before exporting.',
              options: [LqSelectOption(value: 'delivery', label: 'Delivery')],
            ),
            LqSelect<String>(
              label: 'Tax year',
              value: '2026',
              onChanged: null,
              options: [LqSelectOption(value: '2026', label: '2026')],
            ),
          ],
        ),
      ],
    );
  }
}

void _ignore(String _) {}

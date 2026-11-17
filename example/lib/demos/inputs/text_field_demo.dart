import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class TextFieldDemo extends StatelessWidget {
  const TextFieldDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        const LqSection(
          title: 'Text',
          caption: 'Sentence-case keyboard, clear button while editing.',
          children: [
            LqTextField(
              label: 'Business purpose',
              placeholder: 'Client visit, delivery shift…',
              helper: 'Shows on your IRS log.',
            ),
            LqTextField(
              label: 'Start address',
              placeholder: 'Search an address',
              prefixIcon: RemixIcons.map_pin_line,
              autofillHints: [AutofillHints.fullStreetAddress],
            ),
          ],
        ),
        LqSection(
          title: 'Numbers',
          caption: 'The right keypad for the value; units sit inside the field.',
          children: [
            LqTextField(
              label: 'Tolls',
              placeholder: '0.00',
              prefixText: r'$',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            ),
            const LqTextField(
              label: 'Odometer',
              placeholder: '48,262',
              suffixText: 'mi',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        const LqSection(
          title: 'States',
          children: [
            LqTextField(
              label: 'End odometer',
              placeholder: '48,210',
              suffixText: 'mi',
              keyboardType: TextInputType.number,
              error: 'Lower than the start odometer (48,262).',
            ),
            LqTextField(label: 'Vehicle', placeholder: 'Primary vehicle', enabled: false),
          ],
        ),
      ],
    );
  }
}

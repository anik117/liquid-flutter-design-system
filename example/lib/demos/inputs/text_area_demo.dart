import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class TextAreaDemo extends StatelessWidget {
  const TextAreaDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoColumn(
      children: [
        LqSection(
          title: 'Notes',
          caption: 'Grows as you type, then scrolls. The counter turns red at the limit.',
          children: [
            LqTextArea(
              label: 'Trip notes',
              placeholder: 'Who you met, what you picked up or dropped off…',
              helper: 'Specific notes hold up best in an IRS review.',
              maxLength: 280,
            ),
            LqTextArea(
              label: 'Receipt memo',
              placeholder: 'Car wash before client pickup',
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
        LqSection(
          title: 'States',
          children: [
            LqTextArea(
              label: 'Business purpose',
              placeholder: 'Work',
              minLines: 2,
              error: 'Too vague for the IRS. Name the client or the delivery.',
            ),
            LqTextArea(
              label: 'Locked note',
              placeholder: 'Synced from your accountant',
              minLines: 2,
              enabled: false,
            ),
          ],
        ),
      ],
    );
  }
}

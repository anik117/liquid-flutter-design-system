import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class SheetDemo extends StatelessWidget {
  const SheetDemo({super.key});

  void _addDrive(BuildContext context) {
    showLqSheet<void>(
      context,
      title: 'Add a drive',
      builder: (sheet) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LqTextField(
            label: 'From',
            placeholder: 'Start address',
            prefixIcon: RemixIcons.map_pin_line,
          ),
          const SizedBox(height: LqSpace.x4),
          const LqTextField(
            label: 'Distance',
            placeholder: '0.0',
            suffixText: 'mi',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: LqSpace.x6),
          LqButton(
            label: 'Save drive',
            size: LqButtonSize.large,
            expand: true,
            onPressed: () {
              Navigator.of(sheet).pop();
              LqToast.show(
                context,
                'Drive saved',
                icon: RemixIcons.check_line,
                clearance: 0,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Form in a sheet',
          caption: 'The keyboard pushes the sheet up; drag down to close.',
          children: [
            LqButton(
              label: 'Add a drive',
              leadingIcon: RemixIcons.add_line,
              expand: true,
              onPressed: () => _addDrive(context),
            ),
          ],
        ),
      ],
    );
  }
}

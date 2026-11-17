import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class ToastDemo extends StatelessWidget {
  const ToastDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Show a toast',
          caption: 'Rises above the tab bar; swipe down to dismiss.',
          children: [
            LqButton(
              label: 'Drive saved',
              variant: LqButtonVariant.secondary,
              expand: true,
              onPressed: () => LqToast.show(
                context,
                'Drive saved',
                icon: RemixIcons.check_line,
                clearance: 0,
              ),
            ),
            LqButton(
              label: 'Report exported',
              variant: LqButtonVariant.secondary,
              expand: true,
              onPressed: () => LqToast.show(
                context,
                'Schedule C report exported',
                icon: RemixIcons.check_double_line,
                clearance: 0,
              ),
            ),
            LqButton(
              label: 'Offline notice',
              variant: LqButtonVariant.secondary,
              expand: true,
              onPressed: () => LqToast.show(
                context,
                'Saved on this phone. Syncs when online.',
                icon: RemixIcons.wifi_off_line,
                tone: LqTone.caution,
                clearance: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

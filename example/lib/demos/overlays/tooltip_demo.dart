import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class TooltipDemo extends StatelessWidget {
  const TooltipDemo({super.key});

  @override
  Widget build(BuildContext context) {
    Widget tip(String message, IconData icon) => LqTooltip(
      message: message,
      child: LqIconButton(
        icon: icon,
        semanticLabel: message,
        variant: LqIconButtonVariant.secondary,
        onPressed: () {},
      ),
    );
    return DemoColumn(
      children: [
        LqSection(
          title: 'Name icon buttons',
          caption: 'Long-press (or hover with a pointer) to see the label.',
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tip('Export Schedule C', RemixIcons.file_chart_line),
                tip('Share drive log', RemixIcons.share_line),
                tip('Add a receipt', RemixIcons.receipt_line),
                tip('Archive 2025', RemixIcons.archive_line),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

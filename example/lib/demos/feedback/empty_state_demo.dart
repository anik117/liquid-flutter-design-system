import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class EmptyStateDemo extends StatelessWidget {
  const EmptyStateDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    Widget card(Widget child) => DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(context.lq.radius.xl),
      ),
      child: child,
    );
    return DemoColumn(
      children: [
        LqSection(
          title: 'With an action',
          children: [
            card(
              LqEmptyState(
                icon: RemixIcons.steering_2_line,
                title: 'No drives yet',
                message: 'Start a drive and VaultMileage logs the miles and the deduction for you.',
                actionLabel: 'Start your first drive',
                actionIcon: RemixIcons.add_line,
                onAction: () => LqToast.show(
                  context,
                  'Drive started',
                  icon: RemixIcons.road_map_line,
                  clearance: 0,
                ),
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Message only',
          children: [
            card(
              const LqEmptyState(
                icon: RemixIcons.receipt_line,
                title: 'No receipts this month',
                message:
                    'Snap fuel, tolls and parking receipts to add them here.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

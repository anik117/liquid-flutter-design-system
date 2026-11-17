import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class CountBadgeDemo extends StatefulWidget {
  const CountBadgeDemo({super.key});

  @override
  State<CountBadgeDemo> createState() => _CountBadgeDemoState();
}

class _CountBadgeDemoState extends State<CountBadgeDemo> {
  int _toReview = 3;

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Count',
          caption: 'Pops on change and hides at 0.',
          children: [
            Row(
              children: [
                LqCountBadge(
                  count: _toReview,
                  child: LqIconButton(
                    icon: RemixIcons.inbox_line,
                    semanticLabel: '$_toReview drives to review',
                    variant: LqIconButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: LqSpace.x6),
                LqCountBadge(
                  count: 128,
                  tone: LqTone.accent,
                  child: LqIconButton(
                    icon: RemixIcons.receipt_line,
                    semanticLabel: '128 receipts',
                    variant: LqIconButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: LqSpace.x6),
                LqCountBadge(
                  count: 1,
                  dot: true,
                  child: LqIconButton(
                    icon: RemixIcons.notification_3_line,
                    semanticLabel: 'Notifications, new',
                    variant: LqIconButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: LqButton(
                    label: 'Review one',
                    variant: LqButtonVariant.secondary,
                    onPressed: _toReview == 0
                        ? null
                        : () => setState(() => _toReview--),
                  ),
                ),
                const SizedBox(width: LqSpace.x3),
                Expanded(
                  child: LqButton(
                    label: 'New drive',
                    variant: LqButtonVariant.secondary,
                    onPressed: () => setState(() => _toReview++),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

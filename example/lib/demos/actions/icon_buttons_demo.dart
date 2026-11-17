import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class IconButtonsDemo extends StatelessWidget {
  const IconButtonsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const variants = [
      (LqIconButtonVariant.glass, 'Glass: bars and floating controls; swells when held'),
      (LqIconButtonVariant.primary, 'Primary: the one main action, e.g. Start drive'),
      (LqIconButtonVariant.secondary, 'Secondary: a bordered face on content'),
      (LqIconButtonVariant.ghost, 'Ghost: a soft brand tint'),
      (LqIconButtonVariant.plain, 'Plain: icon only'),
    ];
    return DemoColumn(
      children: [
        LqSection(
          title: 'Variants',
          children: [
            for (final (v, text) in variants)
              Row(
                children: [
                  LqIconButton(
                    icon: v == LqIconButtonVariant.primary
                        ? RemixIcons.steering_2_fill
                        : RemixIcons.add_line,
                    semanticLabel: text,
                    variant: v,
                    onPressed: () {},
                  ),
                  const SizedBox(width: LqSpace.x4),
                  Expanded(
                    child: Text(
                      text,
                      style: context.lq.type.subhead.copyWith(color: context.lq.colors.textSecondary),
                    ),
                  ),
                ],
              ),
          ],
        ),
        LqSection(
          title: 'Disabled',
          children: [
            Row(
              children: [
                for (final v in LqIconButtonVariant.values) ...[
                  LqIconButton(
                    icon: RemixIcons.add_line,
                    semanticLabel: 'Add (unavailable)',
                    variant: v,
                    onPressed: null,
                  ),
                  const SizedBox(width: LqSpace.x3),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}

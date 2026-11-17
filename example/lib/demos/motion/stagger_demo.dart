import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'drive_data.dart';

class StaggerDemo extends StatefulWidget {
  const StaggerDemo({super.key});

  @override
  State<StaggerDemo> createState() => _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo> {
  int _run = 0;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Recent drives',
          caption: 'Rows fade and rise in, 35 ms apart, the first time the list builds.',
          trailing: LqButton(
            label: 'Replay',
            size: LqButtonSize.small,
            variant: LqButtonVariant.secondary,
            leadingIcon: RemixIcons.restart_line,
            onPressed: () => setState(() => _run++),
          ),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(lq.radius.lg),
              child: LqStagger(
                key: ValueKey(_run),
                children: [
                  for (var i = 0; i < 6; i++) ...[
                    if (i > 0) Container(height: 0.5, color: lq.colors.separator),
                    DemoDriveRow(drive: demoDrives[i]),
                  ],
                ],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Cards',
          caption: 'Any widgets work: here, stat cards with a gap.',
          children: [
            LqStagger(
              key: ValueKey('cards$_run'),
              spacing: LqSpace.x3,
              offset: 16,
              children: [
                for (final (label, value, unit) in [
                  ('Business miles', 7905.0, 'mi'),
                  ('Deductions', 5731.13, null),
                  ('Drives logged', 612.0, null),
                ])
                  LqCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: lq.type.footnoteMedium.copyWith(color: lq.colors.textSecondary)),
                        const SizedBox(height: LqSpace.x1),
                        LqAmount(
                          value: value,
                          unit: unit,
                          prefix: label == 'Deductions' ? r'$' : null,
                          decimals: label == 'Deductions' ? 2 : 0,
                          style: lq.type.title2,
                        ),
                      ],
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

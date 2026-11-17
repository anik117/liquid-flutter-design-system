import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class ProgressDemo extends StatefulWidget {
  const ProgressDemo({super.key});

  @override
  State<ProgressDemo> createState() => _ProgressDemoState();
}

class _ProgressDemoState extends State<ProgressDemo> {
  double _export = 0.35;
  double _reviewed = 0.72;

  void _step() => setState(() {
    _export = _export >= 1 ? 0.1 : (_export + 0.25).clamp(0, 1);
    _reviewed = _reviewed >= 1 ? 0.3 : (_reviewed + 0.14).clamp(0, 1);
  });

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    Text caption(String s) =>
        Text(s, style: lq.type.subhead.copyWith(color: c.textSecondary));
    return DemoColumn(
      children: [
        LqSection(
          title: 'Progress bar',
          caption: 'Determinate values spring into place.',
          trailing: LqButton(
            label: 'Advance',
            variant: LqButtonVariant.plain,
            size: LqButtonSize.small,
            onPressed: _step,
          ),
          children: [
            caption(
              'Exporting Schedule C report · ${(_export * 100).round()}%',
            ),
            LqProgressBar(
              value: _export,
              semanticLabel: 'Exporting Schedule C report',
            ),
            caption('Matching receipts to drives…'),
            const LqProgressBar(semanticLabel: 'Matching receipts'),
          ],
        ),
        LqSection(
          title: 'Progress ring',
          caption: 'Small, medium and large.',
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LqProgressRing(
                  value: _reviewed,
                  size: LqProgressRingSize.small,
                ),
                LqProgressRing(
                  value: _reviewed,
                  semanticLabel: 'Trips reviewed',
                  child: Text(
                    '${(_reviewed * 100).round()}%',
                    style: LqTypography.numeric(lq.type.subheadMedium),
                  ),
                ),
                LqProgressRing(
                  value: _reviewed,
                  size: LqProgressRingSize.large,
                  semanticLabel: 'Trips reviewed',
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(_reviewed * 100).round()}%',
                        style: LqTypography.numeric(lq.type.title2),
                      ),
                      Text(
                        'reviewed',
                        style: lq.type.caption.copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            caption(
              '${(_reviewed * 100).round()}% of trips reviewed this quarter',
            ),
          ],
        ),
        LqSection(
          title: 'Spinner',
          caption: 'Native petals on iOS, an accent arc on Android.',
          children: [
            Row(
              children: [
                const LqSpinner(),
                const SizedBox(width: LqSpace.x3),
                caption('Syncing 14 drives…'),
                const Spacer(),
                const LqSpinner(size: 32),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

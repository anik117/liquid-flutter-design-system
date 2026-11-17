import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class CounterDemo extends StatefulWidget {
  const CounterDemo({super.key});

  @override
  State<CounterDemo> createState() => _CounterDemoState();
}

class _CounterDemoState extends State<CounterDemo> {
  static const _start = 48981.6;
  double _odometer = _start;
  int _drives = 612;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Odometer',
          caption: 'Each wheel rolls to its new digit on a spring. 9 rolls on to 0.',
          children: [
            LqCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Camry Hybrid', style: lq.type.subheadMedium.copyWith(color: c.textSecondary)),
                  const SizedBox(height: LqSpace.x2),
                  LqCounter(value: _odometer, decimals: 1, suffix: 'mi'),
                  const SizedBox(height: LqSpace.x1),
                  LqCounter(
                    value: (_odometer - _start) * 0.725,
                    decimals: 2,
                    prefix: r'$',
                    suffix: 'deducted today',
                    style: lq.type.title3,
                    color: c.positive,
                  ),
                  const SizedBox(height: LqSpace.x4),
                  Row(
                    children: [
                      LqButton(
                        label: '+ 18.2 mi',
                        size: LqButtonSize.small,
                        leadingIcon: RemixIcons.steering_2_line,
                        onPressed: () => setState(() => _odometer += 18.2),
                      ),
                      const SizedBox(width: LqSpace.x2),
                      LqButton(
                        label: 'Reset',
                        size: LqButtonSize.small,
                        variant: LqButtonVariant.secondary,
                        onPressed: () => setState(() => _odometer = _start),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Whole numbers',
          caption: 'Gaining a digit (999 → 1,000) adds a wheel on the left.',
          children: [
            Row(
              children: [
                Expanded(
                  child: LqCounter(value: _drives.toDouble(), suffix: 'drives', style: lq.type.title1),
                ),
                LqButton(
                  label: '+ 97',
                  size: LqButtonSize.small,
                  variant: LqButtonVariant.secondary,
                  onPressed: () => setState(() => _drives = _drives >= 1200 ? 612 : _drives + 97),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

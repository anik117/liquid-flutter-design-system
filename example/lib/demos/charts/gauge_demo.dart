import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class GaugeDemo extends StatefulWidget {
  const GaugeDemo({super.key});

  @override
  State<GaugeDemo> createState() => _GaugeDemoState();
}

class _GaugeDemoState extends State<GaugeDemo> {
  double _saved = 1240;
  double _fuel = 284;

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Quarterly tax set aside',
          caption: 'Add to the jar: the arc swings on a spring.',
          children: [
            LqCard(
              child: Column(
                children: [
                  LqGaugeChart(
                    value: _saved,
                    target: 1800,
                    prefix: r'$',
                    caption: r'of $1,800 for Q4',
                    semanticLabel: 'Q4 tax set aside',
                  ),
                  const SizedBox(height: LqSpace.x4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LqButton(
                        label: r'+ $60',
                        size: LqButtonSize.small,
                        onPressed: _saved >= 1800 ? null : () => setState(() => _saved += 60),
                      ),
                      const SizedBox(width: LqSpace.x2),
                      LqButton(
                        label: 'Reset',
                        size: LqButtonSize.small,
                        variant: LqButtonVariant.secondary,
                        onPressed: () => setState(() => _saved = 1240),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Caution past a cap',
          caption: r'Fuel spend this month; the arc warns above $300.',
          children: [
            LqCard(
              child: Column(
                children: [
                  LqGaugeChart(
                    value: _fuel,
                    target: 360,
                    prefix: r'$',
                    caption: r'$300 budget',
                    cautionAbove: 300,
                    size: 200,
                    semanticLabel: 'Fuel spend this month',
                  ),
                  const SizedBox(height: LqSpace.x4),
                  LqButton(
                    label: 'Log a fill-up',
                    size: LqButtonSize.small,
                    variant: LqButtonVariant.secondary,
                    leadingIcon: RemixIcons.gas_station_line,
                    onPressed: () => setState(() => _fuel = _fuel >= 330 ? 284 : _fuel + 42),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

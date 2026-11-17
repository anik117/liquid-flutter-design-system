import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'chart_data.dart';

class ProgressListDemo extends StatefulWidget {
  const ProgressListDemo({super.key});

  @override
  State<ProgressListDemo> createState() => _ProgressListDemoState();
}

class _ProgressListDemoState extends State<ProgressListDemo> {
  bool _late = false;

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'November budget',
          caption: 'Actual against budget. Over-budget rows turn amber.',
          trailing: LqButton(
            label: _late ? 'Nov 10' : 'Nov 30',
            size: LqButtonSize.small,
            variant: LqButtonVariant.secondary,
            onPressed: () => setState(() => _late = !_late),
          ),
          children: [
            LqCard(
              child: LqProgressBarList(
                valueLabel: ChartData.dollars,
                semanticLabel: 'November budget',
                items: [
                  LqProgressItem(label: 'Fuel', value: _late ? 342 : 184, target: 320),
                  LqProgressItem(label: 'Tolls', value: _late ? 72 : 38, target: 60),
                  LqProgressItem(label: 'Parking', value: _late ? 41 : 22, target: 50),
                  LqProgressItem(label: 'Car wash', value: _late ? 24 : 12, target: 30),
                ],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Goals',
          caption: 'Passing a goal is good, so it stays green.',
          children: [
            LqCard(
              child: LqProgressBarList(
                valueLabel: ChartData.miles,
                semanticLabel: 'Mileage goals',
                items: const [
                  LqProgressItem(label: 'Business miles', value: 7905, target: 8500, overIsGood: true),
                  LqProgressItem(label: 'Logged this week', value: 284, target: 250, overIsGood: true),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

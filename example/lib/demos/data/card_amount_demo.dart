import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class CardAmountDemo extends StatefulWidget {
  const CardAmountDemo({super.key});

  @override
  State<CardAmountDemo> createState() => _CardAmountDemoState();
}

class _CardAmountDemoState extends State<CardAmountDemo> {
  double _miles = 7821.2;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return DemoColumn(
      children: [
        LqSection(
          title: 'The one big number',
          caption: 'Tap the card: the value blurs into the new one.',
          children: [
            LqCard(
              onTap: () => setState(() => _miles += 18.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deductions this year',
                      style: lq.type.subheadMedium.copyWith(color: lq.colors.textSecondary)),
                  const SizedBox(height: LqSpace.x2),
                  LqAmount(value: _miles * 0.76, prefix: r'$'),
                  const SizedBox(height: LqSpace.x1),
                  LqAmount(value: _miles, unit: 'mi', decimals: 1, style: lq.type.title3),
                ],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Sizes',
          children: [
            LqAmount(value: 1639.85, prefix: r'$', style: lq.type.title1),
            LqAmount(value: 42.69, prefix: r'$', unit: '/ hr', style: lq.type.title2),
            LqAmount(value: 2157.7, unit: 'mi', decimals: 1, style: lq.type.headline),
          ],
        ),
      ],
    );
  }
}

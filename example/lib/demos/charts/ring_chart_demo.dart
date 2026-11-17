import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'chart_data.dart';

class RingChartDemo extends StatefulWidget {
  const RingChartDemo({super.key});

  @override
  State<RingChartDemo> createState() => _RingChartDemoState();
}

class _RingChartDemoState extends State<RingChartDemo> {
  bool _quarter = false;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final (business, personal, commute) = _quarter ? (2394.0, 331.0, 168.0) : (7905.0, 1210.0, 640.0);
    final total = business + personal + commute;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Miles by purpose',
          caption: 'Switch the period: the ring morphs to the new shares.',
          children: [
            LqSegmentedControl<bool>(
              segments: const [
                LqSegment(value: false, label: '2026'),
                LqSegment(value: true, label: 'Q4'),
              ],
              value: _quarter,
              onChanged: (v) => setState(() => _quarter = v),
            ),
            LqCard(
              child: LqRingChart(
                semanticLabel: 'Miles by purpose',
                valueLabel: ChartData.miles,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LqAmount(value: total, decimals: 0, style: lq.type.title2),
                    Text('miles', style: lq.type.footnote.copyWith(color: lq.colors.textSecondary)),
                  ],
                ),
                segments: [
                  LqRingSegment(label: 'Business', value: business),
                  LqRingSegment(label: 'Personal', value: personal, tone: LqTone.neutral),
                  LqRingSegment(label: 'Commute', value: commute, tone: LqTone.caution),
                ],
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Small, no legend',
          children: [
            Center(
              child: LqRingChart(
                size: 96,
                thickness: 10,
                showLegend: false,
                semanticLabel: 'Drives reviewed',
                center: Text('81%', style: lq.type.headline.copyWith(color: lq.colors.textPrimary)),
                segments: const [
                  LqRingSegment(label: 'Reviewed', value: 81),
                  LqRingSegment(label: 'To review', value: 19, tone: LqTone.neutral),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

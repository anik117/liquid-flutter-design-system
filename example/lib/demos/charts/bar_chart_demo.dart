import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'chart_data.dart';

class BarChartDemo extends StatefulWidget {
  const BarChartDemo({super.key});

  @override
  State<BarChartDemo> createState() => _BarChartDemoState();
}

class _BarChartDemoState extends State<BarChartDemo> {
  final _random = math.Random(7);
  List<double> _values = ChartData.deductions;
  int? _picked;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final picked = _picked;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Deductions by month',
          caption: 'Tap or drag across the bars. November is this month.',
          trailing: LqButton(
            label: 'Shuffle data',
            size: LqButtonSize.small,
            variant: LqButtonVariant.secondary,
            leadingIcon: RemixIcons.shuffle_line,
            onPressed: () => setState(() => _values = ChartData.shuffle(ChartData.deductions, _random)),
          ),
          children: [
            LqCard(
              child: LqBarChart(
                values: _values,
                labels: ChartData.monthsSoFar,
                highlighted: 10,
                valueLabel: ChartData.dollars,
                semanticLabel: 'Deductions by month, 2026',
                onSelected: (i) => setState(() => _picked = i),
              ),
            ),
            Text(
              picked == null
                  ? 'Nothing picked'
                  : '${ChartData.months[picked]}: ${ChartData.dollars(_values[picked])} deducted',
              style: lq.type.footnote.copyWith(color: lq.colors.textSecondary),
            ),
          ],
        ),
        LqSection(
          title: 'Compact',
          caption: 'Drives per weekday, no highlight.',
          children: [
            LqCard(
              child: LqBarChart(
                values: const [14, 18, 17, 21, 26, 31, 12],
                labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                height: 150,
                valueLabel: (v) => '${v.round()} drives',
                semanticLabel: 'Drives per weekday',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

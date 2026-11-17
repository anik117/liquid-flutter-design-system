import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class HeatmapDemo extends StatefulWidget {
  const HeatmapDemo({super.key});

  @override
  State<HeatmapDemo> createState() => _HeatmapDemoState();
}

class _HeatmapDemoState extends State<HeatmapDemo> {
  static final _end = DateTime(2026, 11, 17);
  DateTime? _picked;

  /// Drives per day for 12 weeks: busy Fri–Sat, quiet Sundays, a week off
  /// in mid-September.
  static final _drives = [
    for (var k = 0; k < 84; k++)
      () {
        final day = DateTime(_end.year, _end.month, _end.day - (83 - k));
        if (day.month == 9 && day.day >= 14 && day.day <= 20) return 0.0;
        final base = switch (day.weekday) { 5 || 6 => 7, 7 => 1, _ => 4 };
        return (base + (k * 7 % 5) - 2).clamp(0, 12).toDouble();
      }(),
  ];

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final p = _picked;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Drives per day',
          caption: 'Last 12 weeks. Tap a day, or drag along a row.',
          children: [
            LqCard(
              child: LqHeatmap(
                values: _drives,
                end: _end,
                valueLabel: (v) => v == 1 ? '1 drive' : '${v.round()} drives',
                semanticLabel: 'Drives per day, last 12 weeks',
                onSelected: (d) => setState(() => _picked = d),
              ),
            ),
            Text(
              p == null ? 'No day picked' : 'Picked ${p.month}/${p.day}/${p.year}',
              style: lq.type.footnote.copyWith(color: lq.colors.textSecondary),
            ),
          ],
        ),
        LqSection(
          title: 'Fewer weeks',
          caption: 'Six weeks fit a narrow tile.',
          children: [
            LqCard(
              child: LqHeatmap(
                values: _drives.sublist(42),
                end: _end,
                weeks: 6,
                valueLabel: (v) => '${v.round()} drives',
                semanticLabel: 'Drives per day, last 6 weeks',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../data/amount.dart';
import '../data/card.dart';
import '../feedback/badge.dart';
import '../inputs/segmented_control.dart';

/// A consistent chart block for app screens: a quiet title, the big value
/// ([LqAmount]), a delta line ("↗ 12% vs last month"), an optional period
/// switch (Week / Month / Year) and the chart, on one opaque card.
class LqChartCard extends StatelessWidget {
  const LqChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.value,
    this.prefix,
    this.unit,
    this.decimals = 0,
    this.delta,
    this.deltaTone = LqTone.positive,
    this.periods,
    this.period,
    this.onPeriodChanged,
    this.trailing,
  });

  /// What the card measures, e.g. "Deductions".
  final String title;

  /// The chart itself, e.g. an [LqBarChart].
  final Widget chart;

  /// The headline number; omitted when null.
  final double? value;

  /// Currency sign before, or unit after, the headline number.
  final String? prefix, unit;

  /// Decimals of the headline number.
  final int decimals;

  /// The change line, e.g. "12% vs October".
  final String? delta;

  /// Positive shows a rising arrow; caution or danger a falling one.
  final LqTone deltaTone;

  /// Period choices, e.g. ["Week", "Month", "Year"].
  final List<String>? periods;

  /// The chosen period.
  final String? period;

  /// Called when another period is chosen.
  final ValueChanged<String>? onPeriodChanged;

  /// A small action beside the title, e.g. a plain "See all" button.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final falling = deltaTone == LqTone.caution || deltaTone == LqTone.danger;
    final (_, deltaColor) = LqBadge.colorsFor(c, deltaTone);
    return LqCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: lq.type.subheadMedium.copyWith(color: c.textSecondary)),
              ),
              ?trailing,
            ],
          ),
          if (value != null) ...[
            const SizedBox(height: LqSpace.x1),
            LqAmount(value: value!, prefix: prefix, unit: unit, decimals: decimals,
                style: lq.type.title1),
          ],
          if (delta != null) ...[
            const SizedBox(height: LqSpace.x1),
            Row(
              children: [
                Icon(falling ? RemixIcons.arrow_right_down_line : RemixIcons.arrow_right_up_line,
                    size: 16, color: deltaColor),
                const SizedBox(width: LqSpace.x1),
                Expanded(
                  child: Text(delta!,
                      style: lq.type.footnoteMedium.copyWith(color: deltaColor)),
                ),
              ],
            ),
          ],
          if (periods != null && period != null && onPeriodChanged != null) ...[
            const SizedBox(height: LqSpace.x4),
            LqSegmentedControl<String>(
              segments: [for (final p in periods!) LqSegment(value: p, label: p)],
              value: period!,
              onChanged: onPeriodChanged!,
            ),
          ],
          const SizedBox(height: LqSpace.x4),
          chart,
        ],
      ),
    );
  }
}

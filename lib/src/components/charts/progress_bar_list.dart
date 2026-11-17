import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/typography.dart';
import 'chart_scale.dart';

/// One "actual vs target" row, e.g. Fuel $284 of a $320 budget.
class LqProgressItem {
  const LqProgressItem({
    required this.label,
    required this.value,
    required this.target,
    this.overIsGood = false,
  });

  /// Row name, e.g. "Fuel".
  final String label;

  /// The actual amount so far.
  final double value;

  /// The budget or goal; drawn as a marker on the track.
  final double target;

  /// Goals (miles logged) are good to pass; budgets turn caution when over.
  final bool overIsGood;
}

/// Budget-vs-actual rows: a label with "actual / target" on the right and a
/// track with a fill and a target marker. Fills grow in one after another
/// and morph when values change. Over-budget rows turn the caution color.
class LqProgressBarList extends StatelessWidget {
  const LqProgressBarList({
    super.key,
    required this.items,
    this.valueLabel,
    this.semanticLabel,
  });

  /// The rows, top to bottom.
  final List<LqProgressItem> items;

  /// Formats both numbers, e.g. `(v) => '\$${v.round()}'`.
  final String Function(double value)? valueLabel;

  /// What the list compares, e.g. "November budget".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final fmt = valueLabel ?? ChartScale.number;
    final strong = LqTypography.numeric(lq.type.subheadMedium).copyWith(color: c.textPrimary);
    final quiet = LqTypography.numeric(lq.type.subhead).copyWith(color: c.textSecondary);

    return Semantics(
      container: true,
      label: semanticLabel,
      value: [
        for (final i in items)
          '${i.label} ${fmt(i.value)} of ${fmt(i.target)}${i.value > i.target ? ', over' : ''}',
      ].join('; '),
      child: ExcludeSemantics(
        child: ChartEntrance(
          duration: ChartScale.entrance(items.length),
          builder: (context, t) => ChartMorph(
            frame: ChartFrame([
              [for (final i in items) i.value],
              [for (final i in items) i.target],
            ], 1),
            builder: (context, f) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: LqSpace.x4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(items[i].label,
                            style: lq.type.body.copyWith(color: c.textPrimary)),
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(text: fmt(items[i].value), style: strong),
                        TextSpan(text: ' / ${fmt(items[i].target)}', style: quiet),
                      ])),
                    ],
                  ),
                  const SizedBox(height: LqSpace.x2),
                  _Track(
                    value: f.series[0][i],
                    target: f.series[1][i],
                    grow: ChartScale.stagger(t, i, items.length),
                    color: f.series[0][i] > f.series[1][i] && !items[i].overIsGood
                        ? c.caution
                        : c.accent,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Track extends StatelessWidget {
  const _Track({required this.value, required this.target, required this.grow, required this.color});

  final double value, target, grow;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final scale = math.max(math.max(value, target), 1e-9);
    return LayoutBuilder(builder: (context, box) {
      final w = box.maxWidth;
      final fill = (value / scale * grow).clamp(0.0, 1.0) * w;
      final mark = (target / scale).clamp(0.0, 1.0) * w;
      return SizedBox(
        height: 14,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: c.surfaceSunken,
                borderRadius: BorderRadius.circular(LqRadius.full),
              ),
            ),
            Container(
              width: fill,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(LqRadius.full),
                gradient: LinearGradient(colors: [Color.lerp(color, c.surface, 0.3)!, color]),
              ),
            ),
            Positioned(
              left: (mark - 1).clamp(0.0, math.max(0.0, w - 2)),
              top: 0,
              bottom: 0,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  color: c.textPrimary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

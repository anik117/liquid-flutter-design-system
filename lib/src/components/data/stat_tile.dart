import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/typography.dart';
import 'amount.dart';
import 'card.dart';

/// One metric on a card: a quiet label, the value as an [LqAmount], and an
/// optional change versus a previous period ("↑ 12% vs last month"). Sized
/// to sit two-up in a grid. Pass [onTap] to make it open a detail.
class LqStatTile extends StatelessWidget {
  const LqStatTile({
    super.key,
    required this.label,
    required this.value,
    this.prefix,
    this.unit,
    this.decimals = 0,
    this.icon,
    this.delta,
    this.deltaSuffix = '%',
    this.deltaLabel = 'vs last month',
    this.higherIsBetter = true,
    this.onTap,
  });

  /// What the number is, e.g. "Deductions".
  final String label;

  /// The metric.
  final double value;

  /// Currency sign before the value, e.g. "$".
  final String? prefix;

  /// Unit after the value, e.g. "mi".
  final String? unit;

  /// Digits after the decimal point.
  final int decimals;

  /// Small glyph on the label row.
  final IconData? icon;

  /// Change since the previous period; positive is up. Null hides the row.
  final double? delta;

  /// Shown after the change, e.g. "%" or " mi".
  final String deltaSuffix;

  /// Quiet text after the change.
  final String deltaLabel;

  /// Whether a rise is good news (miles) or bad news (fuel cost).
  final bool higherIsBetter;

  /// Opens a detail; null keeps the tile static.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return Semantics(
      container: true,
      child: LqCard(
        onTap: onTap,
        padding: const EdgeInsets.all(LqSpace.x4 - 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: lq.type.footnoteMedium.copyWith(color: c.textSecondary),
                  ),
                ),
                if (icon != null)
                  Icon(icon, size: LqIconSize.sm, color: c.iconSecondary),
              ],
            ),
            const SizedBox(height: LqSpace.x2),
            LqAmount(
              value: value,
              prefix: prefix,
              unit: unit,
              decimals: decimals,
              style: lq.type.title2,
            ),
            if (delta != null) ...[
              const SizedBox(height: LqSpace.x1),
              _delta(context, delta!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _delta(BuildContext context, double d) {
    final lq = context.lq;
    final c = lq.colors;
    final up = d >= 0;
    final good = up == higherIsBetter;
    final color = d == 0 ? c.textSecondary : (good ? c.positive : c.caution);
    final amount = d.abs().toStringAsFixed(d.abs() >= 10 ? 0 : 1);
    return Semantics(
      label: '${up ? 'Up' : 'Down'} $amount$deltaSuffix $deltaLabel',
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
              up ? RemixIcons.arrow_up_line : RemixIcons.arrow_down_line,
              size: LqIconSize.xs,
              color: color,
            ),
          ),
          TextSpan(
            text: '$amount$deltaSuffix',
            style: LqTypography.numeric(lq.type.footnoteMedium)
                .copyWith(color: color),
          ),
          TextSpan(
            text: ' $deltaLabel',
            style: lq.type.footnote.copyWith(color: c.textTertiary),
          ),
        ]),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

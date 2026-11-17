import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/typography.dart';
import 'list_group.dart';

/// One line of a [LqKeyValueList]: "Business miles … 7,905.2 mi".
class LqKeyValue {
  const LqKeyValue(this.label, this.value);

  /// What the value is, shown left in secondary text.
  final String label;

  /// The value, shown right in tabular figures.
  final String value;
}

/// A summary block: labels on the left, values on the right in tabular
/// figures, on an inset grouped surface. An optional [total] closes it under
/// a hairline in heavier type, like the bottom line of a receipt.
class LqKeyValueList extends StatelessWidget {
  const LqKeyValueList({
    super.key,
    required this.items,
    this.total,
    this.header,
    this.footer,
  });

  /// The summary lines, top to bottom.
  final List<LqKeyValue> items;

  /// The emphasized bottom line, e.g. "Deduction … $6,007.95".
  final LqKeyValue? total;

  /// Sentence-case title above the surface.
  final String? header;

  /// Quiet note under the surface.
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final label = lq.type.body.copyWith(color: c.textSecondary);
    final value = LqTypography.numeric(lq.type.body).copyWith(color: c.textPrimary);

    return LqListGroup(
      header: header,
      footer: footer,
      leadingInset: false,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LqSpace.x4,
            vertical: LqSpace.x3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: LqSpace.x2 + 2),
                _row(items[i], label, value),
              ],
              if (total != null) ...[
                const SizedBox(height: LqSpace.x3),
                Container(height: 0.5, color: c.separator),
                const SizedBox(height: LqSpace.x3),
                _row(
                  total!,
                  lq.type.headline.copyWith(color: c.textPrimary),
                  LqTypography.numeric(lq.type.headline)
                      .copyWith(color: c.textPrimary),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(LqKeyValue kv, TextStyle labelStyle, TextStyle valueStyle) =>
      MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(kv.label, style: labelStyle)),
            const SizedBox(width: LqSpace.x3),
            Flexible(
              child: Text(
                kv.value,
                textAlign: TextAlign.right,
                style: valueStyle,
              ),
            ),
          ],
        ),
      );
}

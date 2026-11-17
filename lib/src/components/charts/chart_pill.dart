import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/typography.dart';
import 'chart_legend.dart';

/// The value pill that floats above a picked bar, point or cell, e.g.
/// "Mar  $603". Inverted (dark on light pages, light on dark) so it reads
/// over any mark color. [entries] add a compact breakdown line.
class LqChartPill extends StatelessWidget {
  const LqChartPill({
    super.key,
    required this.value,
    this.title,
    this.entries = const [],
  });

  /// The picked value, already formatted.
  final String value;

  /// What was picked, e.g. "Mar" or "Tue, Nov 4".
  final String? title;

  /// Per-series values for stacked or multi-series charts.
  final List<LqLegendEntry> entries;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final fg = c.surface;
    final muted = Color.lerp(fg, c.textPrimary, 0.4)!;
    final strong = LqTypography.numeric(lq.type.footnoteMedium).copyWith(color: fg);
    final small = LqTypography.numeric(lq.type.caption).copyWith(color: muted);

    return Semantics(
      liveRegion: true,
      label: [
        ?title,
        value,
        for (final e in entries) '${e.label} ${e.value ?? ''}',
      ].join(', '),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: c.textPrimary,
          borderRadius: BorderRadius.circular(entries.isEmpty ? LqRadius.full : lq.radius.md),
          boxShadow: LqShadows.sm(c.shadow),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(children: [
                if (title != null) TextSpan(text: '$title  ', style: small),
                TextSpan(text: value, style: strong),
              ]),
              maxLines: 1,
            ),
            if (entries.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < entries.length; i++) ...[
                    if (i > 0) const SizedBox(width: LqSpace.x2),
                    LegendMark(color: entries[i].color, dashed: entries[i].dashed, size: 6),
                    const SizedBox(width: 4),
                    Text(entries[i].value ?? entries[i].label, style: small),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

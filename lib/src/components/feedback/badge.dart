import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/colors.dart';
import '../../tokens/metrics.dart';

/// What a badge means. Color carries meaning only through these tones.
enum LqTone { neutral, accent, positive, caution, danger, info }

/// A small status label: a soft tint with matching text.
class LqBadge extends StatelessWidget {
  const LqBadge({
    super.key,
    required this.label,
    this.tone = LqTone.neutral,
    this.icon,
    this.dot = false,
  });

  final String label;
  final LqTone tone;
  final IconData? icon;

  /// A leading status dot instead of an icon.
  final bool dot;

  static (Color bg, Color fg) colorsFor(LqColors c, LqTone tone) =>
      switch (tone) {
        LqTone.neutral => (c.surfaceSunken, c.textSecondary),
        LqTone.accent => (c.accentSoft, c.accentOnSoft),
        LqTone.positive => (c.positiveSoft, c.positive),
        LqTone.caution => (c.cautionSoft, c.caution),
        LqTone.danger => (c.dangerSoft, c.textDanger),
        LqTone.info => (c.infoSoft, c.info),
      };

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final (bg, fg) = colorsFor(lq.colors, tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: LqSpace.x2, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(lq.radius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ] else if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: LqSpace.x1),
          ],
          Text(label, style: lq.type.caption.copyWith(color: fg)),
        ],
      ),
    );
  }
}

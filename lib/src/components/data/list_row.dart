import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/hues.dart';
import '../../tokens/motion.dart';
import '../../tokens/palette.dart';
import '../feedback/badge.dart';

/// A rounded tile holding one glyph (32pt by default). Neutral unless given
/// a [tone] (status) or a [hue] (category). [filled] paints a solid fill
/// (the hue, or the brand accent without one) with a white glyph, for the
/// one tile that should lead the eye. [subtle] keeps the neutral tile and
/// tints only the glyph, so category icons stay a quiet touch and never
/// look like a button. [circle] draws a disc instead of a rounded square.
class LqIconTile extends StatelessWidget {
  const LqIconTile({
    super.key,
    required this.icon,
    this.tone,
    this.hue,
    this.size = LqSize.iconTile,
    this.filled = false,
    this.subtle = false,
    this.circle = false,
  });

  final bool subtle;
  final bool circle;
  final IconData icon;
  final LqTone? tone;
  final LqHue? hue;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final h = hue;
    var (bg, fg) = h != null
        ? (filled ? (h.s600, LqPalette.white) : (h.soft(c), h.onSoft(c)))
        : filled
            ? (c.accentBottom, LqPalette.white)
            : tone == null
            ? (c.surfaceSunken, c.iconPrimary)
            : LqBadge.colorsFor(c, tone!);
    if (subtle && !filled) {
      bg = c.surfaceSunken;
      if (tone == null && h == null) fg = c.iconSecondary;
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(lq.radius.sm * size / LqSize.iconTile),
      ),
      child: Icon(icon, size: size * 0.56, color: fg),
    );
  }
}

/// One row in a [LqListGroup]: leading tile, title, optional subtitle, and
/// a trailing value, widget or chevron. Rows highlight when pressed rather
/// than shrinking, so a list never jiggles.
class LqListRow extends StatelessWidget {
  const LqListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.value,
    this.trailing,
    this.onTap,
    this.showChevron,
    this.destructive = false,
    this.titleMaxLines,
  });

  final String title;

  /// Caps the title's lines (1 keeps a list's rows even); null wraps freely.
  final int? titleMaxLines;
  final String? subtitle;
  final Widget? leading;

  /// Secondary text on the right, e.g. "72.5¢ / mi".
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Defaults to true when the row is tappable and has no [trailing].
  final bool? showChevron;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final chevron = showChevron ?? (onTap != null && trailing == null);

    return LqPressable(
      onTap: onTap,
      scale: 1,
      haptic: LqHaptic.selection,
      semanticLabel: title,
      builder: (context, pressed) => AnimatedContainer(
        duration: LqMotion.fast,
        color: pressed ? c.surfacePressed : c.surface,
        constraints: const BoxConstraints(minHeight: LqSize.row),
        padding: const EdgeInsets.symmetric(
          horizontal: LqSpace.x4,
          vertical: LqSpace.x2 + 2,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: LqSpace.x3)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: titleMaxLines,
                    overflow: titleMaxLines == null ? null : TextOverflow.ellipsis,
                    style: lq.type.body.copyWith(
                      color: destructive ? c.textDanger : c.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: lq.type.subhead.copyWith(color: c.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: LqSpace.x3),
              Text(value!, style: lq.type.body.copyWith(color: c.textSecondary)),
            ],
            if (trailing != null) ...[const SizedBox(width: LqSpace.x3), trailing!],
            if (chevron) ...[
              const SizedBox(width: LqSpace.x1),
              Icon(RemixIcons.arrow_right_s_line, size: 20, color: c.iconTertiary),
            ],
          ],
        ),
      ),
    );
  }
}

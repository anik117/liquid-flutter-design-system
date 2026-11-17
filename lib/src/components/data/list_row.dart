import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import '../feedback/badge.dart';

/// A 32pt rounded tile holding one glyph. Neutral by default; a [tone]
/// colors the glyph only, never a bright disc.
class LqIconTile extends StatelessWidget {
  const LqIconTile({super.key, required this.icon, this.tone});

  final IconData icon;
  final LqTone? tone;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final (bg, fg) = tone == null
        ? (c.surfaceSunken, c.iconPrimary)
        : LqBadge.colorsFor(c, tone!);
    return Container(
      width: LqSize.iconTile,
      height: LqSize.iconTile,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(lq.radius.sm),
      ),
      child: Icon(icon, size: 18, color: fg),
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
  });

  final String title;
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

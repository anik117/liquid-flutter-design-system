import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/hues.dart';
import '../../tokens/metrics.dart';
import '../data/list_row.dart';

/// A quick action card for a two-up row: a round icon, a quiet [prompt]
/// ("On the road?") and the action in bold ("Start a drive"), on the same
/// plain card as the rest of the page. [primary] gives the main action a
/// solid brand disc; a [hue] gives another action a solid disc in that hue
/// (deep 600 step, white glyph); otherwise the disc is neutral.
/// Lay two side by side with `Expanded`.
class LqActionTile extends StatelessWidget {
  const LqActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.prompt,
    this.caption,
    this.hue,
    this.primary = false,
    this.minHeight = 128,
  });

  final IconData icon;

  /// The action, bold: "Start a drive".
  final String title;

  /// A quiet line above the title that frames when to use it: "On the road?"
  final String? prompt;

  /// An optional quiet line under the title.
  final String? caption;
  final VoidCallback? onPressed;

  /// A solid colored disc for a secondary action (ignored when [primary]).
  final LqHue? hue;
  final bool primary;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        LqIconTile(
          icon: icon,
          hue: primary ? null : hue,
          filled: primary || hue != null,
          subtle: !primary && hue == null,
          circle: true,
          size: 44,
        ),
        const SizedBox(height: LqSpace.x4),
        if (prompt != null) ...[
          Text(
            prompt!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: lq.type.subhead.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: 2),
        ],
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: lq.type.headline.copyWith(color: c.textPrimary),
        ),
        if (caption != null) ...[
          const SizedBox(height: 2),
          Text(
            caption!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: lq.type.footnote.copyWith(color: c.textSecondary),
          ),
        ],
      ],
    );

    Widget face(bool pressed) => Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(LqSpace.x4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(lq.radius.xl),
        color: pressed ? c.surfacePressed : c.surface,
        border: Border.all(color: c.border, width: 0.5),
        boxShadow: LqShadows.card(c.shadow),
      ),
      child: content,
    );

    return LqPressable(
      onTap: onPressed,
      scale: 0.97,
      haptic: primary ? LqHaptic.medium : LqHaptic.light,
      semanticLabel: [?prompt, title, ?caption].join('. '),
      builder: (context, pressed) => ExcludeSemantics(child: face(pressed)),
    );
  }
}

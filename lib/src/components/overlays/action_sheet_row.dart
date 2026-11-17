import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// One tappable row of an action sheet; internal to [showLqActionSheet].
class LqActionSheetRow extends StatelessWidget {
  const LqActionSheetRow({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
    this.icon,
    this.bold = false,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final IconData? icon;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final style = bold ? lq.type.headline : lq.type.body;
    return LqPressable(
      onTap: onTap,
      scale: 1,
      haptic: LqHaptic.selection,
      semanticLabel: label,
      builder: (context, pressed) => AnimatedContainer(
        duration: LqMotion.fast,
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: LqSpace.x5),
        color: pressed
            ? lq.colors.glassPressed
            : lq.colors.textPrimary.withValues(alpha: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: LqIconSize.lg, color: color),
              const SizedBox(width: LqSpace.x2),
            ],
            Flexible(
              child: Text(label, style: style.copyWith(color: color)),
            ),
          ],
        ),
      ),
    );
  }
}

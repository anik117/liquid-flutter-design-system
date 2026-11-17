import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// The filter chip's check: grows in from zero width on a spring and
/// shrinks away when deselected.
class LqChipCheck extends StatelessWidget {
  const LqChipCheck({super.key, required this.selected, required this.color});

  /// Whether the check is shown.
  final bool selected;

  /// The check's color, matching the label.
  final Color color;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(end: selected ? 1 : 0),
    duration: LqMotion.of(context, LqMotion.slow),
    curve: LqMotion.springCurve,
    builder: (context, t, child) => ClipRect(
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: t.clamp(0.0, 1.2),
        child: Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.scale(scale: 0.5 + 0.5 * t, child: child),
        ),
      ),
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: Icon(RemixIcons.check_line, size: LqIconSize.sm, color: color),
    ),
  );
}

/// The × at the end of an input chip. Its own semantics node, so screen
/// readers offer "Remove …" separately from the chip's value.
class LqChipRemoveButton extends StatelessWidget {
  const LqChipRemoveButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  /// The chip's label, used in the "Remove …" name.
  final String label;

  /// Starts the chip's collapse.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    return Semantics(
      container: true,
      child: LqPressable(
        onTap: onTap,
        haptic: LqHaptic.none,
        scale: 0.85,
        semanticLabel: 'Remove $label',
        builder: (context, _) => SizedBox(
          width: 32,
          height: LqSize.controlSmall,
          child: Icon(
            RemixIcons.close_line,
            size: LqIconSize.sm,
            color: c.iconSecondary,
          ),
        ),
      ),
    );
  }
}

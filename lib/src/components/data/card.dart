import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';

/// An opaque content card: white (or the dark surface), a hairline border
/// and BoardUI's 1px contact shadow. Use it for a screen's hero and for
/// self-contained blocks, never nested inside another card.
class LqCard extends StatelessWidget {
  const LqCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(LqSpace.x4),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    Widget face(bool pressed) => Container(
      padding: padding,
      decoration: BoxDecoration(
        color: pressed ? c.surfacePressed : c.surface,
        borderRadius: BorderRadius.circular(lq.radius.xl),
        border: Border.all(color: c.border, width: 0.5),
        boxShadow: LqShadows.card(c.shadow),
      ),
      child: child,
    );
    if (onTap == null) return face(false);
    return LqPressable(
      onTap: onTap,
      scale: 0.985,
      haptic: LqHaptic.selection,
      builder: (context, pressed) => face(pressed),
    );
  }
}

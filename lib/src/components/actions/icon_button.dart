import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

enum LqIconButtonVariant {
  /// Round Liquid Glass button for bars and floating actions.
  glass,

  /// Filled brand gradient: the one primary action in a bar.
  primary,

  /// White face with a hairline border.
  secondary,

  /// Soft brand tint.
  ghost,

  /// Icon only, no face, in the neutral secondary icon colour (green is
  /// kept for primary actions).
  plain,
}

/// A round icon button. Always pass [semanticLabel]: it is the only name a
/// screen reader gets.
class LqIconButton extends StatelessWidget {
  const LqIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.variant = LqIconButtonVariant.glass,
    this.size = LqSize.control,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final LqIconButtonVariant variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final iconSize = size >= LqSize.control ? 22.0 : 20.0;
    return LqPressable(
      onTap: onPressed,
      semanticLabel: semanticLabel,
      scale: variant == LqIconButtonVariant.glass
          ? LqMotion.glassPressScale
          : 0.92,
      builder: (context, pressed) {
        final enabled = onPressed != null;
        final fg = !enabled
            ? c.disabledText
            : switch (variant) {
                LqIconButtonVariant.primary => c.textOnAccent,
                LqIconButtonVariant.ghost => c.accentOnSoft,
                LqIconButtonVariant.plain => c.iconSecondary,
                _ => c.iconPrimary,
              };
        final glyph = Center(child: Icon(icon, size: iconSize, color: fg));
        if (variant == LqIconButtonVariant.glass) {
          return SizedBox.square(
            dimension: size,
            child: LqGlass(lit: pressed, child: glyph),
          );
        }
        final decoration = switch (variant) {
          LqIconButtonVariant.primary => BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: pressed
                  ? [c.accentPressedTop, c.accentPressedBottom]
                  : [c.accentTop, c.accentBottom],
            ),
            boxShadow: LqShadows.xs(c.shadow),
          ),
          LqIconButtonVariant.secondary => BoxDecoration(
            shape: BoxShape.circle,
            color: pressed ? c.surfacePressed : c.surface,
            border: Border.all(color: c.border),
            boxShadow: LqShadows.card(c.shadow),
          ),
          LqIconButtonVariant.ghost => BoxDecoration(
            shape: BoxShape.circle,
            color: pressed ? c.accentSoftPressed : c.accentSoft,
          ),
          _ => BoxDecoration(
            shape: BoxShape.circle,
            color: pressed ? c.surfacePressed : const Color(0x00000000),
          ),
        };
        return AnimatedContainer(
          duration: LqMotion.fast,
          width: size,
          height: size,
          decoration: decoration,
          child: glyph,
        );
      },
    );
  }
}

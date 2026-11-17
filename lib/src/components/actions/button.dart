import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show CircularProgressIndicator;

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/colors.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

enum LqButtonVariant { primary, secondary, ghost, danger, plain }

enum LqButtonSize { large, medium, small }

/// BoardUI's button: a top-lit gradient for primary and danger, a bordered
/// white face for secondary, a soft brand tint for ghost. Presses shrink to
/// 0.97 and darken; release springs back.
class LqButton extends StatelessWidget {
  const LqButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = LqButtonVariant.primary,
    this.size = LqButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.expand = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final LqButtonVariant variant;
  final LqButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  /// Stretch to the parent's width (sheet and form footers).
  final bool expand;

  /// Shows a spinner and blocks taps; keeps the button's width.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final enabled = onPressed != null && !loading;
    final height = switch (size) {
      LqButtonSize.large => LqSize.controlLarge,
      LqButtonSize.medium => LqSize.control,
      LqButtonSize.small => LqSize.controlSmall,
    };
    final radius = size == LqButtonSize.small ? lq.radius.sm : lq.radius.md;
    final textStyle = size == LqButtonSize.small
        ? lq.type.subheadMedium
        : lq.type.headline;

    return LqPressable(
      onTap: enabled ? onPressed : null,
      semanticLabel: label,
      haptic: variant == LqButtonVariant.primary
          ? LqHaptic.medium
          : LqHaptic.light,
      builder: (context, pressed) {
        final look = _look(lq.colors, enabled, pressed);
        final content = Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 20, color: look.foreground),
              const SizedBox(width: LqSpace.x2),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle.copyWith(color: look.foreground),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: LqSpace.x2),
              Icon(trailingIcon, size: 20, color: look.foreground),
            ],
          ],
        );
        return AnimatedContainer(
          duration: LqMotion.fast,
          height: height,
          padding: EdgeInsets.symmetric(
            horizontal: size == LqButtonSize.small ? LqSpace.x3 : LqSpace.x5,
          ),
          decoration: BoxDecoration(
            color: look.fill,
            gradient: look.gradient,
            borderRadius: BorderRadius.circular(radius),
            border: look.border == null ? null : Border.all(color: look.border!),
            boxShadow: look.raised ? LqShadows.xs(lq.colors.shadow) : null,
          ),
          // A faint top highlight: the lit bevel BoardUI puts on solid buttons.
          foregroundDecoration: look.gradient == null
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x38FFFFFF), Color(0x00FFFFFF)],
                    stops: [0, 0.12],
                  ),
                ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: loading ? 0 : 1, child: content),
              if (loading)
                SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(look.foreground),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  _Look _look(LqColors c, bool enabled, bool pressed) {
    if (!enabled && !loading) {
      return _Look(fill: c.disabledFill, foreground: c.disabledText);
    }
    LinearGradient g(Color top, Color bottom) => LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [top, bottom],
    );
    return switch (variant) {
      LqButtonVariant.primary => _Look(
        gradient: pressed
            ? g(c.accentPressedTop, c.accentPressedBottom)
            : g(c.accentTop, c.accentBottom),
        foreground: c.textOnAccent,
        raised: true,
      ),
      LqButtonVariant.danger => _Look(
        gradient: pressed
            ? g(c.dangerBottom, Color.lerp(c.dangerBottom, const Color(0xFF000000), 0.18)!)
            : g(c.dangerTop, c.dangerBottom),
        foreground: c.textOnAccent,
        raised: true,
      ),
      LqButtonVariant.secondary => _Look(
        fill: pressed ? c.surfacePressed : c.surface,
        border: pressed ? c.borderStrong : c.border,
        foreground: c.textPrimary,
        raised: !pressed,
      ),
      LqButtonVariant.ghost => _Look(
        fill: pressed ? c.accentSoftPressed : c.accentSoft,
        foreground: c.accentOnSoft,
      ),
      LqButtonVariant.plain => _Look(
        fill: pressed ? c.accentSoft : const Color(0x00000000),
        foreground: c.textAccent,
      ),
    };
  }
}

class _Look {
  const _Look({
    required this.foreground,
    this.fill,
    this.gradient,
    this.border,
    this.raised = false,
  });

  final Color foreground;
  final Color? fill;
  final Gradient? gradient;
  final Color? border;
  final bool raised;
}

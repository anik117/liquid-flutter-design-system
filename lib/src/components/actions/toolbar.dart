import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// One icon in an [LqToolbar].
class LqToolbarAction {
  const LqToolbarAction({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.destructive = false,
  });

  /// Line icon for the action.
  final IconData icon;

  /// Screen reader name, e.g. "Share trip".
  final String semanticLabel;

  /// Called on tap. Null disables the action.
  final VoidCallback? onPressed;

  /// Draws the icon in the danger color, e.g. Delete.
  final bool destructive;
}

/// A floating Liquid Glass capsule of 2–5 icon actions and an optional
/// text action at the end (e.g. "Done"). Icons swell under the finger like
/// glass icon buttons. Float it over content near the bottom of a screen.
class LqToolbar extends StatelessWidget {
  const LqToolbar({
    super.key,
    required this.actions,
    this.textAction,
    this.onTextAction,
  });

  /// The icon actions, two to five.
  final List<LqToolbarAction> actions;

  /// Label of the optional text action, e.g. "Done".
  final String? textAction;

  /// Called when the text action is tapped.
  final VoidCallback? onTextAction;

  @override
  Widget build(BuildContext context) {
    const pad = 4.0;
    return LqGlass(
      padding: const EdgeInsets.all(pad),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final a in actions) _ToolbarIcon(action: a),
          if (textAction != null) ...[
            const SizedBox(width: LqSpace.x1),
            _ToolbarText(label: textAction!, onPressed: onTextAction),
          ],
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  const _ToolbarIcon({required this.action});

  final LqToolbarAction action;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final enabled = action.onPressed != null;
    final fg = !enabled
        ? c.disabledText
        : (action.destructive ? c.textDanger : c.iconPrimary);
    return LqPressable(
      onTap: action.onPressed,
      semanticLabel: action.semanticLabel,
      scale: LqMotion.glassPressScale,
      haptic: action.destructive ? LqHaptic.medium : LqHaptic.light,
      builder: (context, pressed) => AnimatedContainer(
        duration: LqMotion.of(context, LqMotion.fast),
        width: LqSize.control,
        height: LqSize.control,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // A soft bubble lights up under the finger, as on iOS 26.
          color: !pressed
              ? const Color(0x00000000)
              : c.glassPressed,
        ),
        child: Icon(action.icon, size: LqIconSize.xl, color: fg),
      ),
    );
  }
}

class _ToolbarText extends StatelessWidget {
  const _ToolbarText({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return LqPressable(
      onTap: onPressed,
      scale: LqMotion.glassPressScale,
      haptic: LqHaptic.medium,
      builder: (context, pressed) => Container(
        height: LqSize.control - 4,
        padding: const EdgeInsets.symmetric(horizontal: LqSpace.x4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(LqRadius.full),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: pressed
                ? [c.accentPressedTop, c.accentPressedBottom]
                : [c.accentTop, c.accentBottom],
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: lq.type.subheadMedium.copyWith(
            color: c.textOnAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

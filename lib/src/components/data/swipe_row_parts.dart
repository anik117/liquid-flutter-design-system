import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/colors.dart';
import '../feedback/badge.dart';

/// One action revealed behind a [LqSwipeRow], e.g. "Business" or "Delete".
class LqSwipeAction {
  const LqSwipeAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.tone = LqTone.neutral,
  });

  /// Short verb or category shown under the icon.
  final String label;

  /// Glyph shown above the label.
  final IconData icon;

  /// Runs when the action is tapped, or on a full swipe if it is first.
  final VoidCallback onTap;

  /// Fill color by meaning: neutral grey, accent, danger red and so on.
  final LqTone tone;

  /// Solid fill and readable foreground for [tone].
  static (Color bg, Color fg) colorsFor(LqColors c, LqTone tone) {
    final bg = switch (tone) {
      LqTone.neutral => c.isDark ? c.textTertiary : c.textSecondary,
      LqTone.accent || LqTone.positive => c.accentBottom,
      LqTone.danger => c.dangerBottom,
      LqTone.caution => c.caution,
      LqTone.info => c.info,
    };
    final ink = c.isDark ? c.canvas : c.textPrimary;
    return (bg, bg.computeLuminance() > 0.3 ? ink : c.textOnAccent);
  }
}

/// The strip of actions behind a swipe row. [revealed] is how many pixels
/// show; [expand] (0…1) grows the first action over the others as a full
/// swipe arms, as in iOS Mail.
class SwipeActionsPane extends StatelessWidget {
  const SwipeActionsPane({
    super.key,
    required this.actions,
    required this.revealed,
    required this.expand,
    required this.trailing,
    required this.actionWidth,
    required this.onAction,
  });

  /// Actions, outermost first.
  final List<LqSwipeAction> actions;

  /// Visible width of the pane.
  final double revealed;

  /// How far the first action has taken over the pane (0…1).
  final double expand;

  /// True when the pane sits on the row's right edge.
  final bool trailing;

  /// Resting width of one action.
  final double actionWidth;

  /// Called when an action is tapped.
  final ValueChanged<LqSwipeAction> onAction;

  @override
  Widget build(BuildContext context) {
    final n = actions.length;
    final share = revealed / n;
    final first = share + (revealed - share) * expand;
    final other = n == 1 ? 0.0 : (revealed - first) / (n - 1);
    final cells = <Widget>[
      for (var i = 0; i < n; i++)
        SizedBox(
          width: i == 0 ? first : other,
          child: _cell(context, actions[i], i == 0 ? expand : 0),
        ),
    ];
    return Row(children: trailing ? cells.reversed.toList() : cells);
  }

  Widget _cell(BuildContext context, LqSwipeAction a, double grow) {
    final lq = context.lq;
    final (bg, fg) = LqSwipeAction.colorsFor(lq.colors, a.tone);
    // An expanding action keeps its label near the row, like iOS.
    final inner = trailing ? Alignment.centerLeft : Alignment.centerRight;
    return LqPressable(
      onTap: () => onAction(a),
      scale: 1,
      semanticLabel: a.label,
      builder: (context, pressed) => ColoredBox(
        color: pressed ? Color.lerp(bg, fg, 0.15)! : bg,
        child: ClipRect(
          child: OverflowBox(
            minWidth: 0,
            maxWidth: math.max(actionWidth, 1),
            alignment: Alignment.lerp(Alignment.center, inner, grow)!,
            child: SizedBox(
              width: actionWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(a.icon, size: 20, color: fg),
                  const SizedBox(height: 2),
                  Text(
                    a.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: lq.type.caption.copyWith(color: fg),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

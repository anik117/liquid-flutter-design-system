import 'package:flutter/widgets.dart';

import 'swipe_row_parts.dart';

/// The swipe row's layers: the revealed action panes under the row, and
/// the row slid aside by [offset]. While open, a tap on the row closes it.
class SwipeRowLayers extends StatelessWidget {
  const SwipeRowLayers({
    super.key,
    required this.offset,
    required this.expand,
    required this.leading,
    required this.trailing,
    required this.actionWidth,
    required this.onAction,
    required this.onClose,
    required this.child,
  });

  /// How far the row is slid; negative reveals [trailing].
  final double offset;

  /// Full-swipe takeover of the first action (0…1).
  final double expand;

  /// Actions on the left, outermost first.
  final List<LqSwipeAction> leading;

  /// Actions on the right, outermost first.
  final List<LqSwipeAction> trailing;

  /// Resting width of one action.
  final double actionWidth;

  /// Called when an action is tapped.
  final ValueChanged<LqSwipeAction> onAction;

  /// Closes the row.
  final VoidCallback onClose;

  /// The row.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final v = offset;
    Widget pane(List<LqSwipeAction> actions, bool isTrailing) => SwipeActionsPane(
      actions: actions,
      revealed: v.abs(),
      expand: expand,
      trailing: isTrailing,
      actionWidth: actionWidth,
      onAction: onAction,
    );
    return Stack(
      children: [
        if (v < 0 && trailing.isNotEmpty)
          Positioned(
            key: const ValueKey('trailing'),
            right: 0, top: 0, bottom: 0, width: -v,
            child: pane(trailing, true),
          ),
        if (v > 0 && leading.isNotEmpty)
          Positioned(
            key: const ValueKey('leading'),
            left: 0, top: 0, bottom: 0, width: v,
            child: pane(leading, false),
          ),
        Transform.translate(
          key: const ValueKey('row'),
          offset: Offset(v, 0),
          child: Stack(
            children: [
              child,
              if (v != 0)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onClose,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

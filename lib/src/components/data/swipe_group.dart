import 'package:flutter/widgets.dart';

/// Keeps at most one [LqSwipeRow] open among its descendants. Rows outside
/// any group share one app-wide slot instead.
class LqSwipeGroup extends StatefulWidget {
  const LqSwipeGroup({super.key, required this.child});

  /// The list (or any subtree) holding the swipe rows.
  final Widget child;

  static final ValueNotifier<Object?> _shared = ValueNotifier(null);

  /// The slot naming the currently open row for [context].
  static ValueNotifier<Object?> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SwipeGroupScope>()?.open ??
      _shared;

  @override
  State<LqSwipeGroup> createState() => _LqSwipeGroupState();
}

class _LqSwipeGroupState extends State<LqSwipeGroup> {
  final _open = ValueNotifier<Object?>(null);

  @override
  void dispose() {
    _open.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _SwipeGroupScope(open: _open, child: widget.child);
}

class _SwipeGroupScope extends InheritedWidget {
  const _SwipeGroupScope({required this.open, required super.child});

  final ValueNotifier<Object?> open;

  @override
  bool updateShouldNotify(_SwipeGroupScope old) => old.open != open;
}

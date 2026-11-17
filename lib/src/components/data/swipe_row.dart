import 'dart:math' as math;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/haptics.dart';
import '../../foundation/spring.dart';
import '../../tokens/motion.dart';
import 'swipe_group.dart';
import 'swipe_row_layers.dart';
import 'swipe_row_parts.dart';

export 'swipe_group.dart' show LqSwipeGroup;
export 'swipe_row_parts.dart' show LqSwipeAction;

/// Wraps a row (usually a [LqListRow]) so a horizontal drag reveals actions
/// behind it, iOS Mail style. Releasing settles open or closed on a spring
/// carrying the finger's speed; a long swipe commits the first action with
/// a firm haptic. Tapping anywhere else closes it, and only one row per
/// [LqSwipeGroup] stays open.
class LqSwipeRow extends StatefulWidget {
  const LqSwipeRow({
    super.key,
    required this.child,
    this.trailingActions = const [],
    this.leadingActions = const [],
    this.fullSwipe = true,
    this.actionWidth = 76,
  });

  /// The row itself. Give it an opaque background.
  final Widget child;

  /// Revealed by swiping left, outermost (full-swipe) action first.
  final List<LqSwipeAction> trailingActions;

  /// Revealed by swiping right, outermost (full-swipe) action first.
  final List<LqSwipeAction> leadingActions;

  /// Whether swiping far enough runs the first action without a tap.
  final bool fullSwipe;

  /// Resting width of each action button.
  final double actionWidth;

  @override
  State<LqSwipeRow> createState() => _LqSwipeRowState();
}

class _LqSwipeRowState extends State<LqSwipeRow> with TickerProviderStateMixin {
  late final _offset = AnimationController.unbounded(vsync: this);
  late final _expand = AnimationController(vsync: this, duration: LqMotion.fast);
  ValueNotifier<Object?>? _group;
  double _width = 0;
  bool _armed = false;

  double get _trailingExtent => widget.trailingActions.length * widget.actionWidth;
  double get _leadingExtent => widget.leadingActions.length * widget.actionWidth;
  double _threshold(double extent) => math.max(_width * 0.6, extent + 32);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final group = LqSwipeGroup.of(context);
    if (group != _group) {
      _group?.removeListener(_onGroup);
      _group = group..addListener(_onGroup);
    }
  }

  @override
  void dispose() {
    _group?.removeListener(_onGroup);
    if (_group?.value == this) _group!.value = null;
    _offset.dispose();
    _expand.dispose();
    super.dispose();
  }

  void _onGroup() {
    final open = _group!.value;
    if (open != null && open != this && _offset.value != 0) _settle(0);
  }

  void _onStart(DragStartDetails _) {
    _offset.stop();
    if (_group!.value != this) _group!.value = this;
  }

  void _onUpdate(DragUpdateDetails d) {
    final delta = d.primaryDelta ?? 0;
    final v = _offset.value;
    final trailing = v < 0 || (v == 0 && delta < 0);
    final extent = trailing ? _trailingExtent : _leadingExtent;
    final far = widget.fullSwipe ? _width : extent;
    // Past the actions without a full swipe, the row resists.
    final resist = !widget.fullSwipe && v.abs() > extent;
    final next = (v + (resist ? delta * 0.3 : delta)).clamp(
      widget.trailingActions.isEmpty ? 0.0 : -far - (resist ? 40 : 0),
      widget.leadingActions.isEmpty ? 0.0 : far + (resist ? 40 : 0),
    );
    _offset.value = next;
    final armed = widget.fullSwipe &&
        extent > 0 &&
        next.abs() > _threshold(extent);
    if (armed != _armed) {
      _armed = armed;
      LqHaptics.play(armed ? LqHaptic.medium : LqHaptic.selection);
      armed ? _expand.forward() : _expand.reverse();
    }
  }

  void _onEnd(DragEndDetails d) {
    final v = _offset.value;
    final vx = d.primaryVelocity ?? 0;
    if (v == 0) return;
    if (_armed) return _commit(v < 0, vx);
    final extent = v < 0 ? _trailingExtent : _leadingExtent;
    final outward = v < 0 ? -vx : vx;
    final open = outward > -400 && (outward > 400 || v.abs() > extent / 2);
    _settle(open ? (v < 0 ? -extent : extent) : 0, vx);
  }

  void _settle(double target, [double velocity = 0]) {
    if (_armed) {
      _armed = false;
      _expand.reverse();
    }
    LqSpring.animate(_offset, target, velocity: velocity, context: context)
        .whenCompleteOrCancel(() {
          // A spring stops within a hair of its target; land exactly on it.
          final near = (_offset.value - target).abs() < 1;
          if (mounted && !_offset.isAnimating && near) _offset.value = target;
        });
  }

  void _commit(bool trailing, double velocity) {
    final action =
        (trailing ? widget.trailingActions : widget.leadingActions).first;
    LqSpring.animate(
      _offset,
      trailing ? -_width : _width,
      velocity: velocity,
      spring: LqSpring.firm,
      context: context,
    ).whenCompleteOrCancel(() {
      action.onTap();
      if (mounted) _settle(0);
    });
  }

  void _tapAction(LqSwipeAction a) {
    a.onTap();
    _settle(0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        _width = box.maxWidth;
        return TapRegion(
          onTapOutside: (_) {
            if (_offset.value != 0 && !_offset.isAnimating) _settle(0);
          },
          child: Semantics(
            customSemanticsActions: {
              for (final a in [...widget.leadingActions, ...widget.trailingActions])
                CustomSemanticsAction(label: a.label): a.onTap,
            },
            child: GestureDetector(
              onHorizontalDragStart: _onStart,
              onHorizontalDragUpdate: _onUpdate,
              onHorizontalDragEnd: _onEnd,
              onHorizontalDragCancel: () => _settle(0),
              child: ClipRect(
                child: AnimatedBuilder(
                  animation: Listenable.merge([_offset, _expand]),
                  child: widget.child,
                  builder: (context, child) => SwipeRowLayers(
                    offset: _offset.value.abs() < 0.5 ? 0 : _offset.value,
                    expand: _expand.value,
                    leading: widget.leadingActions,
                    trailing: widget.trailingActions,
                    actionWidth: widget.actionWidth,
                    onAction: _tapAction,
                    onClose: () => _settle(0),
                    child: child!,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

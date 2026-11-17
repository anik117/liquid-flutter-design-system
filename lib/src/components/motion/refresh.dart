import 'dart:math' as math;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/haptics.dart';
import '../../foundation/spring.dart';
import '../../tokens/metrics.dart';
import 'refresh_bubble.dart';

enum _Phase { idle, pulling, armed, refreshing, closing }

/// Pull-to-refresh for a vertical scrollable ([ListView],
/// [CustomScrollView]). As you pull past the top, a small glass circle
/// descends with an arrow that turns over and a ring that fills toward the
/// trigger distance. Crossing it plays a light haptic; letting go runs
/// [onRefresh] with a spinner in the circle, which then springs away.
/// Works with iOS bouncing and Android clamping physics.
class LqRefresh extends StatefulWidget {
  const LqRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.triggerDistance = 80,
    this.semanticLabel = 'Refresh',
  });

  /// The scrollable to refresh.
  final Widget child;

  /// Loads fresh data; the spinner shows until it completes.
  final Future<void> Function() onRefresh;

  /// How far to pull before letting go refreshes.
  final double triggerDistance;

  /// Name of the screen-reader action that refreshes.
  final String semanticLabel;

  @override
  State<LqRefresh> createState() => _LqRefreshState();
}

class _LqRefreshState extends State<LqRefresh> with TickerProviderStateMixin {
  // Pull progress: 0 hidden, 1 at the trigger (and the resting spot).
  late final AnimationController _pull = AnimationController.unbounded(vsync: this);
  late final AnimationController _spin =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
  _Phase _phase = _Phase.idle;
  double _px = 0;

  bool get _busy => _phase == _Phase.refreshing || _phase == _Phase.closing;

  void _setPull(double px) {
    _px = math.max(0, px);
    final p = _px / widget.triggerDistance;
    final next = p >= 1 ? _Phase.armed : (p > 0 ? _Phase.pulling : _Phase.idle);
    if (next == _Phase.armed && _phase != _Phase.armed) LqHaptics.play(LqHaptic.light);
    if (next != _phase) setState(() => _phase = next);
    _pull.stop();
    _pull.value = p;
  }

  void _release() {
    if (_phase == _Phase.armed) {
      _start();
    } else if (_phase == _Phase.pulling) {
      setState(() => _phase = _Phase.idle);
      _px = 0;
      LqSpring.animate(_pull, 0, spring: LqSpring.firm, context: context);
    }
  }

  Future<void> _start() async {
    if (_busy) return;
    setState(() => _phase = _Phase.refreshing);
    _px = 0;
    LqSpring.animate(_pull, 1, context: context);
    _spin.repeat();
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() => _phase = _Phase.closing);
        await LqSpring.animate(_pull, 0, spring: LqSpring.firm, context: context);
        _spin.stop();
        if (mounted) setState(() => _phase = _Phase.idle);
      }
    }
  }

  bool _onScroll(ScrollNotification n) {
    if (n.depth != 0 || n.metrics.axis != Axis.vertical || _busy) return false;
    if (n is ScrollUpdateNotification) {
      if (n.dragDetails == null) {
        _release();
        return false;
      }
      final over = n.metrics.minScrollExtent - n.metrics.pixels;
      if (over > 0) {
        _setPull(over); // Bouncing physics: the list itself moved down.
      } else if (_px > 0 && (n.scrollDelta ?? 0) > 0) {
        _setPull(_px - n.scrollDelta!); // Clamping: finger heading back up.
      }
    } else if (n is OverscrollNotification && n.dragDetails != null && n.overscroll < 0) {
      _setPull(_px - n.overscroll * 0.5); // Clamping: pull with resistance.
    } else if (n is ScrollEndNotification) {
      _release();
    }
    return false;
  }

  @override
  void dispose() {
    _pull.dispose();
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const travel = LqSpace.x4 + RefreshBubble.size;
    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: widget.semanticLabel): () {
          if (!_busy) _start();
        },
      },
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(onNotification: _onScroll, child: widget.child),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _pull,
                builder: (context, _) {
                  final p = _pull.value;
                  if (p <= 0.01 && _phase == _Phase.idle) return const SizedBox.shrink();
                  final y = -RefreshBubble.size + travel * p.clamp(0.0, 1.0) +
                      math.max(0.0, p - 1) * 14;
                  return Transform.translate(
                    offset: Offset(0, y),
                    child: Center(
                      child: Opacity(
                        opacity: (p * 2).clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: 0.6 + 0.4 * p.clamp(0.0, 1.0),
                          child: RefreshBubble(
                            progress: p,
                            refreshing: _phase == _Phase.refreshing,
                            spin: _spin,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

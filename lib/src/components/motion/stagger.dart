import 'package:flutter/widgets.dart';

import '../../tokens/motion.dart';

/// Fades and rises its children in one after another the first time it
/// builds, e.g. a list of drives arriving. Each child starts [delay] after
/// the previous one and settles on a spring. Under Reduce Motion the
/// children are simply there. Give it a new key to play it again.
class LqStagger extends StatefulWidget {
  const LqStagger({
    super.key,
    required this.children,
    this.delay = const Duration(milliseconds: 35),
    this.offset = 12,
    this.duration = LqMotion.slow,
    this.spacing = 0,
  });

  /// Stacked top to bottom, stretched to the width.
  final List<Widget> children;

  /// Time between one child starting and the next.
  final Duration delay;

  /// How far below its place each child starts, in logical pixels.
  final double offset;

  /// How long one child takes to arrive.
  final Duration duration;

  /// Space between children.
  final double spacing;

  @override
  State<LqStagger> createState() => _LqStaggerState();
}

class _LqStaggerState extends State<LqStagger> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);
  bool _started = false;

  Duration get _total =>
      widget.duration + widget.delay * (widget.children.length - 1).clamp(0, 1 << 20);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (LqMotion.reduced(context)) {
      _c.value = 1;
    } else {
      _c.duration = _total;
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _total.inMicroseconds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: widget.spacing,
      children: [
        for (var i = 0; i < widget.children.length; i++)
          AnimatedBuilder(
            animation: _c,
            child: widget.children[i],
            builder: (context, child) {
              // Same tree shape at rest, so children keep their state.
              final start = (widget.delay * i).inMicroseconds / total;
              final span = widget.duration.inMicroseconds / total;
              final p = _c.isCompleted ? 1.0 : ((_c.value - start) / span).clamp(0.0, 1.0);
              final rise = LqMotion.springCurve.transform(p);
              return Opacity(
                opacity: Curves.easeOut.transform(p),
                child: Transform.translate(
                  offset: Offset(0, (1 - rise) * widget.offset),
                  child: child,
                ),
              );
            },
          ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';
import '../feedback/badge.dart';

/// The marker on a timeline's rail: a small dot, or an icon in a soft
/// circle. The current marker fills with the accent and, unless Reduce
/// Motion is on, sends out a slow, soft pulse.
class TimelineMarker extends StatefulWidget {
  const TimelineMarker({
    super.key,
    required this.size,
    this.icon,
    this.tone,
    this.current = false,
  });

  /// Width of the rail the marker is centered in.
  final double size;

  /// Glyph; null draws a plain dot.
  final IconData? icon;

  /// Tint for a past or upcoming marker.
  final LqTone? tone;

  /// Whether this is the live, highlighted step.
  final bool current;

  @override
  State<TimelineMarker> createState() => _TimelineMarkerState();
}

class _TimelineMarkerState extends State<TimelineMarker>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(TimelineMarker old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final run = widget.current && !LqMotion.reduced(context);
    if (run && !_pulse.isAnimating) _pulse.repeat();
    if (!run && _pulse.isAnimating) _pulse.reset();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final s = widget.size;
    final dot = widget.icon == null ? 10.0 : s;
    final (softBg, softFg) = widget.tone == null
        ? (c.surfaceSunken, c.iconSecondary)
        : LqBadge.colorsFor(c, widget.tone!);
    final bg = widget.current
        ? c.accent
        : (widget.icon == null ? c.borderStrong : softBg);
    final fg = widget.current ? c.textOnAccent : softFg;

    final marker = Container(
      width: dot,
      height: dot,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: widget.icon == null
            ? Border.all(color: c.surface, width: 2)
            : null,
      ),
      child: widget.icon == null
          ? null
          : Icon(widget.icon, size: s * 0.5, color: fg),
    );

    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (widget.current)
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final t = LqMotion.emphasized.transform(_pulse.value);
                // Still under Reduce Motion: a quiet, fixed halo.
                final still = !_pulse.isAnimating;
                return Container(
                  width: dot * (still ? 1.5 : 1 + 0.9 * t),
                  height: dot * (still ? 1.5 : 1 + 0.9 * t),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.accent.withValues(
                      alpha: still ? 0.18 : 0.3 * (1 - t),
                    ),
                  ),
                );
              },
            ),
          marker,
        ],
      ),
    );
  }
}

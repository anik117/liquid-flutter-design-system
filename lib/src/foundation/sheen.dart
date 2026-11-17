import 'package:flutter/widgets.dart';

import '../tokens/motion.dart';

/// A soft band of light that glides across [child] when it appears, to draw
/// the eye to one thing on a screen (an upgrade capsule, a new feature).
/// It sweeps [repeats] times when it first appears, one [period] apart,
/// then rests for good: a glint, not a loading shimmer, and finished inside
/// five seconds (WCAG 2.2.2, so it never needs a pause control). Under
/// Reduce Motion it never moves.
class LqSheen extends StatefulWidget {
  const LqSheen({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.period = const Duration(milliseconds: 3600),
    this.repeats = 2,
    this.sweep = const Duration(milliseconds: 1100),
    this.strength = 0.55,
  });

  final Widget child;

  /// Clips the band to the child's shape (a capsule by default).
  final BorderRadius borderRadius;

  /// One full cycle: the sweep plus the rest after it.
  final Duration period;

  /// How many sweeps play when the widget first appears.
  final int repeats;

  /// How long the band takes to cross.
  final Duration sweep;

  /// Peak opacity of the white band.
  final double strength;

  @override
  State<LqSheen> createState() => _LqSheenState();
}

class _LqSheenState extends State<LqSheen> with SingleTickerProviderStateMixin {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  bool _played = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (LqMotion.reduced(context)) {
      _clock.stop();
    } else if (!_played) {
      _played = true;
      _clock.repeat(count: widget.repeats);
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sweepShare = widget.sweep.inMilliseconds / widget.period.inMilliseconds;
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: AnimatedBuilder(
                animation: _clock,
                builder: (context, _) {
                  final t = _clock.value / sweepShare;
                  if (t >= 1 || !_clock.isAnimating) return const SizedBox.shrink();
                  final x = -1.6 + 3.2 * LqMotion.emphasized.transform(t);
                  return Align(
                    alignment: Alignment(x, 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.45,
                      heightFactor: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(-1, -0.4),
                            end: const Alignment(1, 0.4),
                            colors: [
                              const Color(0x00FFFFFF),
                              Color.fromRGBO(255, 255, 255, widget.strength),
                              const Color(0x00FFFFFF),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

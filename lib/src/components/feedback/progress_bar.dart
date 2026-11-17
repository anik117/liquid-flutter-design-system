import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// A rounded linear progress bar on a sunken track. With a [value] it is
/// determinate and springs to each new value; without one it is
/// indeterminate and a soft accent segment slides across the track.
class LqProgressBar extends StatefulWidget {
  const LqProgressBar({
    super.key,
    this.value,
    this.height = 6,
    this.semanticLabel,
  });

  /// Progress from 0 to 1, or null while the amount of work is unknown.
  final double? value;

  /// Thickness of the bar.
  final double height;

  /// What is progressing, e.g. "Exporting Schedule C report".
  final String? semanticLabel;

  @override
  State<LqProgressBar> createState() => _LqProgressBarState();
}

class _LqProgressBarState extends State<LqProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slide = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(LqProgressBar old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    if (widget.value == null) {
      if (!_slide.isAnimating) _slide.repeat();
    } else if (_slide.isAnimating) {
      _slide.stop();
    }
  }

  @override
  void dispose() {
    _slide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final value = widget.value;
    final radius = BorderRadius.circular(LqRadius.full);
    final fill = BoxDecoration(
      borderRadius: radius,
      gradient: LinearGradient(colors: [c.accentTop, c.accentBottom]),
    );
    // The indeterminate segment fades at both ends so it reads as a sheen.
    final shimmer = BoxDecoration(
      borderRadius: radius,
      gradient: LinearGradient(
        colors: [
          c.accentTop.withValues(alpha: 0),
          c.accentTop,
          c.accentBottom,
          c.accentBottom.withValues(alpha: 0),
        ],
        stops: const [0, 0.3, 0.7, 1],
      ),
    );
    final Widget bar;
    if (value == null) {
      bar = AnimatedBuilder(
        animation: _slide,
        builder: (context, _) {
          // A segment a third as wide enters at the left and leaves at the
          // right, easing so it lingers mid-track like iOS's sliding bar.
          final t = Curves.easeInOut.transform(_slide.value);
          return FractionallySizedBox(
            widthFactor: 0.35,
            alignment: Alignment(-2.08 + 4.16 * t, 0),
            child: DecoratedBox(decoration: shimmer),
          );
        },
      );
    } else {
      bar = TweenAnimationBuilder<double>(
        tween: Tween(end: value.clamp(0.0, 1.0)),
        duration: LqMotion.of(context, LqMotion.slow),
        curve: LqMotion.springCurve,
        builder: (context, v, _) => FractionallySizedBox(
          widthFactor: v.clamp(0.0, 1.0),
          alignment: Alignment.centerLeft,
          child: DecoratedBox(decoration: fill),
        ),
      );
    }
    return Semantics(
      label: widget.semanticLabel,
      value: value == null ? null : '${(value.clamp(0.0, 1.0) * 100).round()}%',
      child: SizedBox(
        height: widget.height,
        child: ClipRRect(
          borderRadius: radius,
          child: DecoratedBox(
            decoration: BoxDecoration(color: c.surfaceSunken),
            child: SizedBox.expand(child: bar),
          ),
        ),
      ),
    );
  }
}

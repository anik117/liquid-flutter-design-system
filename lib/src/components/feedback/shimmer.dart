import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';

/// One shimmer sweep shared by every [LqSkeleton] block beneath it: a soft
/// band of light travels left to right across the whole group, so a list
/// of placeholder rows shimmers as one surface instead of each block on
/// its own clock. Under Reduce Motion the blocks stay still.
///
/// A skeleton block outside any [LqShimmer] wraps itself in one.
class LqShimmer extends StatefulWidget {
  const LqShimmer({super.key, required this.child});

  /// The placeholder blocks to sweep across.
  final Widget child;

  /// True when an [LqShimmer] already covers [context].
  static bool covers(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ShimmerScope>() != null;

  @override
  State<LqShimmer> createState() => _LqShimmerState();
}

class _LqShimmerState extends State<LqShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (LqMotion.reduced(context)) {
      _sweep.stop();
    } else if (!_sweep.isAnimating) {
      _sweep.repeat();
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = _ShimmerScope(child: widget.child);
    if (LqMotion.reduced(context)) return child;
    final dark = context.lq.colors.isDark;
    // Pure white sheen, faint in dark mode so it never glares.
    final light = const Color(0xFFFFFFFF).withValues(alpha: dark ? 0.07 : 0.55);
    return AnimatedBuilder(
      animation: _sweep,
      child: child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) {
          final band = bounds.width * 0.6;
          final x = -band + (bounds.width + band * 2) * _sweep.value;
          return LinearGradient(
            colors: [
              light.withValues(alpha: 0),
              light,
              light.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromLTWH(x - band / 2, 0, band, bounds.height));
        },
        child: child,
      ),
    );
  }
}

class _ShimmerScope extends InheritedWidget {
  const _ShimmerScope({required super.child});

  @override
  bool updateShouldNotify(_ShimmerScope oldWidget) => false;
}

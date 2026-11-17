import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// Page indicator dots. The current dot stretches into a brand pill; with
/// a [controller] the stretch follows the swipe continuously, so the pill
/// flows from one dot to the next under the finger. Without one, it
/// springs to [index].
class LqPageDots extends StatelessWidget {
  const LqPageDots({
    super.key,
    required this.count,
    this.controller,
    this.index = 0,
  });

  /// Number of pages.
  final int count;

  /// The pages' controller to follow. Takes precedence over [index].
  final PageController? controller;

  /// The current page when there is no [controller].
  final int index;

  static const _dot = 8.0;
  static const _pill = 22.0;

  double _page() {
    final pc = controller!;
    if (pc.hasClients && pc.position.haveDimensions) {
      return pc.page ?? pc.initialPage.toDouble();
    }
    return pc.initialPage.toDouble();
  }

  void _go(BuildContext context, int page) {
    final d = LqMotion.of(context, LqMotion.standard);
    d == Duration.zero
        ? controller!.jumpToPage(page)
        : controller!.animateToPage(page, duration: d, curve: LqMotion.emphasized);
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return AnimatedBuilder(
        animation: controller!,
        builder: (context, _) => _dots(context, _page()),
      );
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(end: index.toDouble()),
      duration: LqMotion.of(context, LqMotion.slow),
      curve: LqMotion.springCurve,
      builder: (context, p, _) => _dots(context, p),
    );
  }

  Widget _dots(BuildContext context, double p) {
    final c = context.lq.colors;
    final current = p.round().clamp(0, count - 1);
    final canStep = controller != null;
    return Semantics(
      label: 'Page ${current + 1} of $count',
      onIncrease: canStep && current < count - 1
          ? () => _go(context, current + 1)
          : null,
      onDecrease: canStep && current > 0 ? () => _go(context, current - 1) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++)
            Builder(
              builder: (context) {
                final t = (1 - (p - i).abs()).clamp(0.0, 1.0);
                return Container(
                  width: lerpDouble(_dot, _pill, t),
                  height: _dot,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: Color.lerp(c.borderStrong, c.accent, t),
                    borderRadius: BorderRadius.circular(LqRadius.full),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

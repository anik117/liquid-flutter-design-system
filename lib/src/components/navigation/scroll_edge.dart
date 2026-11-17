import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';

/// A progressive blur for the edge content scrolls under (iOS 26's scroll
/// edge effect, BoardUI's scroll fade). Five stacked blurs, each a little
/// stronger and shorter than the last, under a fade from the page color,
/// so content dissolves into the edge with no visible seam. Fills its
/// parent; [fromTop] flips it for a bottom edge.
///
/// (A single blur faded by a ShaderMask would be smoother, but Flutter does
/// not render a backdrop blur inside a mask, so the steps are kept small
/// instead.)
class LqScrollEdge extends StatelessWidget {
  const LqScrollEdge({super.key, this.fromTop = true});

  final bool fromTop;

  /// (share of the edge's height, blur sigma), weakest and tallest first.
  static const _layers = [(1.0, 1.5), (0.8, 3.5), (0.6, 7.0), (0.4, 11.0), (0.22, 16.0)];

  @override
  Widget build(BuildContext context) {
    final canvas = context.lq.colors.canvas;
    final start = fromTop ? Alignment.topCenter : Alignment.bottomCenter;
    final end = fromTop ? Alignment.bottomCenter : Alignment.topCenter;

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (final (share, sigma) in _layers)
            Align(
              alignment: start,
              child: FractionallySizedBox(
                heightFactor: share,
                widthFactor: 1,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: start,
                end: end,
                colors: [
                  canvas.withValues(alpha: 0.85),
                  canvas.withValues(alpha: 0.55),
                  canvas.withValues(alpha: 0),
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../foundation/haptics.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// Horizontally paging cards with the neighbors peeking in at the sides.
/// Side cards shrink and fade by how far they sit from the center, and a
/// swipe snaps to the nearest card with a selection tick. Pass your own
/// [controller] to drive page dots or jump to a card.
class LqCarousel extends StatefulWidget {
  const LqCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 200,
    this.viewportFraction = 0.84,
    this.controller,
    this.onPageChanged,
    this.gap = LqSpace.x3,
  });

  /// How many cards there are.
  final int itemCount;

  /// Builds the card at an index. Cards fill the page's height.
  final IndexedWidgetBuilder itemBuilder;

  /// Height of the strip.
  final double height;

  /// Share of the width each card takes. Ignored when [controller] is given
  /// (the controller's own fraction wins).
  final double viewportFraction;

  /// Optional controller for page dots or programmatic paging.
  final PageController? controller;

  /// Called when a new card settles in the center.
  final ValueChanged<int>? onPageChanged;

  /// Space between neighboring cards.
  final double gap;

  @override
  State<LqCarousel> createState() => _LqCarouselState();
}

class _LqCarouselState extends State<LqCarousel> {
  PageController? _own;

  PageController get _controller =>
      widget.controller ??
      (_own ??= PageController(viewportFraction: widget.viewportFraction));

  @override
  void dispose() {
    _own?.dispose();
    super.dispose();
  }

  double _page() {
    final c = _controller;
    if (c.hasClients && c.position.hasContentDimensions) {
      return c.page ?? c.initialPage.toDouble();
    }
    return c.initialPage.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final still = LqMotion.reduced(context);
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.itemCount,
        onPageChanged: (i) {
          LqHaptics.play(LqHaptic.selection);
          widget.onPageChanged?.call(i);
        },
        itemBuilder: (context, i) => AnimatedBuilder(
          animation: _controller,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.gap / 2),
            child: widget.itemBuilder(context, i),
          ),
          builder: (context, child) {
            final d = (_page() - i).abs().clamp(0.0, 1.0);
            // Under Reduce Motion side cards only dim; nothing scales.
            return Opacity(
              opacity: 1 - 0.4 * d,
              child: Transform.scale(
                scale: still ? 1 : 1 - 0.08 * d,
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

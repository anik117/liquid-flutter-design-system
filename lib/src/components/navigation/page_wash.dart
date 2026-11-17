import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';

/// A soft brand tint on the page background, from the top of the screen
/// fading to the plain canvas at [height] (set it to end behind the middle
/// of the screen's first card). It moves with [scroll], so it stays behind
/// that card and leaves with it. Place it first in a page [Stack].
class LqPageWash extends StatelessWidget {
  const LqPageWash({super.key, required this.scroll, required this.height});

  final ScrollController scroll;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final wash = c.accentSoft.withValues(alpha: c.isDark ? 0.45 : 0.7);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: scroll,
          builder: (context, child) {
            final offset = scroll.hasClients ? scroll.offset : 0.0;
            return Transform.translate(
              offset: Offset(0, -offset.clamp(0.0, height)),
              child: child,
            );
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [wash, wash.withValues(alpha: 0)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

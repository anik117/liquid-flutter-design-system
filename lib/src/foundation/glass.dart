import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

import '../theme/lq_theme.dart';
import '../tokens/metrics.dart';
import 'glass_rim.dart';

/// How much a glass surface frosts what is behind it.
enum LqGlassWeight {
  /// Floating buttons over busy content.
  regular,

  /// Bars that text scrolls under (tab bar, top bar): more frost, more tint.
  thick,
}

/// Our Liquid Glass surface. Drawn by Flutter, so it looks the same on iOS
/// and Android: a backdrop blur, a translucent body tint, a soft top sheen,
/// BoardUI's lit rim and a float shadow.
///
/// Use it only on the navigation layer (tab bar, top bar, floating
/// buttons). Content (cards, lists, charts) stays opaque.
class LqGlass extends StatelessWidget {
  const LqGlass({
    super.key,
    required this.child,
    this.radius,
    this.weight = LqGlassWeight.regular,
    this.tint,
    this.shadow = true,
    this.lit = false,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;

  /// Corner radius. Defaults to a capsule.
  final double? radius;
  final LqGlassWeight weight;

  /// Overrides the body tint, e.g. a brand-tinted glass button.
  final Color? tint;
  final bool shadow;

  /// Brightens the sheen, e.g. while a glass button is held.
  final bool lit;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final r = radius ?? LqRadius.full;
    final shape = BorderRadius.circular(r);
    final thick = weight == LqGlassWeight.thick;
    final body = tint ?? (thick ? c.glassTintStrong : c.glassTint);
    final sheenTop = c.rimHighlight.withValues(
      alpha: switch ((c.isDark, lit)) {
        (true, false) => 0.06,
        (true, true) => 0.16,
        (false, false) => 0.35,
        (false, true) => 0.7,
      },
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: shadow ? LqShadows.float(c.shadow) : null,
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: thick ? 30 : 18,
            sigmaY: thick ? 30 : 18,
          ),
          child: CustomPaint(
            foregroundPainter: LqGlassRimPainter(
              radius: r,
              highlight: c.rimHighlight,
              shade: c.rimShade,
            ),
            child: ColoredBox(
              color: body,
              // A gradient replaces a BoxDecoration's color, so the sheen
              // sits in its own layer on top of the tint.
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [sheenTop, sheenTop.withValues(alpha: 0)],
                  ),
                ),
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

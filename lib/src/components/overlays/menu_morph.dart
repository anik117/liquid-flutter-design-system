import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../foundation/spring.dart';
import '../../theme/lq_theme.dart';
import 'menu_items.dart';
import 'menu_layout.dart';

/// The open menu, drawn in the overlay. A glass panel starts exactly on
/// the anchor's rect and radius, springs out to the menu's size and spot
/// beside the anchor, and only then fades its rows in. Closing runs the
/// same morph back into the button. Internal to [LqMenuButton].
class LqMenuMorph<T> extends StatefulWidget {
  const LqMenuMorph({
    super.key,
    required this.anchor,
    required this.anchorRadius,
    required this.entries,
    required this.glyph,
    required this.onPick,
    required this.onClosed,
  });

  /// The anchor's rect in the overlay's coordinates.
  final Rect anchor;

  /// The anchor's corner radius; clamped to a capsule.
  final double anchorRadius;

  /// What the menu lists.
  final List<LqMenuEntry<T>> entries;

  /// The anchor's face, fading out as the panel leaves it.
  final Widget glyph;

  /// Called with the tapped item as the menu starts closing.
  final ValueChanged<LqMenuItem<T>> onPick;

  /// Called once the panel is back inside the anchor.
  final VoidCallback onClosed;

  @override
  State<LqMenuMorph<T>> createState() => _LqMenuMorphState<T>();
}

class _LqMenuMorphState<T> extends State<LqMenuMorph<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController.unbounded(
    vsync: this,
  );
  bool _started = false;
  bool _closing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    LqSpring.animate(_t, 1, context: context);
  }

  void _close([LqMenuItem<T>? picked]) {
    if (_closing) return;
    setState(() => _closing = true);
    if (picked != null) widget.onPick(picked);
    LqSpring.animate(
      _t,
      0,
      spring: LqSpring.firm,
      context: context,
    ).whenCompleteOrCancel(widget.onClosed);
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final pad = MediaQuery.paddingOf(context);
    final scaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, box) {
        final a = widget.anchor;
        final place = LqMenuPlacement.beside(
          a,
          Size(
            LqMenuMetrics.width,
            LqMenuMetrics.heightOf(widget.entries, scaler),
          ),
          box.biggest,
          pad,
        );
        final target = place.rect;
        final (w, h) = (target.width, target.height);
        final (alignRight, opensDown) = (place.right, place.down);
        final fromR = math.min(widget.anchorRadius, a.shortestSide / 2);
        final body = SizedBox(
          width: w,
          height: h,
          child: SingleChildScrollView(
            child: LqMenuBody<T>(entries: widget.entries, onPick: _close),
          ),
        );

        return IgnorePointer(
          ignoring: _closing,
          child: Stack(
            children: [
              Positioned.fill(
                child: Semantics(
                  label: 'Dismiss menu',
                  button: true,
                  onTap: _close,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _close,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _t,
                builder: (context, _) {
                  final t = _closing ? math.max(_t.value, 0.0) : _t.value;
                  final r = Rect.lerp(a, target, t)!;
                  final rect = Rect.fromLTWH(
                    r.left,
                    r.top,
                    math.max(r.width, 1),
                    math.max(r.height, 1),
                  );
                  final radius = lerpDouble(
                    fromR,
                    lq.radius.xl,
                    t.clamp(0.0, 1.0),
                  )!.clamp(0.0, rect.shortestSide / 2);
                  final content = ((t - 0.5) / 0.4).clamp(0.0, 1.0);
                  final face = (1 - t / 0.35).clamp(0.0, 1.0);
                  return Positioned.fromRect(
                    rect: rect,
                    child: Semantics(
                      scopesRoute: true,
                      explicitChildNodes: true,
                      label: 'Menu',
                      child: LqGlass(
                        weight: LqGlassWeight.thick,
                        radius: radius,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: IgnorePointer(
                                ignoring: content < 0.5,
                                child: Opacity(
                                  opacity: content,
                                  child: OverflowBox(
                                    alignment: Alignment(
                                      alignRight ? 1 : -1,
                                      opensDown ? -1 : 1,
                                    ),
                                    minWidth: w,
                                    maxWidth: w,
                                    minHeight: h,
                                    maxHeight: h,
                                    child: body,
                                  ),
                                ),
                              ),
                            ),
                            if (face > 0)
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: Opacity(
                                    opacity: face,
                                    child: Center(child: widget.glyph),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:ui' show lerpDouble;
import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'tabs.dart' show LqTabsStyle;

/// The label row of `LqTabs`: draws labels and the indicator at a
/// fractional [position] (1.5 = halfway between tabs 1 and 2), so the
/// indicator can follow a page swipe continuously. When [scrollable], the
/// row scrolls sideways and keeps the [selected] tab in view.
class LqTabStrip extends StatefulWidget {
  const LqTabStrip({
    super.key,
    required this.tabs,
    required this.animation,
    required this.position,
    required this.selected,
    required this.onTap,
    required this.style,
    required this.scrollable,
  });

  /// Tab labels.
  final List<String> tabs;

  /// Repaints the strip as the position moves.
  final Listenable animation;

  /// Reads the current fractional tab position.
  final double Function() position;

  /// The settled tab, kept in view when scrollable.
  final int selected;

  /// Called with the tapped tab's index.
  final ValueChanged<int> onTap;

  /// Pill or underline indicator.
  final LqTabsStyle style;

  /// Natural-width labels in a sideways scroll instead of equal widths.
  final bool scrollable;

  @override
  State<LqTabStrip> createState() => _LqTabStripState();
}

class _LqTabStripState extends State<LqTabStrip> {
  final _scroll = ScrollController();

  // Last laid-out (lefts, widths), to scroll a tab into view.
  (List<double>, List<double>) _layout = (const [], const []);

  @override
  void didUpdateWidget(LqTabStrip old) {
    super.didUpdateWidget(old);
    if (old.selected != widget.selected && widget.scrollable) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
    }
  }

  void _reveal() {
    final (i, (lefts, widths)) = (widget.selected, _layout);
    if (!mounted || !_scroll.hasClients || i >= lefts.length) return;
    final p = _scroll.position;
    final target = (lefts[i] + widths[i] / 2 - p.viewportDimension / 2).clamp(
      p.minScrollExtent,
      p.maxScrollExtent,
    );
    final d = LqMotion.of(context, LqMotion.slow);
    d == Duration.zero
        ? _scroll.jumpTo(target)
        : _scroll.animateTo(target, duration: d, curve: LqMotion.emphasized);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (lq, n) = (context.lq, widget.tabs.length);
    final c = lq.colors;
    final pill = widget.style == LqTabsStyle.pill;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // One weight for every label so widths never jump as colors shift.
    final style = lq.type.subheadMedium.copyWith(fontWeight: FontWeight.w600);
    final active = pill ? c.accentOnSoft : c.textPrimary;
    const pad = LqSpace.x4;

    return LayoutBuilder(
      builder: (context, box) {
        final widths = widget.scrollable
            ? [
                for (final t in widget.tabs)
                  _measure(context, t, style) + pad * 2,
              ]
            : List.filled(n, box.maxWidth / n);
        final total = widths.fold(0.0, (a, b) => a + b);
        final lefts = <double>[];
        var x = 0.0;
        for (final w in widths) {
          lefts.add(rtl ? total - x - w : x);
          x += w;
        }
        _layout = (lefts, widths);
        final strip = SizedBox(
          width: total,
          height: LqSize.control,
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, _) {
              final p = widget.position().clamp(0.0, n - 1.0);
              final (i, f) = (p.floor(), p - p.floor());
              final j = (i + 1).clamp(0, n - 1);
              final left = lerpDouble(lefts[i], lefts[j], f)!;
              final width = lerpDouble(widths[i], widths[j], f)!;
              return Stack(
                children: [
                  Positioned(
                    left: pill ? left : left + pad,
                    width: pill ? width : width - pad * 2,
                    top: pill ? 4 : null,
                    bottom: pill ? 4 : 0,
                    height: pill ? null : 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: pill ? c.accentSoft : c.accent,
                        borderRadius: BorderRadius.circular(LqRadius.full),
                      ),
                    ),
                  ),
                  for (var k = 0; k < n; k++)
                    Positioned(
                      left: lefts[k],
                      width: widths[k],
                      top: 0,
                      bottom: 0,
                      child: Semantics(
                        selected: k == widget.selected,
                        child: LqPressable(
                          onTap: () => widget.onTap(k),
                          haptic: LqHaptic.none,
                          builder: (context, _) => Center(
                            child: Text(
                              widget.tabs[k],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: style.copyWith(
                                color: Color.lerp(
                                  c.textSecondary,
                                  active,
                                  (1 - (p - k).abs()).clamp(0.0, 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
        final row = !widget.scrollable
            ? strip
            : SingleChildScrollView(
                controller: _scroll,
                scrollDirection: Axis.horizontal,
                child: strip,
              );
        final line = Border(bottom: BorderSide(color: c.separator));
        return pill
            ? row
            : DecoratedBox(
                decoration: BoxDecoration(border: line),
                child: row,
              );
      },
    );
  }

  double _measure(BuildContext context, String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final w = painter.width;
    painter.dispose();
    return w.ceilToDouble();
  }
}

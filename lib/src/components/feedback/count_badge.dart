import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';
import '../../tokens/typography.dart';
import 'badge.dart';

/// Puts a count pill (or a plain dot) on the top-right corner of [child],
/// e.g. "3" unreviewed drives on an inbox button. The pill pops in on a
/// spring, bounces when the count changes and shrinks away at 0.
class LqCountBadge extends StatefulWidget {
  const LqCountBadge({
    super.key,
    required this.child,
    required this.count,
    this.tone = LqTone.danger,
    this.dot = false,
    this.max = 99,
  });

  /// What the badge sits on, usually an [LqIconButton].
  final Widget child;

  /// How many; 0 or less hides the badge.
  final int count;

  /// [LqTone.danger] for things needing attention, [LqTone.accent] for news.
  final LqTone tone;

  /// Shows a small dot instead of the number.
  final bool dot;

  /// Counts above this read "99+".
  final int max;

  @override
  State<LqCountBadge> createState() => _LqCountBadgeState();
}

class _LqCountBadgeState extends State<LqCountBadge> {
  /// The last count above zero, kept on screen while the pill shrinks away.
  late int _shown = widget.count;

  @override
  void didUpdateWidget(LqCountBadge old) {
    super.didUpdateWidget(old);
    if (widget.count > 0) _shown = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final visible = widget.count > 0;
    final (top, bottom) = widget.tone == LqTone.accent
        ? (c.accentTop, c.accentBottom)
        : (c.dangerTop, c.dangerBottom);
    final label = _shown > widget.max ? '${widget.max}+' : '$_shown';
    Widget pill() => Container(
      constraints: BoxConstraints(
        minWidth: widget.dot ? 12 : 20,
        minHeight: widget.dot ? 12 : 20,
      ),
      padding: widget.dot ? null : const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ),
        // A ring in the page color lifts the pill off the button under it.
        border: Border.all(color: c.canvas, width: 2),
      ),
      child: widget.dot
          ? null
          : Text(
              label,
              textScaler: TextScaler.noScaling,
              style: LqTypography.numeric(lq.type.caption).copyWith(
                color: c.textOnAccent,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
    );

    return Semantics(
      value: visible && !widget.dot ? label : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_shown > 0)
            Positioned(
              top: -4,
              right: -4,
              child: ExcludeSemantics(
                child: AnimatedScale(
                  scale: visible ? 1 : 0,
                  duration: LqMotion.of(
                    context,
                    visible ? LqMotion.slow : LqMotion.standard,
                  ),
                  curve: visible ? LqMotion.springCurve : LqMotion.emphasized,
                  onEnd: () {
                    if (!visible && mounted) setState(() => _shown = 0);
                  },
                  // Re-keyed on every count so each change replays a pop.
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(_shown),
                    tween: Tween(begin: 0.6, end: 1),
                    duration: LqMotion.of(context, LqMotion.slow),
                    curve: LqMotion.springCurve,
                    builder: (context, s, child) =>
                        Transform.scale(scale: s, child: child),
                    child: pill(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

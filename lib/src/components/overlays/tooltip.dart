import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// Names an icon-only control: long-press it (or hover on desktop) and a
/// small glass label pops up above it on a spring, then leaves on its own.
class LqTooltip extends StatefulWidget {
  const LqTooltip({
    super.key,
    required this.message,
    required this.child,
    this.showFor = const Duration(milliseconds: 1800),
  });

  /// A few words, e.g. "Export Schedule C".
  final String message;

  /// The control being described.
  final Widget child;

  /// How long the label stays after a long press.
  final Duration showFor;

  @override
  State<LqTooltip> createState() => _LqTooltipState();
}

class _LqTooltipState extends State<LqTooltip>
    with SingleTickerProviderStateMixin {
  final _portal = OverlayPortalController();
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: LqMotion.slow,
    reverseDuration: LqMotion.fast,
  );
  Timer? _timer;

  void _show({Duration? hideAfter}) {
    _timer?.cancel();
    _pop.duration = LqMotion.of(context, LqMotion.slow);
    _pop.reverseDuration = LqMotion.of(context, LqMotion.fast);
    _portal.show();
    _pop.forward();
    if (hideAfter != null) _timer = Timer(hideAfter, _hide);
  }

  void _hide() {
    _timer?.cancel();
    if (!mounted) return;
    _pop.reverse().whenCompleteOrCancel(() {
      if (mounted && _pop.isDismissed) _portal.hide();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pop.dispose();
    super.dispose();
  }

  Widget _label(BuildContext context) {
    final lq = context.lq;
    // The anchor is this state's own box, not the overlay child's.
    final box = this.context.findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.of(this.context).context.findRenderObject() as RenderBox?;
    if (box == null || overlayBox == null || !box.hasSize) {
      return const SizedBox.shrink();
    }
    final anchor =
        box.localToGlobal(Offset.zero, ancestor: overlayBox) & box.size;
    final t = CurvedAnimation(parent: _pop, curve: LqMotion.springCurve);
    return IgnorePointer(
      child: CustomSingleChildLayout(
        delegate: _TipLayout(anchor, MediaQuery.paddingOf(context).top),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _pop, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.6, end: 1).animate(t),
            alignment: Alignment.bottomCenter,
            child: LqGlass(
              weight: LqGlassWeight.thick,
              padding: const EdgeInsets.symmetric(
                horizontal: LqSpace.x3,
                vertical: LqSpace.x1 + 2,
              ),
              child: Text(
                widget.message,
                style: lq.type.footnoteMedium.copyWith(
                  color: lq.colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _label,
      child: MouseRegion(
        onEnter: (_) => _timer = Timer(LqMotion.slow, _show),
        onExit: (_) => _hide(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            HapticFeedback.lightImpact();
            _show(hideAfter: widget.showFor);
          },
          child: Semantics(tooltip: widget.message, child: widget.child),
        ),
      ),
    );
  }
}

/// Centers the label above the anchor, kept inside the screen; flips
/// below when there is no room above.
class _TipLayout extends SingleChildLayoutDelegate {
  const _TipLayout(this.anchor, this.safeTop);

  final Rect anchor;
  final double safeTop;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints(maxWidth: constraints.maxWidth - LqSpace.gutter * 2);

  @override
  Offset getPositionForChild(Size size, Size child) {
    const gap = LqSpace.x2;
    final x = (anchor.center.dx - child.width / 2).clamp(
      LqSpace.gutter,
      size.width - LqSpace.gutter - child.width,
    );
    var y = anchor.top - gap - child.height;
    if (y < safeTop + gap) y = anchor.bottom + gap;
    return Offset(x.toDouble(), y);
  }

  @override
  bool shouldRelayout(_TipLayout old) =>
      old.anchor != anchor || old.safeTop != safeTop;
}

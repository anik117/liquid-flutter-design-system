import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../foundation/pressable.dart';
import '../../foundation/spring.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// A floating action button: a 56pt brand-gradient circle that can extend
/// to show a label ("Start drive"). It folds to icon-only when [extended]
/// is false, or on its own while [scrollController] scrolls down, and
/// unfolds when scrolling back up. The width settles on a spring.
class LqFab extends StatefulWidget {
  const LqFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.semanticLabel,
    this.extended = true,
    this.scrollController,
    this.glass = false,
  });

  /// The action's icon, usually a fill icon.
  final IconData icon;

  /// Called on tap. Null disables the button.
  final VoidCallback? onPressed;

  /// Text shown while extended, e.g. "Start drive".
  final String? label;

  /// Screen reader name; defaults to [label]. Required when there is none.
  final String? semanticLabel;

  /// Whether to show the label. Combine with [scrollController] or drive it
  /// yourself.
  final bool extended;

  /// Folds the button while this list scrolls down.
  final ScrollController? scrollController;

  /// A Liquid Glass face instead of the brand gradient.
  final bool glass;

  @override
  State<LqFab> createState() => _LqFabState();
}

class _LqFabState extends State<LqFab> with SingleTickerProviderStateMixin {
  static const _size = LqSize.fab;
  late final _width = AnimationController.unbounded(
    vsync: this,
    value: _target ? 1 : 0,
  );
  bool _scrolledAway = false;
  double _lastOffset = 0;

  bool get _target =>
      widget.label != null && widget.extended && !_scrolledAway;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(LqFab old) {
    super.didUpdateWidget(old);
    if (old.scrollController != widget.scrollController) {
      old.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }
    _settle();
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    _width.dispose();
    super.dispose();
  }

  void _onScroll() {
    final sc = widget.scrollController!;
    if (!sc.hasClients) return;
    final offset = sc.offset;
    final delta = offset - _lastOffset;
    // Small jitters are ignored so the button doesn't flicker.
    if (delta.abs() < 4 && offset > 0) return;
    _lastOffset = offset;
    final away = offset > 0 && delta > 0;
    if (away != _scrolledAway) {
      _scrolledAway = away;
      _settle();
    }
  }

  void _settle() {
    final target = _target ? 1.0 : 0.0;
    if (_width.value == target && !_width.isAnimating) return;
    LqSpring.animate(_width, target, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final enabled = widget.onPressed != null;
    final fg = !enabled
        ? c.disabledText
        : (widget.glass ? c.iconPrimary : c.textOnAccent);

    final content = AnimatedBuilder(
      animation: _width,
      builder: (context, _) {
        final t = _width.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: LqIconSize.xxl, color: fg),
            if (widget.label != null)
              ClipRect(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: t.clamp(0.0, 1.2),
                  child: Opacity(
                    opacity: t.clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: LqSpace.x2,
                        end: LqSpace.x1,
                      ),
                      child: Text(
                        widget.label!,
                        maxLines: 1,
                        style: lq.type.headline.copyWith(color: fg),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );

    return LqPressable(
      onTap: widget.onPressed,
      semanticLabel: widget.semanticLabel ?? widget.label,
      haptic: LqHaptic.medium,
      scale: widget.glass ? LqMotion.glassPressScale : 0.94,
      builder: (context, pressed) {
        final body = Padding(
          padding: const EdgeInsets.symmetric(horizontal: (_size - 24) / 2),
          child: ExcludeSemantics(child: Center(widthFactor: 1, child: content)),
        );
        if (widget.glass) {
          return SizedBox(
            height: _size,
            child: LqGlass(lit: pressed, child: body),
          );
        }
        return Container(
          height: _size,
          constraints: const BoxConstraints(minWidth: _size),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(LqRadius.full),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: !enabled
                  ? [c.disabledFill, c.disabledFill]
                  : pressed
                  ? [c.accentPressedTop, c.accentPressedBottom]
                  : [c.accentTop, c.accentBottom],
            ),
            boxShadow: enabled ? LqShadows.float(c.shadow) : null,
          ),
          // The lit top bevel BoardUI puts on solid buttons.
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(LqRadius.full),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x38FFFFFF), Color(0x00FFFFFF)],
              stops: [0, 0.14],
            ),
          ),
          child: body,
        );
      },
    );
  }
}

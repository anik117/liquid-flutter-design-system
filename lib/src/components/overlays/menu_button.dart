import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/glass.dart';
import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'menu_items.dart';
import 'menu_morph.dart';

export 'menu_items.dart'
    show LqMenuEntry, LqMenuItem, LqMenuHeader, LqMenuDivider;

/// The Liquid signature: a glass button whose menu morphs out of it. The
/// button's own glass stretches into the menu panel on a spring, the rows
/// fade in once the shape has opened, and tapping outside (or picking an
/// item) folds the panel back into the button.
class LqMenuButton<T> extends StatefulWidget {
  const LqMenuButton({
    super.key,
    required this.entries,
    required this.onSelected,
    required this.semanticLabel,
    this.icon = RemixIcons.more_fill,
    this.label,
    this.child,
    this.anchorRadius = LqRadius.full,
  });

  /// Items, headers and dividers, top to bottom.
  final List<LqMenuEntry<T>> entries;

  /// Called with the picked item's value.
  final ValueChanged<T> onSelected;

  /// The button's name for screen readers, e.g. "Sort drives".
  final String semanticLabel;

  /// Glyph on the glass button.
  final IconData icon;

  /// Optional text after the glyph; makes the button a capsule.
  final String? label;

  /// A custom face instead of the glass button; the menu morphs out of
  /// its rect. Draw it with your own background.
  final Widget? child;

  /// Corner radius of a custom [child], so the morph starts on its shape.
  final double anchorRadius;

  @override
  State<LqMenuButton<T>> createState() => _LqMenuButtonState<T>();
}

class _LqMenuButtonState<T> extends State<LqMenuButton<T>> {
  final _anchorKey = GlobalKey();
  OverlayEntry? _entry;

  bool get _open => _entry != null;

  void _show() {
    if (_open) return;
    final lq = context.lq;
    final overlay = Overlay.of(context, rootOverlay: true);
    final box = _anchorKey.currentContext!.findRenderObject()! as RenderBox;
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final rect =
        box.localToGlobal(Offset.zero, ancestor: overlayBox) & box.size;
    final entry = OverlayEntry(
      builder: (_) => LqScope(
        data: lq,
        child: LqMenuMorph<T>(
          anchor: rect,
          anchorRadius: widget.child == null
              ? LqRadius.full
              : widget.anchorRadius,
          entries: widget.entries,
          glyph: widget.child ?? _Face(icon: widget.icon, label: widget.label),
          onPick: (item) => widget.onSelected(item.value),
          onClosed: _removeEntry,
        ),
      ),
    );
    overlay.insert(entry);
    setState(() => _entry = entry);
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() {});
  }

  // The menu lives in the root overlay, so it would not follow a page
  // transition. Close it at once when this page starts leaving or another
  // page is pushed over it.
  ModalRoute<Object?>? _route;

  void _onRouteMove(AnimationStatus status) {
    if (!_open) return;
    final leaving = _route?.animation?.status == AnimationStatus.reverse;
    final covered = _route?.secondaryAnimation?.status == AnimationStatus.forward;
    if (leaving || covered) _removeEntry();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route == _route) return;
    _route?.animation?.removeStatusListener(_onRouteMove);
    _route?.secondaryAnimation?.removeStatusListener(_onRouteMove);
    _route = route;
    route?.animation?.addStatusListener(_onRouteMove);
    route?.secondaryAnimation?.addStatusListener(_onRouteMove);
  }

  @override
  void dispose() {
    _route?.animation?.removeStatusListener(_onRouteMove);
    _route?.secondaryAnimation?.removeStatusListener(_onRouteMove);
    _entry?.remove();
    _entry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      expanded: _open,
      child: LqPressable(
        onTap: _show,
        semanticLabel: widget.semanticLabel,
        scale: widget.child == null ? LqMotion.glassPressScale : 0.95,
        builder: (context, pressed) => Opacity(
          // The panel in the overlay stands in for the button while open.
          opacity: _open ? 0 : 1,
          child: KeyedSubtree(
            key: _anchorKey,
            child:
                widget.child ??
                SizedBox(
                  height: LqSize.control,
                  child: LqGlass(
                    lit: pressed,
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.label == null ? 0 : LqSpace.x4,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: LqSize.control,
                      ),
                      child: _Face(icon: widget.icon, label: widget.label),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

/// The glyph and optional label on the glass button.
class _Face extends StatelessWidget {
  const _Face({required this.icon, this.label});

  final IconData icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: LqIconSize.xl, color: c.iconPrimary),
        if (label != null) ...[
          const SizedBox(width: LqSpace.x2),
          Text(
            label!,
            maxLines: 1,
            style: lq.type.subheadMedium.copyWith(color: c.textPrimary),
          ),
        ],
      ],
    );
  }
}

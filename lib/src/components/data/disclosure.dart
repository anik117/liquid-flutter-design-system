import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/pressable.dart';
import '../../foundation/spring.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'disclosure_group.dart';

export 'disclosure_group.dart' show LqDisclosureGroup;

/// An accordion row: a header with a title, optional subtitle and a chevron
/// that turns as the body opens. The body grows open on a spring and fades
/// in. Inside an exclusive [LqDisclosureGroup], opening one closes the rest.
class LqDisclosure extends StatefulWidget {
  const LqDisclosure({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.leading,
    this.initiallyExpanded = false,
    this.onChanged,
  });

  /// Header text, e.g. a question.
  final String title;

  /// Quiet second line in the header.
  final String? subtitle;

  /// Header tile, e.g. a [LqIconTile].
  final Widget? leading;

  /// The body shown when open.
  final Widget child;

  /// Whether the body starts open.
  final bool initiallyExpanded;

  /// Called with the new state after a tap.
  final ValueChanged<bool>? onChanged;

  @override
  State<LqDisclosure> createState() => _LqDisclosureState();
}

class _LqDisclosureState extends State<LqDisclosure>
    with SingleTickerProviderStateMixin {
  late bool _open = widget.initiallyExpanded;
  late final _t = AnimationController(vsync: this, value: _open ? 1 : 0);
  ValueNotifier<Object?>? _group;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final group = LqDisclosureGroup.exclusiveOf(context);
    if (group != _group) {
      _group?.removeListener(_onGroup);
      _group = group?..addListener(_onGroup);
    }
  }

  @override
  void dispose() {
    _group?.removeListener(_onGroup);
    _t.dispose();
    super.dispose();
  }

  void _onGroup() {
    if (_open && _group!.value != this) _set(false);
  }

  void _set(bool open) {
    setState(() => _open = open);
    LqSpring.animate(_t, open ? 1 : 0, spring: LqSpring.firm, context: context);
    if (open && _group != null) _group!.value = this;
  }

  void _toggle() {
    _set(!_open);
    widget.onChanged?.call(_open);
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final header = Semantics(
      expanded: _open,
      child: LqPressable(
        onTap: _toggle,
        scale: 1,
        haptic: LqHaptic.selection,
        semanticLabel: widget.title,
        builder: (context, pressed) => AnimatedContainer(
          duration: LqMotion.fast,
          color: pressed ? c.surfacePressed : c.surface,
          constraints: const BoxConstraints(minHeight: LqSize.row),
          padding: const EdgeInsets.symmetric(
            horizontal: LqSpace.x4,
            vertical: LqSpace.x3,
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: LqSpace.x3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: lq.type.bodyMedium.copyWith(color: c.textPrimary),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle!,
                        style: lq.type.subhead.copyWith(color: c.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: LqSpace.x2),
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: LqMotion.of(context, LqMotion.slow),
                curve: LqMotion.springCurve,
                child: Icon(
                  RemixIcons.arrow_down_s_line,
                  size: LqIconSize.lg,
                  color: c.iconTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return ColoredBox(
      color: c.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          AnimatedBuilder(
            animation: _t,
            builder: (context, _) {
              final t = _t.value;
              if (t == 0) return const SizedBox.shrink();
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: t,
                  child: Opacity(
                    opacity: Curves.easeOut.transform(t),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        LqSpace.x4, 0, LqSpace.x4, LqSpace.x4,
                      ),
                      child: DefaultTextStyle.merge(
                        style: lq.type.subhead.copyWith(color: c.textSecondary),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

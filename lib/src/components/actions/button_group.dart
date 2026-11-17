import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// One part of an [LqButtonGroup]: a label, an icon, or both.
class LqButtonGroupItem {
  const LqButtonGroupItem({
    required this.onPressed,
    this.label,
    this.icon,
    this.semanticLabel,
  }) : assert(label != null || icon != null);

  /// Visible text, e.g. "Week".
  final String? label;

  /// Optional icon; alone it makes a toolbar-style part.
  final IconData? icon;

  /// Screen reader name for icon-only parts.
  final String? semanticLabel;

  /// Called when this part is tapped. Null disables it.
  final VoidCallback? onPressed;
}

/// Joined buttons sharing one bordered face with hairline dividers, e.g.
/// "Day | Week | Month" or a row of formatting icons. Each part presses on
/// its own; [selectedIndex] can tint one part to show the current choice.
class LqButtonGroup extends StatelessWidget {
  const LqButtonGroup({
    super.key,
    required this.items,
    this.selectedIndex,
    this.expand = false,
    this.small = false,
  });

  /// The parts, left to right.
  final List<LqButtonGroupItem> items;

  /// The part to show as current, if any.
  final int? selectedIndex;

  /// Stretch to the parent's width with equal parts.
  final bool expand;

  /// 36pt tall instead of 44pt.
  final bool small;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final radius = small ? lq.radius.sm : lq.radius.md;
    // Parts share the width when it runs short, so labels ellipsize
    // instead of overflowing. Unbounded (in a sideways scroll), they don't.
    List<Widget> parts(bool bounded) => [
      for (var i = 0; i < items.length; i++) ...[
        if (i > 0) SizedBox(width: 1, child: ColoredBox(color: c.border)),
        if (expand)
          Expanded(child: _part(context, i))
        else if (bounded)
          Flexible(child: _part(context, i))
        else
          _part(context, i),
      ],
    ];
    return Container(
      height: small ? LqSize.controlSmall : LqSize.control,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: c.border),
        boxShadow: LqShadows.xs(c.shadow),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: LayoutBuilder(
          builder: (context, box) => Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: parts(box.hasBoundedWidth),
          ),
        ),
      ),
    );
  }

  Widget _part(BuildContext context, int i) {
    final lq = context.lq;
    final c = lq.colors;
    final item = items[i];
    final selected = i == selectedIndex;
    final enabled = item.onPressed != null;
    final fg = !enabled
        ? c.disabledText
        : (selected ? c.accentOnSoft : c.textPrimary);
    return Semantics(
      selected: selected,
      child: LqPressable(
        onTap: item.onPressed,
        scale: 1,
        semanticLabel: item.label == null ? item.semanticLabel : null,
        builder: (context, pressed) => AnimatedContainer(
          duration: LqMotion.of(context, LqMotion.fast),
          constraints: BoxConstraints(
            minWidth: small ? LqSize.controlSmall : LqSize.control,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: item.label == null ? LqSpace.x2 : LqSpace.x4,
          ),
          alignment: Alignment.center,
          color: selected
              ? (pressed ? c.accentSoftPressed : c.accentSoft)
              : (pressed ? c.surfacePressed : c.surface),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null)
                Icon(item.icon, size: LqIconSize.lg, color: fg),
              if (item.icon != null && item.label != null)
                const SizedBox(width: 6),
              if (item.label != null)
                Flexible(
                  child: Text(
                    item.label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: lq.type.subheadMedium.copyWith(color: fg),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

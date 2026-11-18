import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'chip_parts.dart';

/// What a chip does.
enum LqChipKind {
  /// Toggles on and off; a check slides in while selected.
  filter,

  /// One pick from a set (see `LqChipGroup`); tints when selected.
  choice,

  /// A value the person entered, e.g. a trip tag, with a remove button.
  input,
}

/// A compact capsule for filtering, picking or showing entered values.
/// Selected chips take a soft brand tint; filter chips slide a check in.
/// Input chips collapse away when their × is tapped, then call [onRemoved].
/// Give input chips a key so the right one collapses.
class LqChip extends StatefulWidget {
  /// A chip that toggles, e.g. a platform filter.
  const LqChip.filter({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.leadingIcon,
  }) : kind = LqChipKind.filter,
       onRemoved = null;

  /// A chip that is one pick from a set.
  const LqChip.choice({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.leadingIcon,
  }) : kind = LqChipKind.choice,
       onRemoved = null;

  /// A chip showing an entered value, with a remove button.
  const LqChip.input({
    super.key,
    required this.label,
    required VoidCallback this.onRemoved,
    this.leadingIcon,
  }) : kind = LqChipKind.input,
       selected = false,
       onSelected = null;

  /// The chip's text, short: "Uber", "Airport run".
  final String label;

  /// Filter, choice or input.
  final LqChipKind kind;

  /// Whether a filter or choice chip is on.
  final bool selected;

  /// Called with the new selected state when tapped. Null disables the chip.
  final ValueChanged<bool>? onSelected;

  /// Called after an input chip finishes collapsing away.
  final VoidCallback? onRemoved;

  /// Optional small icon before the label.
  final IconData? leadingIcon;

  @override
  State<LqChip> createState() => _LqChipState();
}

class _LqChipState extends State<LqChip> with SingleTickerProviderStateMixin {
  late final _presence = AnimationController(vsync: this, value: 1);
  bool _removing = false;

  @override
  void didUpdateWidget(LqChip old) {
    super.didUpdateWidget(old);
    // A reused state for a different value must show up again.
    if (old.label != widget.label) {
      _removing = false;
      _presence.value = 1;
    }
  }

  @override
  void dispose() {
    _presence.dispose();
    super.dispose();
  }

  Future<void> _remove() async {
    if (_removing) return;
    _removing = true;
    LqHaptics.play(LqHaptic.light);
    await _presence.animateTo(
      0,
      duration: LqMotion.of(context, LqMotion.standard),
      curve: LqMotion.emphasized,
    );
    if (mounted) widget.onRemoved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final input = widget.kind == LqChipKind.input;
    final selected = widget.selected && !input;
    final enabled = input || widget.onSelected != null;
    final fg = !enabled
        ? c.disabledText
        : (selected ? c.accentOnSoft : c.textPrimary);

    Widget face(bool pressed) {
      // Selected chips take the soft accent tint with a faint accent rim:
      // clearly picked, but never a solid white (dark) or ink (light) block.
      final fill = selected
          ? (pressed ? c.accentSoftPressed : c.accentSoft)
          : (pressed ? c.surfacePressed : c.surface);
      return AnimatedContainer(
        duration: LqMotion.of(context, LqMotion.fast),
        height: LqSize.controlSmall,
        padding: EdgeInsetsDirectional.only(
          start: LqSpace.x3,
          end: input ? 0 : LqSpace.x3,
        ),
        decoration: BoxDecoration(
          color: enabled ? fill : c.disabledFill,
          borderRadius: BorderRadius.circular(LqRadius.full),
          border: Border.all(
            color: selected ? c.accent.withValues(alpha: 0.4) : c.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.kind == LqChipKind.filter)
              LqChipCheck(selected: selected, color: fg),
            if (widget.leadingIcon != null) ...[
              Icon(
                widget.leadingIcon,
                size: LqIconSize.sm,
                color: selected ? fg : c.iconSecondary,
              ),
              const SizedBox(width: 6),
            ],
            // Capped so a long label at large text sizes ellipsizes
            // instead of overflowing, even in a sideways-scrolling row.
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.6,
              ),
              child: Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: lq.type.subheadMedium.copyWith(color: fg),
              ),
            ),
            if (input) LqChipRemoveButton(label: widget.label, onTap: _remove),
          ],
        ),
      );
    }

    final Widget chip = input
        ? Semantics(container: true, child: face(false))
        : Semantics(
            selected: selected,
            child: LqPressable(
              onTap: enabled
                  ? () => widget.onSelected!(!widget.selected)
                  : null,
              haptic: LqHaptic.selection,
              builder: (context, pressed) => face(pressed),
            ),
          );

    // Padding brings the hit area to 44pt without a taller face.
    return SizeTransition(
      sizeFactor: _presence,
      axis: Axis.horizontal,
      alignment: AlignmentDirectional.centerStart,
      child: FadeTransition(
        opacity: _presence,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: (LqSize.control - LqSize.controlSmall) / 2,
          ),
          child: chip,
        ),
      ),
    );
  }
}

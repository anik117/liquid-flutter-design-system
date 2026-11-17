import 'package:flutter/widgets.dart';

import '../../tokens/metrics.dart';
import 'chip.dart';

/// One option in an [LqChipGroup].
class LqChipOption<T> {
  const LqChipOption({required this.value, required this.label, this.icon});

  /// The value reported when this chip is picked.
  final T value;

  /// The chip's text.
  final String label;

  /// Optional small icon before the label.
  final IconData? icon;
}

/// A set of chips. Single select uses choice chips (exactly one stays
/// picked); multi select uses filter chips with sliding checks. Lays out as
/// one sideways-scrolling row, or wraps onto more lines.
class LqChipGroup<T> extends StatelessWidget {
  const LqChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.multiSelect = false,
    this.wrap = false,
    this.padding = EdgeInsets.zero,
  });

  /// The chips, in order.
  final List<LqChipOption<T>> options;

  /// The values currently picked.
  final Set<T> selected;

  /// Called with the new set of picked values.
  final ValueChanged<Set<T>> onChanged;

  /// Many at once (filter chips) instead of one (choice chips).
  final bool multiSelect;

  /// Wrap onto more lines instead of scrolling sideways.
  final bool wrap;

  /// Inset of the scrolling row, so chips can scroll to the screen edge.
  final EdgeInsetsGeometry padding;

  void _tap(T value) {
    if (multiSelect) {
      final next = {...selected};
      if (!next.remove(value)) next.add(value);
      onChanged(next);
    } else if (!(selected.length == 1 && selected.contains(value))) {
      onChanged({value});
    }
  }

  @override
  Widget build(BuildContext context) {
    final chips = [
      for (final o in options)
        multiSelect
            ? LqChip.filter(
                label: o.label,
                leadingIcon: o.icon,
                selected: selected.contains(o.value),
                onSelected: (_) => _tap(o.value),
              )
            : LqChip.choice(
                label: o.label,
                leadingIcon: o.icon,
                selected: selected.contains(o.value),
                onSelected: (_) => _tap(o.value),
              ),
    ];
    if (wrap) {
      return Padding(
        padding: padding,
        child: Wrap(spacing: LqSpace.x2, children: chips),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: LqSpace.x2),
            chips[i],
          ],
        ],
      ),
    );
  }
}

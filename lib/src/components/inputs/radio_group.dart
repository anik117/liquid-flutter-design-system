import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import '../data/list_group.dart';
import 'radio.dart';

/// One choice in a [LqRadioGroup].
class LqRadioOption<T> {
  const LqRadioOption({
    required this.value,
    required this.label,
    this.description,
    this.enabled = true,
  });

  /// What [LqRadioGroup.onChanged] reports when this is picked.
  final T value;

  /// The choice's name, e.g. "Standard mileage".
  final String label;

  /// A quieter line explaining the choice.
  final String? description;

  /// False dims this one choice and blocks it.
  final bool enabled;
}

/// A set of mutually exclusive choices. By default the options sit on one
/// inset grouped surface (like [LqListGroup]) with the radio leading each
/// row; set [grouped] to false for a plain stack of [LqRadio]s.
class LqRadioGroup<T> extends StatelessWidget {
  const LqRadioGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.grouped = true,
    this.header,
    this.footer,
  });

  /// The choices, in order.
  final List<LqRadioOption<T>> options;

  /// The selected value, or null when nothing is chosen yet.
  final T? value;

  /// Called with the newly picked value; null disables the whole group.
  final ValueChanged<T>? onChanged;

  /// Rows on a rounded surface (true) or a plain stack (false).
  final bool grouped;

  /// Sentence-case title above a grouped list.
  final String? header;

  /// Note under a grouped list.
  final String? footer;

  @override
  Widget build(BuildContext context) {
    VoidCallback? pick(LqRadioOption<T> o) =>
        onChanged == null || !o.enabled ? null : () => onChanged!(o.value);

    if (!grouped) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in options)
            LqRadio(
              selected: o.value == value,
              onSelected: pick(o),
              label: o.label,
              description: o.description,
            ),
        ],
      );
    }
    return LqListGroup(
      header: header,
      footer: footer,
      leadingInset: false,
      children: [
        for (final o in options)
          _RadioRow(option: o, selected: o.value == value, onTap: pick(o)),
      ],
    );
  }
}

class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({required this.option, required this.selected, this.onTap});

  final LqRadioOption<T> option;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final enabled = onTap != null;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: LqPressable(
        isButton: false,
        scale: 1,
        haptic: LqHaptic.selection,
        semanticLabel: option.label,
        onTap: enabled
            ? () {
                if (!selected) onTap!();
              }
            : null,
        // Rows show a pressed fill rather than shrinking, like list rows.
        builder: (context, pressed) => AnimatedContainer(
          duration: LqMotion.fast,
          color: pressed ? c.surfacePressed : c.surface,
          constraints: const BoxConstraints(minHeight: LqSize.row),
          padding: const EdgeInsets.symmetric(
            horizontal: LqSpace.x4,
            vertical: LqSpace.x3,
          ),
          child: Row(
            crossAxisAlignment: option.description == null
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              LqRadioMark(selected: selected, enabled: enabled),
              const SizedBox(width: LqSpace.x3),
              Expanded(
                child: Opacity(
                  opacity: enabled ? 1 : 0.45,
                  child: RadioText(
                    label: option.label,
                    description: option.description,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// The radio circle on its own, with no gesture: a bordered white ring
/// that fills with the brand gradient when selected while a white center
/// dot pops in on a spring. Use it inside rows that handle the tap.
class LqRadioMark extends StatelessWidget {
  const LqRadioMark({super.key, required this.selected, this.enabled = true});

  /// Filled when true.
  final bool selected;

  /// False dims the mark.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: AnimatedContainer(
        duration: LqMotion.of(context, LqMotion.fast),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? null : c.surface,
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [c.accentTop, c.accentBottom],
                )
              : null,
          border: Border.all(color: selected ? c.accentTop : c.borderStrong),
          boxShadow: LqShadows.card(c.shadow),
        ),
        // The lit top bevel BoardUI puts on filled controls.
        foregroundDecoration: selected
            ? const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x40FFFFFF), Color(0x00FFFFFF)],
                  stops: [0, 0.25],
                ),
              )
            : null,
        child: Center(
          child: AnimatedScale(
            scale: selected ? 1 : 0,
            duration: LqMotion.of(context, LqMotion.standard),
            curve: LqMotion.springCurve,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.textOnAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single radio button with an optional label and description. Tapping
/// selects it; it never deselects itself. For a set of choices use
/// [LqRadioGroup].
class LqRadio extends StatelessWidget {
  const LqRadio({
    super.key,
    required this.selected,
    required this.onSelected,
    this.label,
    this.description,
  });

  /// Whether this choice is the current one.
  final bool selected;

  /// Called when tapped while not selected; null disables it.
  final VoidCallback? onSelected;

  /// Text to the right; tapping it selects too.
  final String? label;

  /// A quieter line under [label].
  final String? description;

  @override
  Widget build(BuildContext context) {
    final enabled = onSelected != null;
    final mark = LqRadioMark(selected: selected, enabled: enabled);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: LqPressable(
        isButton: false,
        scale: 0.97,
        haptic: LqHaptic.selection,
        semanticLabel: label,
        onTap: enabled
            ? () {
                if (!selected) onSelected!();
              }
            : null,
        builder: (context, _) => label == null
            ? SizedBox.square(dimension: LqSize.control, child: Center(child: mark))
            : Container(
                constraints: const BoxConstraints(minHeight: LqSize.control),
                // A two-line choice keeps its first line where a one-line
                // choice's text sits, so a stack of radios reads evenly.
                padding: EdgeInsets.symmetric(
                  vertical: description == null ? 0 : (LqSize.control - 22) / 2,
                ),
                child: Row(
                  crossAxisAlignment: description == null
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: description == null ? 0 : 1),
                      child: mark,
                    ),
                    const SizedBox(width: LqSpace.x3),
                    Expanded(
                      child: Opacity(
                        opacity: enabled ? 1 : 0.45,
                        child: RadioText(label: label!, description: description),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Label and optional description, shared by [LqRadio] and group rows.
class RadioText extends StatelessWidget {
  const RadioText({super.key, required this.label, this.description});

  /// Main line.
  final String label;

  /// Quieter second line.
  final String? description;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: lq.type.body.copyWith(color: c.textPrimary)),
        if (description != null) ...[
          const SizedBox(height: 2),
          Text(
            description!,
            style: lq.type.subhead.copyWith(color: c.textSecondary),
          ),
        ],
      ],
    );
  }
}

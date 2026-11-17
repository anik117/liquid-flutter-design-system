import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// BoardUI's checkbox: a bordered white square that fills with the brand
/// gradient and an inner top highlight when checked; the tick pops in.
class LqCheckbox extends StatelessWidget {
  const LqCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  /// Optional text to the right; tapping it toggles too.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final enabled = onChanged != null;
    final radius = BorderRadius.circular(lq.radius.xs);

    final box = AnimatedContainer(
      duration: LqMotion.fast,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: value ? null : c.surface,
        gradient: value
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [c.accentTop, c.accentBottom],
              )
            : null,
        border: Border.all(color: value ? c.accentTop : c.borderStrong),
        boxShadow: LqShadows.card(c.shadow),
      ),
      foregroundDecoration: value
          ? BoxDecoration(
              borderRadius: radius,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x40FFFFFF), Color(0x00FFFFFF)],
                stops: [0, 0.2],
              ),
            )
          : null,
      child: AnimatedScale(
        scale: value ? 1 : 0,
        duration: LqMotion.standard,
        curve: LqMotion.springCurve,
        child: Icon(RemixIcons.check_line, size: 16, color: c.textOnAccent),
      ),
    );

    return Semantics(
      checked: value,
      label: label,
      child: LqPressable(
        isButton: false,
        scale: 0.94,
        haptic: LqHaptic.selection,
        onTap: enabled ? () => onChanged!(!value) : null,
        builder: (context, _) => Opacity(
          opacity: enabled ? 1 : 0.45,
          child: label == null
              ? box
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    box,
                    const SizedBox(width: LqSpace.x3),
                    Flexible(
                      child: Text(
                        label!,
                        style: lq.type.body.copyWith(color: c.textPrimary),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

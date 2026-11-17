import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// BoardUI's switch: a brand gradient chip when on, a soft white chip when
/// off, and a white knob that springs across. iOS proportions (51 × 31).
class LqSwitch extends StatelessWidget {
  const LqSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  static const double _w = 51, _h = 31, _pad = 2;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final enabled = onChanged != null;
    void dragTo(bool on) {
      if (on == value) return;
      HapticFeedback.selectionClick();
      onChanged!(on);
    }

    return Semantics(
      toggled: value,
      label: semanticLabel,
      // Swiping the knob across toggles too, as on iOS.
      child: GestureDetector(
        onHorizontalDragUpdate: enabled
            ? (d) {
                if (d.delta.dx > 1.5) dragTo(true);
                if (d.delta.dx < -1.5) dragTo(false);
              }
            : null,
        child: LqPressable(
          isButton: false,
          scale: 0.96,
          haptic: LqHaptic.selection,
          onTap: enabled ? () => onChanged!(!value) : null,
          builder: (context, pressed) => Opacity(
            opacity: enabled ? 1 : 0.45,
            child: AnimatedContainer(
              duration: LqMotion.of(context, LqMotion.standard),
              curve: LqMotion.emphasized,
              width: _w,
              height: _h,
              padding: const EdgeInsets.all(_pad),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(LqRadius.full),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: value
                      ? [c.accentTop, c.accentBottom]
                      : [c.switchOffTop, c.switchOffBottom],
                ),
                border: Border.all(
                  color: value ? c.accentBottom : c.border,
                  width: 1,
                ),
              ),
              child: AnimatedAlign(
                duration: LqMotion.of(context, LqMotion.slow),
                curve: LqMotion.springCurve,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: LqMotion.fast,
                  // The knob stretches a little while held, like iOS.
                  width: (_h - _pad * 2 - 2) + (pressed ? 6 : 0),
                  height: _h - _pad * 2 - 2,
                  decoration: BoxDecoration(
                    color: c.knob,
                    borderRadius: BorderRadius.circular(LqRadius.full),
                    boxShadow: LqShadows.sm(c.shadow),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

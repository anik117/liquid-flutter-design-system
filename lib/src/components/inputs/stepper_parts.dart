import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// One end of an [LqStepper]: tap steps once; holding repeats, slowly at
/// first and then faster, like UIStepper's autorepeat.
class StepperButton extends StatefulWidget {
  const StepperButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onStep,
  });

  /// The − or + glyph.
  final IconData icon;

  /// Spoken name, e.g. "Increase".
  final String semanticLabel;

  /// Steps once and returns false when the bound is reached; null disables.
  final bool Function()? onStep;

  @override
  State<StepperButton> createState() => _StepperButtonState();
}

class _StepperButtonState extends State<StepperButton> {
  Timer? _timer;
  int _repeats = 0;
  bool _holding = false;

  void _start() {
    if (widget.onStep == null) return;
    setState(() => _holding = true);
    _repeats = 0;
    _tick();
  }

  void _tick() {
    final step = widget.onStep;
    if (!mounted || step == null || !step()) return _stop();
    _repeats++;
    // 260ms between the first repeats, easing down to 45ms when held long.
    final ms = math.max(45, (260 * math.pow(0.86, _repeats)).round());
    _timer = Timer(Duration(milliseconds: ms), _tick);
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    if (mounted && _holding) setState(() => _holding = false);
  }

  @override
  void didUpdateWidget(StepperButton old) {
    super.didUpdateWidget(old);
    if (widget.onStep == null) _stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final enabled = widget.onStep != null;
    return GestureDetector(
      onLongPressStart: enabled ? (_) => _start() : null,
      onLongPressEnd: enabled ? (_) => _stop() : null,
      onLongPressCancel: enabled ? _stop : null,
      child: LqPressable(
        semanticLabel: widget.semanticLabel,
        haptic: LqHaptic.none,
        scale: 0.92,
        onTap: enabled ? () => widget.onStep!() : null,
        builder: (context, pressed) => AnimatedContainer(
          duration: LqMotion.fast,
          width: LqSize.control,
          height: LqSize.control,
          decoration: BoxDecoration(
            color: pressed || _holding ? c.surfacePressed : null,
            borderRadius: BorderRadius.circular(lq.radius.md - 2),
          ),
          child: Icon(
            widget.icon,
            size: LqIconSize.lg,
            color: enabled ? c.iconPrimary : c.disabledText,
          ),
        ),
      ),
    );
  }
}

/// The value in the middle, sliding up when it grows and down when it
/// shrinks, with a cross-fade.
class StepperValue extends StatelessWidget {
  const StepperValue({super.key, required this.text, required this.rising});

  /// The formatted value.
  final String text;

  /// True when the last change increased the value.
  final bool rising;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return ClipRect(
      child: AnimatedSwitcher(
        duration: LqMotion.of(context, LqMotion.standard),
        switchInCurve: LqMotion.emphasized,
        switchOutCurve: LqMotion.emphasized,
        transitionBuilder: (child, animation) {
          final incoming = child.key == ValueKey(text);
          final from = (incoming == rising) ? 0.6 : -0.6;
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(begin: Offset(0, from), end: Offset.zero).animate(animation),
              child: child,
            ),
          );
        },
        child: Text(
          text,
          key: ValueKey(text),
          maxLines: 1,
          style: lq.type.headline.copyWith(
            color: lq.colors.textPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}

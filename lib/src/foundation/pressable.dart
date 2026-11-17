import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../tokens/motion.dart';
import 'haptics.dart';

export 'haptics.dart' show LqHaptic, LqHaptics;

/// BoardUI's press motion for every tappable thing: the control shrinks to
/// 0.97 quickly while held and springs back on release. [builder] receives
/// the pressed state so a control can also shift its colors.
class LqPressable extends StatefulWidget {
  const LqPressable({
    super.key,
    required this.builder,
    this.onTap,
    this.onLongPress,
    this.haptic = LqHaptic.light,
    this.scale = LqMotion.pressScale,
    this.semanticLabel,
    this.isButton = true,
  });

  final Widget Function(BuildContext context, bool pressed) builder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final LqHaptic haptic;
  final double scale;
  final String? semanticLabel;
  final bool isButton;

  bool get enabled => onTap != null || onLongPress != null;

  @override
  State<LqPressable> createState() => _LqPressableState();
}

class _LqPressableState extends State<LqPressable> {
  bool _pressed = false;

  void _set(bool value) {
    if (_pressed != value && mounted) setState(() => _pressed = value);
  }

  void _playHaptic() => LqHaptics.play(widget.haptic);

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    final pressed = enabled && _pressed;
    final still = LqMotion.reduced(context);
    // Glass swells under the finger and settles on a spring; solid controls
    // sink quickly and ease back (BoardUI's press motion).
    final swells = widget.scale > 1;
    final scale = still || !pressed ? 1.0 : widget.scale;
    final duration = swells
        ? LqMotion.slow
        : (pressed ? LqMotion.pressIn : LqMotion.slow);
    final curve = swells
        ? LqMotion.springCurve
        : (pressed ? Curves.easeOut : LqMotion.release);
    return Semantics(
      button: widget.isButton,
      enabled: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _set(true) : null,
        onTapUp: enabled ? (_) => _set(false) : null,
        onTapCancel: enabled ? () => _set(false) : null,
        onTap: widget.onTap == null
            ? null
            : () {
                _playHaptic();
                widget.onTap!();
              },
        onLongPress: widget.onLongPress == null
            ? null
            : () {
                _set(false);
                HapticFeedback.mediumImpact();
                widget.onLongPress!();
              },
        child: AnimatedScale(
          scale: scale,
          duration: duration,
          curve: curve,
          child: widget.builder(context, pressed),
        ),
      ),
    );
  }
}

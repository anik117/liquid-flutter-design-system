import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// One digit box of an [LqOtpField]: a bordered white cell that shows its
/// digit, pops slightly when filled, and blinks a caret while it is the
/// active box.
class OtpBox extends StatelessWidget {
  const OtpBox({
    super.key,
    required this.char,
    required this.active,
    required this.hasError,
    required this.blink,
  });

  /// The digit, or '' when empty.
  final String char;

  /// True for the box the next digit goes into.
  final bool active;

  /// Draws the danger border.
  final bool hasError;

  /// Drives the caret: visible while above 0.5.
  final Animation<double> blink;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final borderColor = hasError
        ? c.textDanger
        : active
        ? c.accent
        : c.border;
    final box = AnimatedContainer(
      duration: LqMotion.fast,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(lq.radius.md),
        border: Border.all(color: borderColor, width: active ? 1.5 : 1),
        boxShadow: active
            ? [BoxShadow(color: borderColor.withValues(alpha: 0.18), spreadRadius: 3)]
            : LqShadows.card(c.shadow),
      ),
      child: char.isNotEmpty
          ? Text(
              char,
              style: lq.type.title2.copyWith(
                color: c.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            )
          : active
          ? FadeTransition(
              opacity: blink,
              child: Container(
                width: 2,
                height: 26,
                decoration: BoxDecoration(
                  color: c.accent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            )
          : null,
    );
    // A new digit pops (springs past full size and settles); deleting doesn't.
    return TweenAnimationBuilder<double>(
      key: ValueKey(char),
      tween: Tween(begin: char.isEmpty ? 1 : 0.86, end: 1),
      duration: LqMotion.of(context, LqMotion.standard),
      curve: LqMotion.springCurve,
      builder: (context, s, child) => Transform.scale(scale: s, child: child),
      child: box,
    );
  }
}

/// The caret blink: visible for the first half of each second, hidden for
/// the second half, like the system caret.
class OtpBlink extends Animatable<double> {
  const OtpBlink();

  @override
  double transform(double t) => t < 0.5 ? 1 : 0;
}

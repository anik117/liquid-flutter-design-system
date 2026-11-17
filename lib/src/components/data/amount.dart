import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';
import '../../tokens/typography.dart';

/// The screen's one big number. The whole part is large; the currency sign,
/// decimals and unit are smaller and grey, as in "$1,639.85" or "2,157.7 mi".
/// Digits are tabular, and a new value blurs in over the old one rather
/// than jumping. Screen readers announce changes.
class LqAmount extends StatelessWidget {
  const LqAmount({
    super.key,
    required this.value,
    this.prefix,
    this.unit,
    this.decimals = 2,
    this.style,
    this.color,
    this.minorColor,
  });

  final double value;

  /// Currency sign before the number, e.g. "$".
  final String? prefix;

  /// Unit after the number, e.g. "mi".
  final String? unit;
  final int decimals;

  /// Defaults to the hero style.
  final TextStyle? style;
  final Color? color;

  /// Color of the sign, decimals and unit (grey by default).
  final Color? minorColor;

  /// Groups thousands with commas: 12345.6 → ("12,345", ".60").
  static (String whole, String fraction) split(double v, int decimals) {
    final fixed = v.abs().toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final digits = parts[0];
    final buf = StringBuffer(v < 0 ? '−' : '');
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return (buf.toString(), parts.length > 1 ? '.${parts[1]}' : '');
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final big = LqTypography.numeric(style ?? lq.type.hero)
        .copyWith(color: color ?? c.textPrimary);
    final small = big.copyWith(
      fontSize: (big.fontSize ?? 44) * 0.55,
      color: minorColor ?? c.textSecondary,
      letterSpacing: 0,
    );
    final (whole, fraction) = split(value, decimals);
    final label = '${prefix ?? ''}$whole$fraction${unit == null ? '' : ' $unit'}';

    return Semantics(
      label: label,
      liveRegion: true,
      excludeSemantics: true,
      // Large text sizes shrink a long amount instead of clipping it.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: AnimatedSwitcher(
          duration: LqMotion.of(context, LqMotion.slow),
          switchInCurve: LqMotion.emphasized,
          switchOutCurve: LqMotion.emphasized,
          layoutBuilder: (current, previous) => Stack(
            alignment: Alignment.centerLeft,
            children: [...previous, ?current],
          ),
          // The old value blurs out while the new one sharpens in.
          transitionBuilder: (child, anim) => AnimatedBuilder(
            animation: anim,
            child: child,
            builder: (context, child) {
              final blur = (1 - anim.value) * 8;
              return Opacity(
                opacity: anim.value.clamp(0.0, 1.0),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: child,
                ),
              );
            },
          ),
          child: Text.rich(
            key: ValueKey(label),
            TextSpan(children: [
              if (prefix != null) TextSpan(text: prefix, style: small),
              TextSpan(text: whole, style: big),
              if (fraction.isNotEmpty) TextSpan(text: fraction, style: small),
              if (unit != null) TextSpan(text: ' $unit', style: small),
            ]),
            textHeightBehavior: LqTypography.tight,
          ),
        ),
      ),
    );
  }
}

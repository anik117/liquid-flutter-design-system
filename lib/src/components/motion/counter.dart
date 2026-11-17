import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';
import '../../tokens/typography.dart';
import '../data/amount.dart';
import 'counter_digit.dart';

/// A rolling-digit number, odometer style, e.g. "12,418.6 mi". When the
/// value changes each digit wheel rolls to its new digit on a spring;
/// unchanged digits stay still. Digits are tabular so nothing shifts
/// sideways. Under Reduce Motion the number just changes.
class LqCounter extends StatefulWidget {
  const LqCounter({
    super.key,
    required this.value,
    this.decimals = 0,
    this.prefix,
    this.suffix,
    this.style,
    this.color,
  });

  /// The number to show.
  final double value;

  /// Digits after the decimal point.
  final int decimals;

  /// Smaller grey text before the number, e.g. "$".
  final String? prefix;

  /// Smaller grey text after the number, e.g. "mi".
  final String? suffix;

  /// Defaults to the hero style.
  final TextStyle? style;

  /// Digit color; defaults to primary text.
  final Color? color;

  @override
  State<LqCounter> createState() => _LqCounterState();
}

class _LqCounterState extends State<LqCounter> {
  bool _up = true;

  @override
  void didUpdateWidget(LqCounter old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _up = widget.value > old.value;
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final big = LqTypography.numeric(widget.style ?? lq.type.hero)
        .copyWith(color: widget.color ?? c.textPrimary);
    final small = big.copyWith(
      fontSize: (big.fontSize ?? 44) * 0.55,
      color: c.textSecondary,
      letterSpacing: 0,
    );
    final (whole, fraction) = LqAmount.split(widget.value, widget.decimals);
    final text = '$whole$fraction';
    final label = '${widget.prefix ?? ''}$text${widget.suffix == null ? '' : ' ${widget.suffix}'}';

    final glyphs = <Widget>[];
    for (var i = 0; i < text.length; i++) {
      // Keyed by place from the right, so the ones wheel stays the ones
      // wheel when the number gains a digit.
      final place = text.length - i;
      final ch = text[i];
      final d = int.tryParse(ch);
      glyphs.add(d == null
          ? Text(ch, key: ValueKey('s$place'), style: big, textHeightBehavior: LqTypography.tight)
          : CounterDigit(key: ValueKey('d$place'), digit: d, up: _up, style: big));
    }

    return Semantics(
      label: label,
      liveRegion: true,
      excludeSemantics: true,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: AnimatedSize(
          duration: LqMotion.of(context, LqMotion.standard),
          curve: LqMotion.emphasized,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (widget.prefix != null)
                Text(widget.prefix!, style: small, textHeightBehavior: LqTypography.tight),
              ...glyphs,
              if (widget.suffix != null)
                Text(' ${widget.suffix}', style: small, textHeightBehavior: LqTypography.tight),
            ],
          ),
        ),
      ),
    );
  }
}

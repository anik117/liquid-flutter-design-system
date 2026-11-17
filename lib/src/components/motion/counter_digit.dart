import 'package:flutter/widgets.dart';

import '../../foundation/spring.dart';
import '../../tokens/motion.dart';
import '../../tokens/typography.dart';

/// One odometer wheel of an [LqCounter]: shows [digit] and rolls to a new
/// one on a spring, forward when the number rose and backward when it fell
/// (9 rolls on to 0, as on a real odometer).
class CounterDigit extends StatefulWidget {
  const CounterDigit({super.key, required this.digit, required this.up, required this.style});

  /// The digit to show, 0…9.
  final int digit;

  /// The number rose, so the wheel rolls forward.
  final bool up;

  /// Text style, tabular figures.
  final TextStyle style;

  @override
  State<CounterDigit> createState() => _CounterDigitState();
}

class _CounterDigitState extends State<CounterDigit> with SingleTickerProviderStateMixin {
  // The wheel's position: 3.4 means 40% of the way from 3 to 4.
  late final AnimationController _wheel =
      AnimationController.unbounded(vsync: this, value: widget.digit.toDouble());

  @override
  void didUpdateWidget(CounterDigit old) {
    super.didUpdateWidget(old);
    if (old.digit == widget.digit) return;
    final from = _wheel.value.round();
    var delta = widget.digit - from % 10;
    if (widget.up && delta < 0) delta += 10;
    if (!widget.up && delta > 0) delta -= 10;
    LqSpring.animate(_wheel, (from + delta).toDouble(), context: context);
  }

  @override
  void dispose() {
    _wheel.dispose();
    super.dispose();
  }

  Widget _glyph(int d, double shift) => Positioned.fill(
    child: FractionalTranslation(
      translation: Offset(0, shift),
      child: Center(
        child: Text('${d % 10}', style: widget.style, textHeightBehavior: LqTypography.tight),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Sizes the wheel to one tabular digit.
        Visibility.maintain(
          visible: false,
          child: Text('0', style: widget.style, textHeightBehavior: LqTypography.tight),
        ),
        Positioned.fill(
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _wheel,
              builder: (context, _) {
                final p = LqMotion.reduced(context) ? widget.digit.toDouble() : _wheel.value;
                final base = p.floor();
                final frac = p - base;
                return Stack(children: [
                  _glyph(base, -frac),
                  if (frac > 0.001) _glyph(base + 1, 1 - frac),
                ]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

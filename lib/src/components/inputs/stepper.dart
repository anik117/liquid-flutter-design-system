import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/haptics.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import 'stepper_parts.dart';

/// BoardUI's stepper: − value + on one bordered white pill, for small
/// counts like passengers or tolls. Each step ticks a selection haptic and
/// the number slides in its direction. A button greys out at its bound;
/// holding a button repeats, speeding up the longer it is held.
class LqStepper extends StatefulWidget {
  const LqStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.step = 1,
    this.decimals = 0,
    this.format,
    this.semanticLabel,
  }) : assert(min < max && step > 0);

  /// The current value.
  final double value;

  /// Called with each new value; null disables the stepper.
  final ValueChanged<double>? onChanged;

  /// Lowest allowed value; − disables there.
  final double min;

  /// Highest allowed value; + disables there.
  final double max;

  /// How much one tap adds or removes, e.g. 1 or 0.5.
  final double step;

  /// Digits after the point when no [format] is given.
  final int decimals;

  /// Custom text for the value, e.g. `(v) => '\$${v.toStringAsFixed(2)}'`.
  final String Function(double value)? format;

  /// What the value counts, read by screen readers, e.g. "Passengers".
  final String? semanticLabel;

  @override
  State<LqStepper> createState() => _LqStepperState();
}

class _LqStepperState extends State<LqStepper> {
  late double _value = widget.value;
  bool _rising = true;

  @override
  void didUpdateWidget(LqStepper old) {
    super.didUpdateWidget(old);
    if (widget.value != _value) {
      _rising = widget.value > _value;
      _value = widget.value;
    }
  }

  String _text(double v) => widget.format?.call(v) ?? v.toStringAsFixed(widget.decimals);

  bool get _canDown => widget.onChanged != null && _value > widget.min + 1e-9;
  bool get _canUp => widget.onChanged != null && _value < widget.max - 1e-9;

  /// Moves one step in [dir]; returns whether another step is possible.
  bool _stepBy(int dir) {
    if (!(dir > 0 ? _canUp : _canDown)) return false;
    final raw = (_value + dir * widget.step).clamp(widget.min, widget.max);
    // Round away float dust (0.1 + 0.2) so values and labels stay exact.
    final next = double.parse(raw.toStringAsFixed(10));
    setState(() {
      _rising = dir > 0;
      _value = next;
    });
    LqHaptics.play(LqHaptic.selection);
    widget.onChanged!(next);
    return dir > 0 ? _canUp : _canDown;
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final text = _text(_value);
    final enabled = widget.onChanged != null;

    return Semantics(
      label: widget.semanticLabel,
      value: text,
      increasedValue: _canUp ? _text(_value + widget.step) : null,
      decreasedValue: _canDown ? _text(_value - widget.step) : null,
      onIncrease: _canUp ? () => _stepBy(1) : null,
      onDecrease: _canDown ? () => _stepBy(-1) : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(lq.radius.md),
            border: Border.all(color: c.border),
            boxShadow: LqShadows.card(c.shadow),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StepperButton(
                icon: RemixIcons.subtract_line,
                semanticLabel: 'Decrease',
                onStep: _canDown ? () => _stepBy(-1) : null,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: LqSpace.x10),
                child: ExcludeSemantics(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: LqSpace.x1),
                    child: Center(
                      widthFactor: 1,
                      child: StepperValue(text: text, rising: _rising),
                    ),
                  ),
                ),
              ),
              StepperButton(
                icon: RemixIcons.add_line,
                semanticLabel: 'Increase',
                onStep: _canUp ? () => _stepBy(1) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

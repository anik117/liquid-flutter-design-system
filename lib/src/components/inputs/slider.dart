import 'package:flutter/widgets.dart';

import '../../foundation/haptics.dart';
import '../../foundation/spring.dart';
import '../../tokens/metrics.dart';
import 'slider_parts.dart';
import 'slider_track.dart';

/// BoardUI's slider with iOS 26 feel: a sunken track filled with the brand
/// gradient and a white thumb that swells under the finger. With
/// [divisions] it ticks a haptic per step crossed and, on release, springs
/// to the nearest step carrying the finger's speed.
class LqSlider extends StatefulWidget {
  const LqSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.showValueLabel = false,
    this.format,
    this.semanticLabel,
  }) : assert(min < max);

  /// The current value, between [min] and [max].
  final double value;

  /// Called as the value changes; null disables the slider.
  final ValueChanged<double>? onChanged;

  /// Called once when the finger lifts or a tap lands.
  final ValueChanged<double>? onChangeEnd;

  /// Value at the left end.
  final double min;

  /// Value at the right end.
  final double max;

  /// Number of equal steps, e.g. 20 for 0–100 in 5s; null is continuous.
  final int? divisions;

  /// Floats a glass bubble with the value above the thumb while dragging.
  final bool showValueLabel;

  /// Text for the value in the bubble and for screen readers, e.g. "65%".
  final String Function(double value)? format;

  /// What the slider sets, read by screen readers, e.g. "Business use".
  final String? semanticLabel;

  @override
  State<LqSlider> createState() => _LqSliderState();
}

class _LqSliderState extends State<LqSlider> with TickerProviderStateMixin {
  late final _pos = AnimationController.unbounded(
    vsync: this,
    value: SliderScale(widget.min, widget.max, widget.divisions).fractionOf(widget.value),
  );
  late final _swell = AnimationController.unbounded(vsync: this);
  late double _target = _pos.value;
  double _track = 1, _drag = 0;
  bool _dragging = false;
  int? _lastStep;

  SliderScale get _s => SliderScale(widget.min, widget.max, widget.divisions);
  double _fractionOf(double v) => _s.fractionOf(v);
  double _snap(double f) => _s.snap(f);
  double _valueAt(double f) => _s.valueAt(f);
  String _text(double v) => widget.format?.call(v) ?? _s.label(v);

  @override
  void didUpdateWidget(LqSlider old) {
    super.didUpdateWidget(old);
    final f = _fractionOf(widget.value);
    if (!_dragging && (f - _snap(_target)).abs() > 1e-6) _settle(f);
  }

  void _settle(double f, {double velocity = 0}) {
    _target = f;
    LqSpring.animate(_pos, f, velocity: velocity, context: context);
  }

  void _emit(double f) {
    if (widget.divisions != null) {
      final step = _s.stepAt(f);
      if (_lastStep != null && step != _lastStep) LqHaptics.play(LqHaptic.selection);
      _lastStep = step;
    }
    final v = _valueAt(f);
    if (v != widget.value) widget.onChanged?.call(v);
  }

  double _fractionAt(double dx) => (dx - kSliderThumbRadius) / _track;

  void _start(DragStartDetails d) {
    _pos.stop();
    final touch = _fractionAt(d.localPosition.dx);
    // Grabbing the thumb keeps it under the finger; elsewhere it jumps there.
    if ((touch - _pos.value).abs() * _track > kSliderThumbRadius * 1.5) {
      _pos.value = touch.clamp(0.0, 1.0);
    }
    _drag = _pos.value;
    _lastStep = _s.stepAt(_drag);
    setState(() => _dragging = true);
    LqSpring.animate(_swell, 1, context: context);
    _emit(_drag);
  }

  void _update(DragUpdateDetails d) {
    _drag += d.delta.dx / _track;
    _pos.value = _drag.clamp(0.0, 1.0);
    _emit(_pos.value);
  }

  void _end(DragEndDetails d) {
    setState(() => _dragging = false);
    LqSpring.animate(_swell, 0, context: context);
    final f = widget.divisions == null ? _pos.value : _snap(_pos.value);
    _settle(f, velocity: d.velocity.pixelsPerSecond.dx / _track);
    _emit(f);
    widget.onChangeEnd?.call(_valueAt(f));
  }

  void _tap(TapUpDetails d) {
    final f = _snap(_fractionAt(d.localPosition.dx));
    _lastStep ??= _s.stepAt(_pos.value);
    _settle(f);
    _emit(f);
    widget.onChangeEnd?.call(_valueAt(f));
  }

  void _nudge(int dir) {
    final n = widget.divisions ?? 20;
    final f = _snap((_fractionOf(widget.value) + dir / n).clamp(0.0, 1.0));
    _settle(f);
    _emit(f);
    widget.onChangeEnd?.call(_valueAt(f));
  }

  @override
  void dispose() {
    _pos.dispose();
    _swell.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onChanged != null;
    final n = widget.divisions ?? 20;
    final range = widget.max - widget.min;
    final up = (widget.value + range / n).clamp(widget.min, widget.max);
    final down = (widget.value - range / n).clamp(widget.min, widget.max);
    return Semantics(
      slider: true,
      enabled: enabled,
      label: widget.semanticLabel,
      value: _text(widget.value),
      increasedValue: _text(up),
      decreasedValue: _text(down),
      onIncrease: enabled ? () => _nudge(1) : null,
      onDecrease: enabled ? () => _nudge(-1) : null,
      child: SizedBox(
        height: LqSize.control,
        child: LayoutBuilder(
          builder: (context, box) {
            _track = (box.maxWidth - kSliderThumbRadius * 2).clamp(1.0, double.infinity);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: enabled ? _start : null,
              onHorizontalDragUpdate: enabled ? _update : null,
              onHorizontalDragEnd: enabled ? _end : null,
              onTapUp: enabled ? _tap : null,
              child: SliderTrack(
                position: _pos,
                swell: _swell,
                width: box.maxWidth,
                divisions: widget.divisions,
                enabled: enabled,
                label: _text(widget.value),
                showLabel: widget.showValueLabel,
                dragging: _dragging,
              ),
            );
          },
        ),
      ),
    );
  }
}

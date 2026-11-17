import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// One choice in a [LqSegmentedControl].
class LqSegment<T> {
  const LqSegment({required this.value, required this.label});

  final T value;
  final String label;
}

/// BoardUI's segmented control: a sunken track and a raised thumb that
/// slides between equal segments on a spring. Tap a segment, or press and
/// drag the thumb across; it pinches in slightly while held, as on iOS.
class LqSegmentedControl<T> extends StatefulWidget {
  const LqSegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  final List<LqSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  State<LqSegmentedControl<T>> createState() => _LqSegmentedControlState<T>();
}

class _LqSegmentedControlState<T> extends State<LqSegmentedControl<T>> {
  bool _held = false;
  double _w = 1;

  void _select(int i) {
    final v = widget.segments[i].value;
    if (v == widget.value) return;
    HapticFeedback.selectionClick();
    widget.onChanged(v);
  }

  void _selectAt(double dx) =>
      _select((dx / _w).floor().clamp(0, widget.segments.length - 1));

  void _hold(bool held) {
    if (held != _held) setState(() => _held = held);
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final index = widget.segments.indexWhere((s) => s.value == widget.value);
    const pad = 3.0;

    return Container(
      height: LqSize.controlSmall,
      padding: const EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: c.segmentedTrack,
        borderRadius: BorderRadius.circular(lq.radius.md),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          _w = box.maxWidth / widget.segments.length;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _hold(true),
            onTapUp: (d) {
              _hold(false);
              _selectAt(d.localPosition.dx);
            },
            onTapCancel: () => _hold(false),
            onHorizontalDragStart: (_) => _hold(true),
            onHorizontalDragUpdate: (d) => _selectAt(d.localPosition.dx),
            onHorizontalDragEnd: (_) => _hold(false),
            onHorizontalDragCancel: () => _hold(false),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: LqMotion.of(context, LqMotion.slow),
                  curve: LqMotion.springCurve,
                  left: _w * (index < 0 ? 0 : index),
                  top: 0,
                  bottom: 0,
                  width: _w,
                  child: AnimatedScale(
                    scale: _held && !LqMotion.reduced(context) ? 0.95 : 1,
                    duration: LqMotion.of(context, LqMotion.standard),
                    curve: LqMotion.springCurve,
                    child: Container(
                      decoration: BoxDecoration(
                        color: c.segmentedThumb,
                        borderRadius: BorderRadius.circular(lq.radius.md - pad),
                        boxShadow: LqShadows.sm(c.shadow),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < widget.segments.length; i++)
                      Expanded(child: _label(context, i, i == index)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _label(BuildContext context, int i, bool selected) {
    final lq = context.lq;
    final c = lq.colors;
    return Semantics(
      button: true,
      selected: selected,
      onTap: () => _select(i),
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: LqMotion.fast,
          style: lq.type.subheadMedium.copyWith(
            color: selected ? c.textPrimary : c.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
          child: Text(
            widget.segments[i].label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

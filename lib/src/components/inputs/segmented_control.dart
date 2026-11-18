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
/// slides between segments on a spring. Segments are equal while every label
/// fits; when one does not ("Upcoming Service"), widths follow the labels, as
/// iOS's apportionsSegmentWidthsByContent, and a label that still cannot fit
/// shrinks a little instead of being cut. Tap a segment, or press and drag
/// the thumb across; it pinches in slightly while held, as on iOS.
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
  List<double> _widths = const [1];

  static const double _labelPad = 12;

  void _select(int i) {
    final v = widget.segments[i].value;
    if (v == widget.value) return;
    HapticFeedback.selectionClick();
    widget.onChanged(v);
  }

  void _selectAt(double dx) {
    var edge = 0.0;
    for (var i = 0; i < _widths.length; i++) {
      edge += _widths[i];
      if (dx < edge) return _select(i);
    }
    _select(_widths.length - 1);
  }

  /// Equal widths while every label fits; otherwise each label gets its own
  /// width and the spare room is shared (or, when even that overflows, the
  /// widths are scaled to the label sizes).
  List<double> _layout(BuildContext context, double total) {
    final n = widget.segments.length;
    final style = context.lq.type.subheadMedium.copyWith(fontWeight: FontWeight.w600);
    final scaler = MediaQuery.textScalerOf(context);
    final need = [
      for (final s in widget.segments)
        (TextPainter(
              text: TextSpan(text: s.label, style: style),
              textDirection: TextDirection.ltr,
              textScaler: scaler,
              maxLines: 1,
            )..layout())
            .width +
            _labelPad * 2,
    ];
    final equal = total / n;
    if (need.every((w) => w <= equal)) return List.filled(n, equal);
    final sum = need.fold<double>(0, (a, b) => a + b);
    if (sum <= total) {
      final spare = (total - sum) / n;
      return [for (final w in need) w + spare];
    }
    return [for (final w in need) w * total / sum];
  }

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
          final widths = _widths = _layout(context, box.maxWidth);
          final at = index < 0 ? 0 : index;
          final left = widths.take(at).fold<double>(0, (a, b) => a + b);
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
                  left: left,
                  top: 0,
                  bottom: 0,
                  width: widths[at],
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
                      SizedBox(width: widths[i], child: _label(context, i, i == index)),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _labelPad / 2),
          // Shrinks a label that cannot fit rather than cutting it off.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedDefaultTextStyle(
              duration: LqMotion.fast,
              style: lq.type.subheadMedium.copyWith(
                color: selected ? c.textPrimary : c.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(widget.segments[i].label, maxLines: 1),
            ),
          ),
        ),
      ),
    );
  }
}

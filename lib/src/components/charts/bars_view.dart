import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';
import '../../tokens/typography.dart';
import '../feedback/badge.dart';
import 'bars_painter.dart';
import 'chart_legend.dart';
import 'chart_parts.dart';
import 'chart_pill.dart';
import 'chart_scale.dart';

/// The engine behind [LqBarChart] and [LqStackedBarChart]: grows bars in on
/// first view, morphs them to new data, and lets a finger pick a bar.
class BarsView extends StatefulWidget {
  const BarsView({
    super.key,
    required this.series,
    required this.labels,
    required this.height,
    required this.valueLabel,
    this.stacked = true,
    this.highlighted,
    this.onSelected,
    this.semanticLabel,
  });

  final List<LqChartSeries> series;
  final List<String> labels;
  final double height;
  final String Function(double value) valueLabel;
  final bool stacked;
  final int? highlighted;
  final ValueChanged<int?>? onSelected;
  final String? semanticLabel;

  @override
  State<BarsView> createState() => _BarsViewState();
}

class _BarsViewState extends State<BarsView> {
  int? _picked;

  int get _count => widget.labels.length;

  /// A bar's whole height: the stack's sum.
  double _total(int i) => widget.series.fold(
    0.0,
    (sum, s) => sum + (i < s.values.length ? s.values[i] : 0),
  );

  double _at(int s, int i) {
    final v = widget.series[s].values;
    return i < v.length ? v[i] : 0;
  }

  double _peak(int i) => widget.series.fold(
    0.0,
    (m, s) => math.max(m, i < s.values.length ? s.values[i] : 0),
  );

  @override
  void didUpdateWidget(BarsView old) {
    super.didUpdateWidget(old);
    if (_picked != null && _picked! >= _count) _picked = null;
  }

  void _pick(int? i) {
    setState(() => _picked = i);
    widget.onSelected?.call(i);
  }

  String _summary() {
    final parts = <String>[];
    var best = 0;
    for (var i = 0; i < _count; i++) {
      parts.add('${widget.labels[i]} ${widget.valueLabel(_total(i))}');
      if (_total(i) > _total(best)) best = i;
    }
    if (_count > 0) parts.add('Highest ${widget.labels[best]}');
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final scaler = MediaQuery.textScalerOf(context);
    final caption = LqTypography.numeric(lq.type.caption);
    final multi = widget.series.length > 1;
    final tones = [for (final s in widget.series) ChartScale.tone(c, s.tone)];
    // The brand bar gets the CTA's top color, as the style rules ask.
    if (!multi && widget.series[0].tone == LqTone.accent) tones[0] = c.accentTop;
    var top = 0.0;
    for (var i = 0; i < _count; i++) {
      top = math.max(top, widget.stacked ? _total(i) : _peak(i));
    }
    final frame = ChartFrame([for (final s in widget.series) s.values], ChartScale.niceMax(top));

    return LayoutBuilder(builder: (context, box) {
      final size = Size(box.maxWidth, widget.height);
      final layout = BarLayout(
        size,
        _count,
        top: scaler.scale(multi ? 48 : 32),
        labels: ChartPaint.lineHeight(caption, scaler) + 8,
        groups: widget.stacked ? 1 : widget.series.length,
      );
      final picked = _picked;
      return Semantics(
        container: true,
        label: widget.semanticLabel,
        value: _summary(),
        child: ChartPicker(
          indexAt: layout.indexAt,
          picked: picked,
          onPick: _pick,
          child: SizedBox.fromSize(
            size: size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ChartEntrance(
                  duration: ChartScale.entrance(_count),
                  builder: (context, t) => ChartMorph(
                    frame: frame,
                    builder: (context, f) => TweenAnimationBuilder<double>(
                      tween: Tween(end: picked == null ? 0 : 1),
                      duration: LqMotion.of(context, LqMotion.fast),
                      builder: (context, dim, _) => CustomPaint(
                        size: size,
                        painter: BarsPainter(
                          layout: layout,
                          frame: f,
                          entrance: t,
                          dim: dim,
                          colors: c,
                          tones: tones,
                          labels: widget.labels,
                          labelStyle: caption,
                          scaler: scaler,
                          stacked: widget.stacked,
                          picked: picked,
                          highlighted: widget.highlighted,
                        ),
                      ),
                    ),
                  ),
                ),
                if (picked != null)
                  Positioned.fill(
                    child: ChartPillSlot(
                      x: layout.center(picked),
                      bottom: layout.plot.top - 6,
                      child: LqChartPill(
                        title: widget.labels[picked],
                        value: widget.valueLabel(
                          widget.stacked ? _total(picked) : _at(0, picked),
                        ),
                        entries: [
                          if (multi)
                            for (var s = 0; s < widget.series.length; s++)
                              LqLegendEntry(
                                label: widget.series[s].label,
                                color: tones[s],
                                value: widget.valueLabel(_at(s, picked)),
                              ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

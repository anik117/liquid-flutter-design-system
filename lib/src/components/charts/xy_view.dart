import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';
import '../../tokens/typography.dart';
import 'chart_legend.dart';
import 'chart_parts.dart';
import 'chart_pill.dart';
import 'chart_scale.dart';
import 'xy_painter.dart';

/// The engine behind [LqLineChart], [LqAreaChart] and [LqMultiLineChart]:
/// lines draw in on first view, morph between datasets, and a finger
/// scrubs across to show a guide, dots and a value pill.
class XYView extends StatefulWidget {
  const XYView({
    super.key,
    required this.series,
    required this.labels,
    required this.height,
    required this.valueLabel,
    required this.fills,
    this.stacked = false,
    this.onSelected,
    this.semanticLabel,
  });

  final List<LqChartSeries> series;
  final List<String> labels;
  final double height;
  final String Function(double value) valueLabel;

  /// Which series get a soft area fill.
  final List<bool> fills;
  final bool stacked;
  final ValueChanged<int?>? onSelected;
  final String? semanticLabel;

  @override
  State<XYView> createState() => _XYViewState();
}

class _XYViewState extends State<XYView> {
  int? _picked;

  void _pick(int? i) {
    setState(() => _picked = i);
    widget.onSelected?.call(i);
  }

  double _at(int s, int i) {
    final v = widget.series[s].values;
    return i < v.length ? v[i] : 0;
  }

  double _sum(int i) =>
      [for (var s = 0; s < widget.series.length; s++) _at(s, i)].fold(0.0, (a, b) => a + b);

  String _summary() {
    final out = <String>[];
    for (final s in widget.series) {
      if (s.values.isEmpty || s.values.length > widget.labels.length) continue;
      final last = s.values.length - 1;
      final peak = s.values.reduce(math.max);
      out.add('${s.label}: ${widget.labels[last]} ${widget.valueLabel(s.values[last])}, '
          'peak ${widget.labels[s.values.indexOf(peak)]} ${widget.valueLabel(peak)}');
    }
    return out.join('. ');
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final scaler = MediaQuery.textScalerOf(context);
    final caption = LqTypography.numeric(lq.type.caption);
    final series = widget.series;
    final multi = series.length > 1;
    final tones = [for (final s in series) ChartScale.tone(c, s.tone)];
    var top = 0.0;
    var limit = 0;
    for (var i = 0; i < widget.labels.length; i++) {
      for (var s = 0; s < series.length; s++) {
        top = math.max(top, widget.stacked ? _sum(i) : _at(s, i));
      }
    }
    // Scrubbing follows the primary series; others show alongside it.
    if (series.isNotEmpty) limit = math.min(series.first.values.length, widget.labels.length);
    final frame = ChartFrame([for (final s in series) s.values], ChartScale.niceMax(top));

    return LayoutBuilder(builder: (context, box) {
      final size = Size(box.maxWidth, widget.height);
      final layout = XYLayout(
        size,
        widget.labels.length,
        top: scaler.scale(multi ? 48 : 32),
        labels: ChartPaint.lineHeight(caption, scaler) + 8,
      );
      final picked = _picked != null && _picked! < limit ? _picked : null;
      return Semantics(
        container: true,
        label: widget.semanticLabel,
        value: _summary(),
        child: ChartPicker(
          indexAt: (p) => layout.indexAt(p, limit),
          picked: picked,
          onPick: _pick,
          clearOnRelease: true,
          child: SizedBox.fromSize(
            size: size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ChartEntrance(
                  duration: LqMotion.slow * 2,
                  builder: (context, t) => ChartMorph(
                    frame: frame,
                    builder: (context, f) => CustomPaint(
                      size: size,
                      painter: XYPainter(
                        layout: layout,
                        frame: f,
                        progress: LqMotion.emphasized.transform(t),
                        colors: c,
                        tones: tones,
                        dashed: [for (final s in series) s.dashed],
                        fills: widget.fills,
                        labels: widget.labels,
                        labelStyle: caption,
                        scaler: scaler,
                        stacked: widget.stacked,
                        picked: picked,
                      ),
                    ),
                  ),
                ),
                if (picked != null)
                  Positioned.fill(
                    child: ChartPillSlot(
                      x: layout.x(picked),
                      bottom: layout.plot.top - 8,
                      child: LqChartPill(
                        title: widget.labels[picked],
                        value: widget.valueLabel(widget.stacked ? _sum(picked) : _at(0, picked)),
                        entries: [
                          if (multi)
                            for (var s = 0; s < series.length; s++)
                              if (picked < series[s].values.length)
                                LqLegendEntry(
                                  label: series[s].label,
                                  color: tones[s],
                                  dashed: series[s].dashed,
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

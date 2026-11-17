import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/widgets.dart';

import '../../tokens/colors.dart';
import '../../tokens/motion.dart';
import '../data/amount.dart';
import '../feedback/badge.dart';

/// One named series of values for multi-series charts, e.g. "Business"
/// miles per month. [tone] picks its color from the theme.
class LqChartSeries {
  const LqChartSeries({
    required this.label,
    required this.values,
    this.tone = LqTone.accent,
    this.dashed = false,
  });

  /// Shown in legends and value pills, e.g. "2026".
  final String label;

  /// One value per x position (month, day, platform).
  final List<double> values;

  /// Color role of the series.
  final LqTone tone;

  /// Draws the line dashed, e.g. a comparison year.
  final bool dashed;
}

/// Shared math for every chart: nice axis maxima, tones, number labels and
/// the per-item stagger used when charts first appear.
abstract final class ChartScale {
  /// Rounds [v] up to a "nice" axis maximum (1, 2, 2.5, 5 × 10ⁿ), so bars
  /// keep headroom and the scale doesn't jitter with every value.
  static double niceMax(double v) {
    if (v <= 0 || !v.isFinite) return 1;
    final exp = math.pow(10, (math.log(v) / math.ln10).floor()).toDouble();
    for (final step in const [1.0, 1.2, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0]) {
      if (step * exp >= v) return step * exp;
    }
    return 10 * exp;
  }

  /// "12,345" style label with grouped thousands.
  static String number(double v, {int decimals = 0}) {
    final (whole, fraction) = LqAmount.split(v, decimals);
    return '$whole$fraction';
  }

  /// The mark color for a tone. Neutral is a mid grey that reads on white
  /// and on the dark surface.
  static Color tone(LqColors c, LqTone tone) => switch (tone) {
    LqTone.accent => c.accent,
    LqTone.neutral => Color.lerp(c.border, c.borderStrong, 0.7)!,
    LqTone.positive => c.positive,
    LqTone.caution => c.caution,
    LqTone.danger => c.textDanger,
    LqTone.info => c.info,
  };

  /// The grey a mark steps back to while another one is picked. Opaque on
  /// purpose: marks never turn see-through.
  static Color stepBack(LqColors c) => Color.lerp(c.border, c.borderStrong, 0.35)!;

  /// Lerps two value lists. Missing "from" values start at the target, so a
  /// longer dataset grows new points in place.
  static List<double> lerpList(List<double> a, List<double> b, double t) => [
    for (var i = 0; i < b.length; i++)
      i < a.length ? a[i] + (b[i] - a[i]) * t : b[i],
  ];

  /// Whether axis label [i] shows: every [step]th label, plus the strong
  /// (picked or current) ones, whose crowding neighbours give way.
  static bool showLabel(int i, int step, List<int?> strong) {
    if (strong.contains(i)) return true;
    if (i % step != 0) return false;
    return !strong.any((s) => s != null && (i - s).abs() < step);
  }

  /// Time between neighbouring bars as they grow in.
  static const staggerStep = Duration(milliseconds: 20);

  /// Total entrance time for [count] staggered items.
  static Duration entrance(int count, {Duration item = LqMotion.slow}) =>
      item + staggerStep * math.max(0, count - 1);

  /// Progress (0…1, springy) of item [i] of [count] when the whole entrance
  /// is at [t] (0…1).
  static double stagger(double t, int i, int count,
      {Duration item = LqMotion.slow, Curve curve = LqMotion.springCurve}) {
    if (t >= 1) return 1;
    final total = entrance(count, item: item).inMicroseconds;
    final start = (staggerStep * i).inMicroseconds / total;
    final span = item.inMicroseconds / total;
    return curve.transform(((t - start) / span).clamp(0.0, 1.0));
  }
}

/// What a chart draws at one instant: its series and the axis maximum.
/// Charts tween from one frame to the next, so new data morphs in.
@immutable
class ChartFrame {
  const ChartFrame(this.series, this.max);

  final List<List<double>> series;
  final double max;

  ChartFrame lerp(ChartFrame to, double t) => ChartFrame([
    for (var s = 0; s < to.series.length; s++)
      ChartScale.lerpList(s < series.length ? series[s] : to.series[s], to.series[s], t),
  ], max + (to.max - max) * t);

  @override
  bool operator ==(Object other) {
    if (other is! ChartFrame || other.max != max) return false;
    if (other.series.length != series.length) return false;
    for (var i = 0; i < series.length; i++) {
      if (!listEquals(series[i], other.series[i])) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(max, Object.hashAll(series.map(Object.hashAll)));
}

/// Tweens [ChartFrame]s for implicit morphing.
class ChartFrameTween extends Tween<ChartFrame> {
  ChartFrameTween({super.begin, super.end});

  @override
  ChartFrame lerp(double t) => begin!.lerp(end!, t);
}

/// Plays a chart's first-view entrance once: [builder] gets 0 → 1. Under
/// Reduce Motion it starts at 1.
class ChartEntrance extends StatelessWidget {
  const ChartEntrance({super.key, required this.duration, required this.builder});

  /// Full entrance length, including any stagger.
  final Duration duration;

  /// Builds the chart for an entrance progress.
  final Widget Function(BuildContext context, double t) builder;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: LqMotion.reduced(context) ? 1 : 0, end: 1),
    duration: LqMotion.of(context, duration),
    builder: (context, t, _) => builder(context, t),
  );
}

/// Morphs to a new [frame] whenever the data changes.
class ChartMorph extends StatelessWidget {
  const ChartMorph({super.key, required this.frame, required this.builder});

  /// The target data.
  final ChartFrame frame;

  /// Builds the chart for the in-between frame.
  final Widget Function(BuildContext context, ChartFrame frame) builder;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<ChartFrame>(
    tween: ChartFrameTween(begin: frame, end: frame),
    duration: LqMotion.of(context, LqMotion.slow),
    curve: LqMotion.emphasized,
    builder: (context, f, _) => builder(context, f),
  );
}

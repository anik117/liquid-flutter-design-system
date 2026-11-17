import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';
import '../../tokens/typography.dart';
import '../data/amount.dart';

/// A semicircle gauge of progress toward a target, e.g. quarterly tax
/// set aside: $1,240 of $1,800. The arc and its knob swing to the value on
/// a spring. Past [cautionAbove] the arc turns the caution color.
class LqGaugeChart extends StatelessWidget {
  const LqGaugeChart({
    super.key,
    required this.value,
    required this.target,
    this.prefix,
    this.unit,
    this.decimals = 0,
    this.caption,
    this.cautionAbove,
    this.size = 240,
    this.thickness = 16,
    this.semanticLabel,
  });

  /// Progress so far.
  final double value;

  /// The goal; a full arc.
  final double target;

  /// Currency sign or unit for the center number, e.g. "$" or "mi".
  final String? prefix, unit;

  /// Decimals for the center number.
  final int decimals;

  /// One quiet line under the number, e.g. "of $1,800 for Q4".
  final String? caption;

  /// Value past which the arc warns, e.g. a spending cap.
  final double? cautionAbove;

  /// Gauge width and arc stroke.
  final double size, thickness;

  /// What the gauge measures, e.g. "Q4 tax set aside".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final fraction = target <= 0 ? 0.0 : (value / target).clamp(0.0, 1.0);
    final warn = cautionAbove != null && value > cautionAbove!;
    final (whole, frac) = LqAmount.split(value, decimals);
    final pct = (fraction * 100).round();

    return Semantics(
      container: true,
      label: semanticLabel,
      value: '${prefix ?? ''}$whole$frac${unit == null ? '' : ' $unit'}, $pct percent of target',
      child: ExcludeSemantics(
        child: SizedBox(
          width: size,
          height: size / 2 + thickness,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: LqMotion.reduced(context) ? fraction : 0, end: fraction),
                duration: LqMotion.of(context, LqMotion.slow * 2),
                curve: LqMotion.springCurve,
                builder: (context, f, _) => CustomPaint(
                  size: Size(size, size / 2 + thickness),
                  painter: _GaugePainter(
                    fraction: f,
                    thickness: thickness,
                    color: warn ? c.caution : c.accent,
                    track: c.surfaceSunken,
                    knob: c.surface,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(thickness * 2, 0, thickness * 2, thickness / 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LqAmount(value: value, prefix: prefix, unit: unit, decimals: decimals,
                        style: lq.type.title1),
                    if (caption != null)
                      Text(caption!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: LqTypography.numeric(lq.type.footnote)
                              .copyWith(color: c.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.fraction,
    required this.thickness,
    required this.color,
    required this.track,
    required this.knob,
  });

  final double fraction, thickness;
  final Color color, track, knob;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2 - thickness / 2;
    final center = Offset(size.width / 2, size.height - thickness / 2);
    final rect = Rect.fromCircle(center: center, radius: r);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi, math.pi, false, stroke..color = track);
    // The spring may overshoot a little; keep the arc on the track.
    final f = fraction.clamp(0.0, 1.0);
    if (f > 0) {
      canvas.drawArc(rect, math.pi, math.pi * f, false, stroke..color = color);
    }
    final a = math.pi + math.pi * f;
    final tip = center + Offset(math.cos(a), math.sin(a)) * r;
    canvas.drawCircle(tip, thickness / 2 + 1, Paint()..color = knob);
    canvas.drawCircle(tip, thickness / 2 - 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.fraction != fraction || old.color != color || old.track != track;
}

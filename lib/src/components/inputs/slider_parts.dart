import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/colors.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// Thumb radius at rest; the track is inset by it so the thumb never
/// hangs off either end.
const double kSliderThumbRadius = 14;
const double _trackHeight = 6;

/// Maps an [LqSlider]'s values to thumb positions (0…1) and back, snapping
/// to divisions.
class SliderScale {
  const SliderScale(this.min, this.max, this.divisions);

  /// Value at each end.
  final double min, max;

  /// Number of steps, or null for continuous.
  final int? divisions;

  /// Thumb position for [v].
  double fractionOf(double v) => ((v - min) / (max - min)).clamp(0.0, 1.0);

  /// [f] clamped and moved to the nearest division.
  double snap(double f) {
    final n = divisions, c = f.clamp(0.0, 1.0);
    return n == null || n <= 0 ? c : (c * n).round() / n;
  }

  /// Value at position [f], snapped.
  double valueAt(double f) => min + snap(f) * (max - min);

  /// Index of the division nearest [f].
  int stepAt(double f) => (snap(f) * (divisions ?? 0)).round();

  /// Default label: whole numbers when every step is whole, else 2 places.
  String label(double v) {
    final n = divisions;
    final whole = n != null && ((max - min) / n) % 1 == 0;
    return v.toStringAsFixed(whole ? 0 : 2);
  }
}

/// Draws an [LqSlider]: a sunken capsule track, the filled part in the
/// brand's top-lit gradient, optional division ticks, and a white thumb
/// with a soft shadow that swells while held.
class SliderPainter extends CustomPainter {
  const SliderPainter({
    required this.colors,
    required this.fraction,
    required this.swell,
    required this.divisions,
    required this.enabled,
  });

  /// Theme colors to draw with.
  final LqColors colors;

  /// Thumb position, 0 at the left end and 1 at the right.
  final double fraction;

  /// 0 at rest, 1 while dragged; the thumb scales up to 1.15.
  final double swell;

  /// Tick count, or null for a continuous slider.
  final int? divisions;

  /// False draws the fill grey.
  final bool enabled;

  @override
  void paint(Canvas canvas, Size size) {
    final c = colors;
    const r = kSliderThumbRadius;
    final cy = size.height / 2;
    final left = r, right = size.width - r;
    final x = left + (right - left) * fraction.clamp(0.0, 1.0);
    final track = RRect.fromLTRBR(
      left - _trackHeight / 2,
      cy - _trackHeight / 2,
      right + _trackHeight / 2,
      cy + _trackHeight / 2,
      const Radius.circular(_trackHeight / 2),
    );
    canvas.drawRRect(track, Paint()..color = c.segmentedTrack);

    final fillRect = Rect.fromLTRB(track.left, track.top, x, track.bottom);
    canvas.save();
    canvas.clipRRect(track);
    canvas.drawRect(
      fillRect,
      Paint()
        ..shader = (enabled
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [c.accentTop, c.accentBottom],
                  )
                : LinearGradient(colors: [c.disabledText, c.disabledText]))
            .createShader(fillRect),
    );
    canvas.restore();

    final n = divisions;
    if (n != null && n > 0 && n <= 40) {
      for (var i = 0; i <= n; i++) {
        final tx = left + (right - left) * i / n;
        final on = tx <= x;
        canvas.drawCircle(
          Offset(tx, cy),
          1.5,
          Paint()
            ..color = on
                ? c.textOnAccent.withValues(alpha: 0.7)
                : c.borderStrong,
        );
      }
    }

    final tr = r * (1 + 0.15 * swell);
    final center = Offset(x, cy);
    canvas.drawCircle(
      center.translate(0, 2),
      tr,
      Paint()
        ..color = c.shadow.withValues(alpha: c.shadow.a * (0.6 + 0.4 * swell))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 + 3 * swell),
    );
    canvas.drawCircle(center, tr, Paint()..color = c.knob);
    canvas.drawCircle(
      center,
      tr - 0.25,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = c.border,
    );
  }

  @override
  bool shouldRepaint(SliderPainter old) =>
      old.fraction != fraction ||
      old.swell != swell ||
      old.divisions != divisions ||
      old.enabled != enabled ||
      old.colors != colors;
}

/// The glass value bubble that floats above the thumb while dragging.
class SliderBubble extends StatelessWidget {
  const SliderBubble({super.key, required this.text, required this.visible});

  /// The value to show, e.g. "65%".
  final String text;

  /// Fades and scales the bubble in or out.
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: LqMotion.of(context, LqMotion.fast),
        child: AnimatedScale(
          scale: visible ? 1 : 0.6,
          alignment: Alignment.bottomCenter,
          duration: LqMotion.of(context, LqMotion.standard),
          curve: LqMotion.springCurve,
          child: LqGlass(
            padding: const EdgeInsets.symmetric(
              horizontal: LqSpace.x3,
              vertical: LqSpace.x1,
            ),
            child: Text(
              text,
              maxLines: 1,
              style: lq.type.footnoteMedium.copyWith(
                color: lq.colors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

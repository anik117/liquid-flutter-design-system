import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import 'slider_parts.dart';

/// The visible part of an [LqSlider]: the painted track and thumb, and the
/// value bubble that rides above the thumb while dragging.
class SliderTrack extends StatelessWidget {
  const SliderTrack({
    super.key,
    required this.position,
    required this.swell,
    required this.width,
    required this.divisions,
    required this.enabled,
    required this.label,
    required this.showLabel,
    required this.dragging,
  });

  /// Thumb position, 0…1 (a spring may briefly overshoot).
  final Animation<double> position;

  /// 0 at rest, 1 while held.
  final Animation<double> swell;

  /// Full width of the slider.
  final double width;

  /// Tick count, or null for continuous.
  final int? divisions;

  /// False draws the fill grey.
  final bool enabled;

  /// Text in the bubble.
  final String label;

  /// Whether the slider has a value bubble at all.
  final bool showLabel;

  /// Shows the bubble.
  final bool dragging;

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final track = (width - kSliderThumbRadius * 2).clamp(1.0, double.infinity);
    return AnimatedBuilder(
      animation: Listenable.merge([position, swell]),
      builder: (context, _) {
        final x = kSliderThumbRadius + track * position.value.clamp(0.0, 1.0);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(width, LqSize.control),
              painter: SliderPainter(
                colors: c,
                fraction: position.value,
                swell: swell.value,
                divisions: divisions,
                enabled: enabled,
              ),
            ),
            if (showLabel)
              Positioned(
                left: x - 60,
                width: 120,
                bottom: LqSize.control - 2,
                child: Center(child: SliderBubble(text: label, visible: dragging)),
              ),
          ],
        );
      },
    );
  }
}

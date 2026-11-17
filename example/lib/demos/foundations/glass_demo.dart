import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

/// Glass needs something behind it to show off: a busy map-like pattern in
/// the brand hue, with a glass capsule, glass buttons and a toolbar on top.
class GlassDemo extends StatelessWidget {
  const GlassDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(lq.radius.xl),
      child: SizedBox(
        height: 220,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _RoutesPainter(
                  ground: c.isDark ? const Color(0xFF16201C) : const Color(0xFFE6EFE9),
                  road: c.isDark ? const Color(0xFF2B3A34) : const Color(0xFFFFFFFF),
                  route: lq.brand.accent.s500,
                  block: c.isDark ? const Color(0xFF1D2925) : const Color(0xFFD3E3D9),
                ),
              ),
            ),
            Positioned(
              top: LqSpace.x3,
              left: LqSpace.x3,
              right: LqSpace.x3,
              child: Row(
                children: [
                  LqIconButton(icon: RemixIcons.arrow_left_s_line, semanticLabel: 'Back', onPressed: () {}),
                  const Spacer(),
                  LqIconButton(icon: RemixIcons.map_pin_line, semanticLabel: 'Add stop', onPressed: () {}),
                ],
              ),
            ),
            Positioned(
              left: LqSpace.x3,
              right: LqSpace.x3,
              bottom: LqSpace.x3,
              child: LqGlass(
                weight: LqGlassWeight.thick,
                radius: lq.radius.xl,
                padding: const EdgeInsets.all(LqSpace.x4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Driving · 12 min', style: lq.type.footnoteMedium.copyWith(color: c.textSecondary)),
                          LqAmount(value: 6.4, unit: 'mi', decimals: 1, style: lq.type.title1),
                        ],
                      ),
                    ),
                    LqButton(label: 'End', variant: LqButtonVariant.danger, onPressed: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutesPainter extends CustomPainter {
  _RoutesPainter({required this.ground, required this.road, required this.route, required this.block});

  final Color ground, road, route, block;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = ground);
    final blockPaint = Paint()..color = block;
    final rnd = math.Random(7);
    for (var i = 0; i < 26; i++) {
      final r = Rect.fromLTWH(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height,
          30 + rnd.nextDouble() * 60, 20 + rnd.nextDouble() * 40);
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(6)), blockPaint);
    }
    final roadPaint = Paint()
      ..color = road
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke;
    for (var x = -40.0; x < size.width; x += 70) {
      canvas.drawLine(Offset(x, 0), Offset(x + 60, size.height), roadPaint);
    }
    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.55), roadPaint);
    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.9)
      ..cubicTo(size.width * 0.3, size.height * 0.2, size.width * 0.6, size.height * 0.95,
          size.width * 0.88, size.height * 0.15);
    canvas.drawPath(path, Paint()
      ..color = route
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_RoutesPainter old) => old.route != route || old.ground != ground;
}

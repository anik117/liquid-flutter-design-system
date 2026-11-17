import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../foundation/haptics.dart';

/// Drawing helpers shared by every chart painter.
abstract final class ChartPaint {
  /// The one dashed baseline a chart is allowed.
  static void dashedLine(Canvas canvas, Offset a, Offset b, Color color,
      {double width = 1, double dash = 4, double gap = 4}) {
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy);
    canvas.drawPath(
      dashed(path, dash: dash, gap: gap),
      Paint()
        ..color = color
        ..strokeWidth = width
        ..style = PaintingStyle.stroke,
    );
  }

  /// [source] cut into dashes.
  static Path dashed(Path source, {double dash = 5, double gap = 4}) {
    final out = Path();
    for (final m in source.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        out.addPath(m.extractPath(d, math.min(d + dash, m.length)), Offset.zero);
        d += dash + gap;
      }
    }
    return out;
  }

  /// The first [t] (0…1) of [source], for lines that draw themselves in.
  static Path trim(Path source, double t) {
    if (t >= 1) return source;
    final out = Path();
    for (final m in source.computeMetrics()) {
      out.addPath(m.extractPath(0, m.length * t.clamp(0.0, 1.0)), Offset.zero);
    }
    return out;
  }

  /// A smooth line through [points] that never overshoots them: each span
  /// leaves and arrives flat, so peaks stay where the data is.
  static Path smooth(List<Offset> points, {Path? into, bool connect = false}) {
    final path = into ?? Path();
    if (points.isEmpty) return path;
    final p0 = points.first;
    connect ? path.lineTo(p0.dx, p0.dy) : path.moveTo(p0.dx, p0.dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1], b = points[i];
      final mx = (a.dx + b.dx) / 2;
      path.cubicTo(mx, a.dy, mx, b.dy, b.dx, b.dy);
    }
    return path;
  }

  /// Lays out [text] once; callers read its size and paint it.
  static TextPainter label(String text, TextStyle style, TextScaler scaler,
      {TextAlign align = TextAlign.center}) => TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: align,
    textDirection: ui.TextDirection.ltr,
    textScaler: scaler,
    maxLines: 1,
  )..layout();

  /// Paints [text] so that [anchor] sits at ([alignX], [alignY]) of its box:
  /// (0.5, 0) centers it under the anchor, (1, 0.5) ends it at the anchor.
  static Size text(Canvas canvas, String text, TextStyle style, TextScaler scaler,
      Offset anchor, {double alignX = 0.5, double alignY = 0}) {
    final tp = label(text, style, scaler);
    tp.paint(canvas, anchor - Offset(tp.width * alignX, tp.height * alignY));
    return tp.size;
  }

  /// Height of one caption line at the current text size.
  static double lineHeight(TextStyle style, TextScaler scaler) =>
      label('0', style, scaler).height;

  /// Every [step]th label so labels never collide: wide enough for the
  /// widest label plus a gap.
  static int labelStep(List<String> labels, TextStyle style, TextScaler scaler,
      double slot) {
    var widest = 0.0;
    for (final l in labels) {
      widest = math.max(widest, label(l, style, scaler).width);
    }
    return math.max(1, ((widest + 8) / math.max(slot, 1)).ceil());
  }
}

/// Picks a chart item by tap or by dragging across it. A selection haptic
/// plays only when the picked item changes, never on every frame.
class ChartPicker extends StatefulWidget {
  const ChartPicker({
    super.key,
    required this.indexAt,
    required this.picked,
    required this.onPick,
    required this.child,
    this.clearOnRelease = false,
  });

  /// Maps a local position to an item, or null for empty space.
  final int? Function(Offset local) indexAt;

  /// The item picked now.
  final int? picked;

  /// Called with the new pick, or null to clear.
  final ValueChanged<int?> onPick;

  /// Lines clear their guide when the finger lifts; bars keep the pick.
  final bool clearOnRelease;
  final Widget child;

  @override
  State<ChartPicker> createState() => _ChartPickerState();
}

class _ChartPickerState extends State<ChartPicker> {
  // The last pick sent, so several events within one frame stay in sync.
  late int? _last = widget.picked;

  @override
  void didUpdateWidget(ChartPicker old) {
    super.didUpdateWidget(old);
    _last = widget.picked;
  }

  void _go(int? i) {
    if (i == _last) return;
    _last = i;
    if (i != null) LqHaptics.play(LqHaptic.selection);
    widget.onPick(i);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTapUp: (d) {
      final i = widget.indexAt(d.localPosition);
      _go(i == _last ? null : i);
    },
    onHorizontalDragStart: (d) => _go(widget.indexAt(d.localPosition)),
    onHorizontalDragUpdate: (d) => _go(widget.indexAt(d.localPosition)),
    onHorizontalDragEnd: widget.clearOnRelease ? (_) => _go(null) : null,
    onHorizontalDragCancel: widget.clearOnRelease ? () => _go(null) : null,
    child: widget.child,
  );
}

/// Places a value pill centered on [x], with its bottom at [bottom], kept
/// inside the chart's width.
class ChartPillSlot extends StatelessWidget {
  const ChartPillSlot({super.key, required this.x, required this.bottom, required this.child});

  /// Horizontal center of the picked mark.
  final double x;

  /// Where the pill's bottom edge sits.
  final double bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomSingleChildLayout(
    delegate: _PillDelegate(x, bottom),
    child: child,
  );
}

class _PillDelegate extends SingleChildLayoutDelegate {
  _PillDelegate(this.x, this.bottom);

  final double x, bottom;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints c) => c.loosen();

  @override
  Offset getPositionForChild(Size size, Size child) {
    final left = (x - child.width / 2).clamp(0.0, math.max(0.0, size.width - child.width)).toDouble();
    return Offset(left, bottom - child.height);
  }

  @override
  bool shouldRelayout(_PillDelegate old) => old.x != x || old.bottom != bottom;
}

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'badge.dart';

/// A short confirmation on a glass capsule that rises from the bottom, near
/// the thumb, and leaves on its own: "Trip saved", "Report exported".
/// Swipe it down to dismiss early.
abstract final class LqToast {
  static OverlayEntry? _current;

  /// Space kept clear above the bottom safe area; the default clears a
  /// floating [LqTabBar]. Pass 0 on screens without one.
  static const double tabBarClearance = LqSize.tabBar + LqSpace.x3;

  static void show(
    BuildContext context,
    String message, {
    IconData? icon,
    LqTone tone = LqTone.positive,
    double clearance = tabBarClearance,
    Duration duration = const Duration(milliseconds: 2400),
  }) {
    _current?.remove();
    final lq = context.lq;
    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => LqScope(
        data: lq,
        child: _Toast(
          message: message,
          icon: icon,
          tone: tone,
          clearance: clearance,
          duration: duration,
          onDone: () {
            if (_current == entry) _current = null;
            if (entry.mounted) entry.remove();
          },
        ),
      ),
    );
    _current = entry;
    overlay.insert(entry);
    HapticFeedback.lightImpact();
  }
}

class _Toast extends StatefulWidget {
  const _Toast({
    required this.message,
    required this.tone,
    required this.clearance,
    required this.duration,
    required this.onDone,
    this.icon,
  });

  final String message;
  final IconData? icon;
  final LqTone tone;
  final double clearance;
  final Duration duration;
  final VoidCallback onDone;

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> {
  bool _shown = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = true);
    });
    _timer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() {
    _timer?.cancel();
    if (!mounted || !_shown) return;
    setState(() => _shown = false);
    Timer(LqMotion.slow, widget.onDone);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final (_, fg) = LqBadge.colorsFor(c, widget.tone);
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Positioned(
      bottom: bottom + widget.clearance + LqSpace.x2,
      left: LqSpace.x6,
      right: LqSpace.x6,
      child: GestureDetector(
        onVerticalDragUpdate: (d) {
          if (d.delta.dy > 2) _dismiss();
        },
        child: AnimatedSlide(
          offset: _shown ? Offset.zero : const Offset(0, 0.6),
          duration: LqMotion.of(context, LqMotion.slow),
          curve: _shown ? LqMotion.springCurve : LqMotion.emphasized,
          child: AnimatedOpacity(
            opacity: _shown ? 1 : 0,
            duration: LqMotion.of(context, LqMotion.standard),
            child: Center(
              child: LqGlass(
                weight: LqGlassWeight.thick,
                padding: const EdgeInsets.symmetric(
                  horizontal: LqSpace.x4,
                  vertical: LqSpace.x3,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18, color: fg),
                      const SizedBox(width: LqSpace.x2),
                    ],
                    Flexible(
                      child: Text(
                        widget.message,
                        style: lq.type.subheadMedium.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

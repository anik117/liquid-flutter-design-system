import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../tokens/metrics.dart';
import 'menu_items.dart';

/// Sizes of the menu panel's parts.
abstract final class LqMenuMetrics {
  static const double width = 250;
  static const double padding = LqSpace.x1 + 2;
  static const double divider = 9;

  static double itemHeight(TextScaler s) =>
      (s.scale(22) + 22).clamp(LqSize.control, double.infinity);
  static double headerHeight(TextScaler s) => s.scale(18) + 14;

  /// Height of the whole menu panel for [entries].
  static double heightOf<T>(List<LqMenuEntry<T>> entries, TextScaler s) {
    var h = padding * 2;
    for (final e in entries) {
      h += switch (e) {
        LqMenuItem<T>() => itemHeight(s),
        LqMenuHeader<T>() => headerHeight(s),
        LqMenuDivider<T>() => divider,
      };
    }
    return h;
  }
}

/// Where an open menu sits: its rect, and which corner it grows from.
class LqMenuPlacement {
  const LqMenuPlacement(this.rect, {required this.down, required this.right});

  /// Works out where a menu of [size] goes beside [anchor] on a [screen]
  /// with [pad] safe insets: below when it fits (or there is more room
  /// below), otherwise above; lined up with the anchor's nearer edge.
  factory LqMenuPlacement.beside(
    Rect anchor,
    Size size,
    Size screen,
    EdgeInsets pad,
  ) {
    const gap = LqSpace.x2, g = LqSpace.gutter;
    final w = math.min(size.width, screen.width - g * 2);
    final h = math.min(size.height, screen.height - pad.vertical - g * 2);
    final below = screen.height - pad.bottom - anchor.bottom - gap;
    final down = below >= h || below >= anchor.top - pad.top - gap;
    final right = anchor.center.dx > screen.width / 2;
    final left = (right ? anchor.right - w : anchor.left).clamp(
      g,
      math.max(g, screen.width - g - w),
    );
    final minTop = pad.top + g;
    final top = (down ? anchor.bottom + gap : anchor.top - gap - h).clamp(
      minTop,
      math.max(minTop, screen.height - pad.bottom - h - g),
    );
    return LqMenuPlacement(
      Rect.fromLTWH(left.toDouble(), top.toDouble(), w, h),
      down: down,
      right: right,
    );
  }

  /// The open menu's rect.
  final Rect rect;

  /// True when the menu opens below the anchor.
  final bool down;

  /// True when the menu lines up with the anchor's right edge.
  final bool right;
}

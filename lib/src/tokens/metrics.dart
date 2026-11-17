import 'dart:ui' show Color, Offset;

import 'package:flutter/painting.dart' show BoxShadow, BorderRadius, Radius;

/// 4-point spacing scale.
abstract final class LqSpace {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;
  static const double x12 = 48;
  static const double x16 = 64;

  /// Screen side margin (Apple HIG on phones).
  static const double gutter = 16;
}

/// Corner radii. A brand's `cornerScale` multiplies all but [full].
class LqRadius {
  const LqRadius([this.scale = 1]);

  final double scale;

  double get xs => 6 * scale; // badges, small chips
  double get sm => 8 * scale; // small buttons, checkboxes
  double get md => 10 * scale; // buttons, inputs (BoardUI rounded-2lg)
  double get lg => 14 * scale; // list groups, segmented controls
  double get xl => 20 * scale; // cards
  double get xxl => 28 * scale; // sheets
  static const double full = 999;

  BorderRadius all(double r) => BorderRadius.all(Radius.circular(r));
}

/// Control heights. 44pt is the minimum touch target.
abstract final class LqSize {
  static const double controlLarge = 52;
  static const double control = 44;
  static const double controlSmall = 36;
  static const double row = 52;
  static const double tabBar = 64;
  static const double iconTile = 32;
  static const double fab = 56;
}

/// Icon sizes: 24 in tab bars, 22 in bar buttons, 20 in buttons and fields,
/// 18 in row tiles, 16 and 14 inline with text.
abstract final class LqIconSize {
  static const double xs = 14;
  static const double sm = 16;
  static const double md = 18;
  static const double lg = 20;
  static const double xl = 22;
  static const double xxl = 24;
  static const double hero = 32;
}

/// Shadows from BoardUI's shadow scale. Dark mode passes a heavier color.
abstract final class LqShadows {
  /// 1px contact shadow under white cards on a grey page.
  static List<BoxShadow> card(Color c) => [
    BoxShadow(color: c.withValues(alpha: c.a * 0.2), offset: const Offset(0, 1), blurRadius: 1),
  ];

  /// Buttons and small raised controls (BoardUI shadow-xs).
  static List<BoxShadow> xs(Color c) => [
    BoxShadow(color: c.withValues(alpha: c.a * 0.6), offset: const Offset(0, 1), blurRadius: 2),
  ];

  /// Segmented thumb, switch knob.
  static List<BoxShadow> sm(Color c) => [
    BoxShadow(color: c.withValues(alpha: c.a * 0.4), offset: const Offset(0, 1), blurRadius: 2),
    BoxShadow(color: c.withValues(alpha: c.a * 0.5), offset: const Offset(0, 1), blurRadius: 3),
  ];

  /// Floating glass bars, menus and toasts.
  static List<BoxShadow> float(Color c) => [
    BoxShadow(color: c.withValues(alpha: c.a * 0.25), offset: const Offset(0, 1), blurRadius: 1),
    BoxShadow(color: c.withValues(alpha: c.a * 0.45), offset: const Offset(0, 8), blurRadius: 24),
  ];
}

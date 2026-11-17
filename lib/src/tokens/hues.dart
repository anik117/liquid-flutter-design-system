import 'dart:ui' show Color;

import 'colors.dart';

/// Decorative hues for icon tiles, categories and chart series, taken from
/// the Tailwind CSS palette (MIT). They tell things apart (a business drive
/// from a personal one, miles from drives); status still uses [LqTone].
///
/// Each hue keeps the four steps the system needs: 100 for light-mode
/// tints, 400 for dark-mode text, 500 for fills, 600 for light-mode text.
enum LqHue {
  emerald(
    Color(0xFFD1FAE5),
    Color(0xFF34D399),
    Color(0xFF10B981),
    Color(0xFF059669),
  ),
  teal(
    Color(0xFFCCFBF1),
    Color(0xFF2DD4BF),
    Color(0xFF14B8A6),
    Color(0xFF0D9488),
  ),
  sky(
    Color(0xFFE0F2FE),
    Color(0xFF38BDF8),
    Color(0xFF0EA5E9),
    Color(0xFF0284C7),
  ),
  blue(
    Color(0xFFDBEAFE),
    Color(0xFF60A5FA),
    Color(0xFF3B82F6),
    Color(0xFF2563EB),
  ),
  indigo(
    Color(0xFFE0E7FF),
    Color(0xFF818CF8),
    Color(0xFF6366F1),
    Color(0xFF4F46E5),
  ),
  violet(
    Color(0xFFEDE9FE),
    Color(0xFFA78BFA),
    Color(0xFF8B5CF6),
    Color(0xFF7C3AED),
  ),
  fuchsia(
    Color(0xFFFAE8FF),
    Color(0xFFE879F9),
    Color(0xFFD946EF),
    Color(0xFFC026D3),
  ),
  rose(
    Color(0xFFFFE4E6),
    Color(0xFFFB7185),
    Color(0xFFF43F5E),
    Color(0xFFE11D48),
  ),
  orange(
    Color(0xFFFFEDD5),
    Color(0xFFFB923C),
    Color(0xFFF97316),
    Color(0xFFEA580C),
  ),
  amber(
    Color(0xFFFEF3C7),
    Color(0xFFFBBF24),
    Color(0xFFF59E0B),
    Color(0xFFD97706),
  ),
  lime(
    Color(0xFFECFCCB),
    Color(0xFFA3E635),
    Color(0xFF84CC16),
    Color(0xFF65A30D),
  ),
  slate(
    Color(0xFFF1F5F9),
    Color(0xFF94A3B8),
    Color(0xFF64748B),
    Color(0xFF475569),
  );

  const LqHue(this.s100, this.s400, this.s500, this.s600);

  final Color s100, s400, s500, s600;

  /// Tint behind an icon or label.
  Color soft(LqColors c) => c.isDark ? s500.withValues(alpha: 0.18) : s100;

  /// Icon or text on [soft], and small marks on a surface.
  Color onSoft(LqColors c) => c.isDark ? s400 : s600;

  /// A solid fill (chart bar, dot, filled tile).
  Color solid(LqColors c) => s500;
}

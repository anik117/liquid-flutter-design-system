import 'dart:ui' show Color;

/// An 11-step color ramp (50, 100 … 900, 950), the shape BoardUI uses for
/// its accent and neutral scales.
class LqRamp {
  const LqRamp({
    required this.s50,
    required this.s100,
    required this.s200,
    required this.s300,
    required this.s400,
    required this.s500,
    required this.s600,
    required this.s700,
    required this.s800,
    required this.s900,
    required this.s950,
  });

  final Color s50, s100, s200, s300, s400, s500, s600, s700, s800, s900, s950;
}

/// Raw palette primitives. Components never read these directly; they go
/// through [LqColors], which maps them per brand and brightness.
abstract final class LqPalette {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  /// Achromatic neutrals (BoardUI keeps neutrals hue-free).
  static const neutral = LqRamp(
    s50: Color(0xFFFAFAFA),
    s100: Color(0xFFF5F5F5),
    s200: Color(0xFFEBEBEB),
    s300: Color(0xFFD9D9D9),
    s400: Color(0xFFA3A3A3),
    s500: Color(0xFF737373),
    s600: Color(0xFF525252),
    s700: Color(0xFF3D3D3D),
    s800: Color(0xFF262626),
    s900: Color(0xFF181818),
    s950: Color(0xFF0B0B0B),
  );

  /// Between neutral 900 and 950: the dark-mode page ground.
  static const neutral925 = Color(0xFF121212);

  static const red = LqRamp(
    s50: Color(0xFFFEF2F2),
    s100: Color(0xFFFEE2E2),
    s200: Color(0xFFFECACA),
    s300: Color(0xFFFCA5A5),
    s400: Color(0xFFF87171),
    s500: Color(0xFFEF4444),
    s600: Color(0xFFDC2626),
    s700: Color(0xFFB91C1C),
    s800: Color(0xFF991B1B),
    s900: Color(0xFF7F1D1D),
    s950: Color(0xFF450A0A),
  );

  static const amber = LqRamp(
    s50: Color(0xFFFFFBEB),
    s100: Color(0xFFFEF3C7),
    s200: Color(0xFFFDE68A),
    s300: Color(0xFFFCD34D),
    s400: Color(0xFFFBBF24),
    s500: Color(0xFFF59E0B),
    s600: Color(0xFFD97706),
    s700: Color(0xFFB45309),
    s800: Color(0xFF92400E),
    s900: Color(0xFF78350F),
    s950: Color(0xFF451A03),
  );

  static const blue = LqRamp(
    s50: Color(0xFFEFF6FF),
    s100: Color(0xFFDBEAFE),
    s200: Color(0xFFBFDBFE),
    s300: Color(0xFF93C5FD),
    s400: Color(0xFF3392FF),
    s500: Color(0xFF3B82F6),
    s600: Color(0xFF2563EB),
    s700: Color(0xFF1D4ED8),
    s800: Color(0xFF1E40AF),
    s900: Color(0xFF1E3A8A),
    s950: Color(0xFF172554),
  );
}

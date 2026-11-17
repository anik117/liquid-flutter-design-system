import 'dart:ui' show Color;

import 'palette.dart';

/// Everything an app changes to rebrand the design system.
///
/// A new app supplies one [LqBrand]: an accent ramp (buttons, selection,
/// focus, switches), optional font families and a corner style. Every
/// semantic color and component re-tints from it, in light and dark.
class LqBrand {
  const LqBrand({
    required this.name,
    required this.accent,
    this.fontFamily,
    this.displayFontFamily,
    this.cornerScale = 1.0,
  });

  final String name;

  /// The CTA hue, 50…950. 500→600 forms the primary button gradient.
  final LqRamp accent;

  /// Body and UI text. `null` keeps the platform system font
  /// (SF Pro on iOS, Roboto on Android), which reads most native.
  final String? fontFamily;

  /// Large titles and big numbers. Falls back to [fontFamily].
  final String? displayFontFamily;

  /// Multiplies every radius token: 0.75 is crisper, 1.25 is softer.
  final double cornerScale;

  /// VaultMileage: the vault green the app already ships.
  static const vaultMileage = LqBrand(
    name: 'VaultMileage',
    accent: LqRamp(
      s50: Color(0xFFEEF8F3),
      s100: Color(0xFFD6EFE3),
      s200: Color(0xFFAEDFC8),
      s300: Color(0xFF83D2B2),
      s400: Color(0xFF45AD86),
      s500: Color(0xFF1B8A64),
      s600: Color(0xFF0D684D),
      s700: Color(0xFF0B5640),
      s800: Color(0xFF094534),
      s900: Color(0xFF07382B),
      s950: Color(0xFF032019),
    ),
  );

  /// A second brand used only to prove that swapping a brand file re-themes
  /// every component. Not a real product.
  static const sampleIndigo = LqBrand(
    name: 'Sample (indigo)',
    accent: LqRamp(
      s50: Color(0xFFEEF2FF),
      s100: Color(0xFFE0E7FF),
      s200: Color(0xFFC7D2FE),
      s300: Color(0xFFA5B4FC),
      s400: Color(0xFF818CF8),
      s500: Color(0xFF6366F1),
      s600: Color(0xFF4F46E5),
      s700: Color(0xFF4338CA),
      s800: Color(0xFF3730A3),
      s900: Color(0xFF312E81),
      s950: Color(0xFF1E1B4B),
    ),
    cornerScale: 1.25,
  );
}

import 'dart:ui' show Brightness, Color;

import 'brand.dart';
import 'colors_resolve.dart';

/// Semantic color roles. Components read only these, so a brand or
/// brightness change re-themes everything at once.
class LqColors {
  const LqColors({
    required this.brightness,
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.surfacePressed,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textPlaceholder,
    required this.textOnAccent,
    required this.textAccent,
    required this.textDanger,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.border,
    required this.borderStrong,
    required this.separator,
    required this.focusRing,
    required this.accent,
    required this.accentTop,
    required this.accentBottom,
    required this.accentPressedTop,
    required this.accentPressedBottom,
    required this.accentSoft,
    required this.accentSoftPressed,
    required this.accentOnSoft,
    required this.dangerTop,
    required this.dangerBottom,
    required this.dangerSoft,
    required this.dangerOnSoft,
    required this.positive,
    required this.positiveSoft,
    required this.caution,
    required this.cautionSoft,
    required this.info,
    required this.infoSoft,
    required this.disabledFill,
    required this.disabledText,
    required this.switchOffTop,
    required this.switchOffBottom,
    required this.knob,
    required this.segmentedTrack,
    required this.segmentedThumb,
    required this.glassTint,
    required this.glassBubble,
    required this.glassBubbleHeld,
    required this.glassPressed,
    required this.glassTintStrong,
    required this.rimHighlight,
    required this.rimShade,
    required this.shadow,
    required this.scrim,
  });

  /// Builds every role from a brand for one brightness.
  factory LqColors.resolve(
    LqBrand brand,
    Brightness brightness, {
    bool highContrast = false,
  }) =>
      brightness == Brightness.dark
          ? resolveDark(brand, highContrast: highContrast)
          : resolveLight(brand, highContrast: highContrast);

  final Brightness brightness;

  // Surfaces: page ground, cards and rows, sheets and menus, wells, pressed.
  final Color canvas, surface, surfaceRaised, surfaceSunken, surfacePressed;

  // Text.
  final Color textPrimary, textSecondary, textTertiary, textPlaceholder;
  final Color textOnAccent, textAccent, textDanger;

  // Icons.
  final Color iconPrimary, iconSecondary, iconTertiary;

  // Lines.
  final Color border, borderStrong, separator, focusRing;

  // Accent (brand CTA). Top/bottom pairs are the BoardUI button gradient.
  final Color accent, accentTop, accentBottom;
  final Color accentPressedTop, accentPressedBottom;
  final Color accentSoft, accentSoftPressed, accentOnSoft;

  // Destructive.
  final Color dangerTop, dangerBottom, dangerSoft, dangerOnSoft;

  // Status. Positive shares the brand hue so money-in never fights the CTA.
  final Color positive, positiveSoft, caution, cautionSoft, info, infoSoft;

  // Disabled.
  final Color disabledFill, disabledText;

  // Controls.
  final Color switchOffTop, switchOffBottom, knob;
  final Color segmentedTrack, segmentedThumb;

  // Liquid Glass: body tint, rim light and shade.
  final Color glassTint, glassTintStrong, rimHighlight, rimShade;

  // Fills drawn on top of glass: the selected-tab bubble (resting and held)
  // and the pressed state of rows and buttons inside glass panels.
  final Color glassBubble, glassBubbleHeld, glassPressed;

  // Elevation and overlays.
  final Color shadow, scrim;

  bool get isDark => brightness == Brightness.dark;
}

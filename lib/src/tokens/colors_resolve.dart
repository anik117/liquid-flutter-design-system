import 'dart:ui' show Brightness, Color;

import 'brand.dart';
import 'colors.dart';
import 'palette.dart';

const _n = LqPalette.neutral;
const _red = LqPalette.red;
const _amber = LqPalette.amber;
const _blue = LqPalette.blue;

/// Light mode, mapped from BoardUI's `:root` semantic tokens.
LqColors resolveLight(LqBrand brand, {bool highContrast = false}) {
  final a = brand.accent;
  return LqColors(
    brightness: Brightness.light,
    // A cool grey (Tailwind gray-100) so white cards lift off the page.
    canvas: const Color(0xFFF3F4F6),
    surface: LqPalette.white,
    surfaceRaised: LqPalette.white,
    surfaceSunken: _n.s100,
    surfacePressed: _n.s200,
    textPrimary: _n.s950,
    // #6B6B6B: 4.6:1 on the gray-100 canvas, 5.3:1 on white (WCAG AA).
    textSecondary: highContrast ? _n.s700 : const Color(0xFF6B6B6B),
    textTertiary: highContrast ? _n.s600 : _n.s400,
    textPlaceholder: highContrast ? _n.s600 : _n.s400,
    textOnAccent: LqPalette.white,
    textAccent: a.s700,
    textDanger: _red.s600,
    iconPrimary: _n.s950,
    iconSecondary: highContrast ? _n.s700 : const Color(0xFF6B6B6B),
    iconTertiary: _n.s400,
    border: highContrast ? _n.s400 : _n.s200,
    borderStrong: highContrast ? _n.s600 : _n.s300,
    separator: highContrast ? _n.s300 : _n.s200,
    focusRing: a.s500,
    accent: a.s600,
    accentTop: a.s500,
    accentBottom: a.s600,
    accentPressedTop: a.s600,
    accentPressedBottom: a.s700,
    accentSoft: a.s100,
    accentSoftPressed: a.s200,
    accentOnSoft: a.s700,
    dangerTop: _red.s500,
    dangerBottom: _red.s600,
    dangerSoft: _red.s100,
    dangerOnSoft: _red.s700,
    positive: a.s600,
    positiveSoft: a.s100,
    caution: _amber.s700,
    cautionSoft: _amber.s100,
    info: _blue.s600,
    infoSoft: _blue.s100,
    disabledFill: _n.s200,
    disabledText: _n.s400,
    switchOffTop: LqPalette.white,
    switchOffBottom: _n.s100,
    knob: LqPalette.white,
    segmentedTrack: _n.s200,
    segmentedThumb: LqPalette.white,
    glassTint: const Color(0x73FFFFFF),
    glassBubble: const Color(0x12000000),
    glassBubbleHeld: const Color(0x1C000000),
    glassPressed: const Color(0x14000000),
    glassTintStrong: const Color(0xA6FFFFFF),
    rimHighlight: const Color(0xE6FFFFFF),
    rimShade: const Color(0x24000000),
    shadow: const Color(0x33101828),
    scrim: const Color(0x66000000),
  );
}

/// Dark mode, mapped from BoardUI's `.dark` overrides. Surfaces step up in
/// lightness instead of using shadows, and accents shift to lighter steps.
LqColors resolveDark(LqBrand brand, {bool highContrast = false}) {
  final a = brand.accent;
  return LqColors(
    brightness: Brightness.dark,
    canvas: LqPalette.neutral925,
    surface: _n.s900,
    surfaceRaised: _n.s800,
    surfaceSunken: _n.s800,
    surfacePressed: _n.s800,
    textPrimary: _n.s50,
    textSecondary: highContrast ? _n.s300 : _n.s400,
    textTertiary: highContrast ? _n.s400 : _n.s500,
    textPlaceholder: highContrast ? _n.s400 : _n.s500,
    textOnAccent: LqPalette.white,
    textAccent: a.s300,
    textDanger: _red.s400,
    iconPrimary: _n.s50,
    iconSecondary: highContrast ? _n.s300 : _n.s400,
    iconTertiary: _n.s500,
    border: highContrast ? _n.s500 : _n.s700,
    borderStrong: highContrast ? _n.s400 : _n.s500,
    separator: highContrast ? _n.s600 : _n.s800,
    focusRing: a.s400,
    accent: a.s400,
    accentTop: a.s500,
    accentBottom: a.s600,
    accentPressedTop: a.s600,
    accentPressedBottom: a.s700,
    accentSoft: a.s900,
    accentSoftPressed: a.s800,
    accentOnSoft: a.s300,
    dangerTop: _red.s500,
    dangerBottom: _red.s600,
    dangerSoft: const Color(0x33EF4444),
    dangerOnSoft: _red.s300,
    positive: a.s300,
    positiveSoft: a.s900,
    caution: _amber.s400,
    cautionSoft: const Color(0x33F59E0B),
    info: _blue.s400,
    infoSoft: const Color(0x333B82F6),
    disabledFill: _n.s800,
    disabledText: _n.s600,
    switchOffTop: _n.s700,
    switchOffBottom: _n.s700,
    knob: _n.s50,
    // See-through so the track shows on raised sheets and dialogs too (an
    // opaque neutral 800 matched them and the control lost its outline).
    segmentedTrack: const Color(0x24FFFFFF),
    segmentedThumb: _n.s600,
    glassTint: const Color(0x59383838),
    glassBubble: const Color(0x1FFFFFFF),
    glassBubbleHeld: const Color(0x2EFFFFFF),
    glassPressed: const Color(0x24FFFFFF),
    glassTintStrong: const Color(0x80262626),
    rimHighlight: const Color(0x59FFFFFF),
    rimShade: const Color(0x66000000),
    shadow: const Color(0x80000000),
    scrim: const Color(0x99000000),
  );
}

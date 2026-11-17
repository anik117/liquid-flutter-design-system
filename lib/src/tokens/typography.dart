import 'package:flutter/widgets.dart';

/// Composite text styles, named like BoardUI's (`title-1`, `headline`,
/// `body`, `caption-1`) and sized like iOS Dynamic Type so phone text is
/// never too small. Each style sets size, weight, line height and tracking
/// together; components never stack those by hand.
class LqTypography {
  LqTypography({String? fontFamily, String? displayFontFamily})
    : _body = fontFamily,
      _display = displayFontFamily ?? fontFamily;

  final String? _body;
  final String? _display;

  TextStyle _s(double size, double height, FontWeight weight,
          {double tracking = 0, bool display = false}) =>
      TextStyle(
        fontFamily: display ? _display : _body,
        fontSize: size,
        height: height / size,
        fontWeight: weight,
        letterSpacing: tracking,
        leadingDistribution: TextLeadingDistribution.even,
      );

  /// The one big number on a screen: deductions, miles, totals.
  late final TextStyle hero =
      _s(44, 50, FontWeight.w600, tracking: -1.1, display: true)
          .copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  /// Opening title of a tab page (iOS large title).
  late final TextStyle largeTitle =
      _s(34, 41, FontWeight.w700, tracking: -0.6, display: true);

  late final TextStyle title1 =
      _s(28, 34, FontWeight.w600, tracking: -0.5, display: true);
  late final TextStyle title2 =
      _s(22, 28, FontWeight.w600, tracking: -0.3, display: true);
  late final TextStyle title3 = _s(20, 25, FontWeight.w600, tracking: -0.2);

  /// Row titles, button labels, emphasized body.
  late final TextStyle headline = _s(17, 22, FontWeight.w600, tracking: -0.2);
  late final TextStyle body = _s(17, 22, FontWeight.w400, tracking: -0.2);
  late final TextStyle bodyMedium =
      _s(17, 22, FontWeight.w500, tracking: -0.2);
  late final TextStyle callout = _s(16, 21, FontWeight.w400, tracking: -0.15);
  late final TextStyle calloutMedium =
      _s(16, 21, FontWeight.w500, tracking: -0.15);

  /// Row subtitles and secondary lines.
  late final TextStyle subhead = _s(15, 20, FontWeight.w400, tracking: -0.1);
  late final TextStyle subheadMedium =
      _s(15, 20, FontWeight.w500, tracking: -0.1);
  late final TextStyle footnote = _s(13, 18, FontWeight.w400);
  late final TextStyle footnoteMedium = _s(13, 18, FontWeight.w500);
  late final TextStyle caption = _s(12, 16, FontWeight.w500);

  /// Tabular figures for any number that sits in a column or updates live.
  static TextStyle numeric(TextStyle base) =>
      base.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  static const TextHeightBehavior tight = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );
}

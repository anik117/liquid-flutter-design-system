import 'dart:math' as math;

/// Sample VaultMileage numbers shared by the chart demos: a gig driver's
/// 2026 so far (January to mid-November).
abstract final class ChartData {
  static const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static final monthsSoFar = months.sublist(0, 11);

  /// Mileage deductions per month at 72.5¢ / mi, in dollars.
  static const deductions = <double>[512.0, 486, 603, 571, 644, 702, 689, 731, 598, 655, 421];

  /// Business miles per month, this year and last year.
  static const miles2026 = <double>[706.0, 670, 832, 788, 888, 968, 950, 1008, 825, 903, 581];
  static const miles2025 = <double>[610.0, 655, 702, 740, 801, 846, 902, 870, 794, 812, 760, 698];

  /// Miles by purpose per month (stacked bars).
  static const business = miles2026;
  static const personal = <double>[96.0, 104, 120, 98, 131, 142, 126, 110, 94, 105, 84];
  static const commute = <double>[58.0, 61, 60, 57, 62, 59, 55, 60, 58, 61, 49];

  /// Earnings per mile by platform, by month.
  static const doorDash = <double>[1.21, 1.18, 1.26, 1.30, 1.28, 1.35, 1.32, 1.38, 1.29, 1.33, 1.32];
  static const uber = <double>[0.82, 0.79, 0.76, 0.74, 0.77, 0.72, 0.70, 0.73, 0.69, 0.71, 0.71];
  static const lyft = <double>[0.64, 0.66, 0.61, 0.60, 0.62, 0.59, 0.57, 0.60, 0.56, 0.58, 0.58];

  /// Shuffles [values] by up to ±30%, for the morphing demos.
  static List<double> shuffle(List<double> values, math.Random random) => [
    for (final v in values) (v * (0.7 + random.nextDouble() * 0.6)).roundToDouble(),
  ];

  /// "$1,240"
  static String dollars(double v) => '\$${group(v.round())}';

  /// "$1.32"
  static String perMile(double v) => '\$${v.toStringAsFixed(2)}';

  /// "1,008 mi"
  static String miles(double v) => '${group(v.round())} mi';

  /// "12,418"
  static String group(int n) {
    final s = n.abs().toString();
    final b = StringBuffer(n < 0 ? '−' : '');
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return b.toString();
  }
}

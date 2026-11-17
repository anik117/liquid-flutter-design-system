import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/widgets.dart';

import '../tokens/brand.dart';
import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/typography.dart';
import '../foundation/licenses.dart';

/// Everything a component needs to draw itself: brand, colors, type, radii
/// and the target platform (so a control can pick its iOS or Android form).
class LqThemeData {
  LqThemeData({
    required this.brand,
    required Brightness brightness,
    bool highContrast = false,
    TargetPlatform? platform,
  }) : colors = LqColors.resolve(brand, brightness, highContrast: highContrast),
       type = LqTypography(
         fontFamily: brand.fontFamily,
         displayFontFamily: brand.displayFontFamily,
       ),
       radius = LqRadius(brand.cornerScale),
       platform = platform ?? defaultTargetPlatform;

  final LqBrand brand;
  final LqColors colors;
  final LqTypography type;
  final LqRadius radius;
  final TargetPlatform platform;

  bool get isIOS =>
      platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  bool get isDark => colors.isDark;
}

/// Provides [LqThemeData] to the subtree. Read it with `context.lq`.
class LqTheme extends InheritedWidget {
  const LqTheme({super.key, required this.data, required super.child});

  final LqThemeData data;

  static LqThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<LqTheme>();
    assert(theme != null, 'No LqTheme above this widget. Wrap the app in LqTheme.');
    return theme!.data;
  }

  @override
  bool updateShouldNotify(LqTheme oldWidget) => oldWidget.data != data;
}

/// [LqTheme] plus default text and icon styles. Use it at the app root and
/// around anything shown in an overlay (sheets, toasts), where no page
/// supplies a text style and Flutter would draw its debug underline.
class LqScope extends StatelessWidget {
  const LqScope({super.key, required this.data, required this.child});

  final LqThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    LqLicenses.ensureRegistered();
    return _scoped();
  }

  Widget _scoped() => LqTheme(
    data: data,
    child: DefaultTextStyle(
      style: data.type.body.copyWith(
        color: data.colors.textPrimary,
        decoration: TextDecoration.none,
      ),
      child: IconTheme(
        data: IconThemeData(color: data.colors.iconPrimary, size: 22),
        child: child,
      ),
    ),
  );
}

extension LqContext on BuildContext {
  LqThemeData get lq => LqTheme.of(this);
}

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'lq_theme.dart';

/// Bridges our tokens into Material and Cupertino themes, so platform pieces
/// we keep (text selection, the native edit menu, scroll physics, page
/// transitions, pickers) match the design system.
extension LqPlatformThemes on LqThemeData {
  ThemeData toMaterialTheme() {
    final c = colors;
    final scheme = ColorScheme(
      brightness: c.brightness,
      primary: c.accent,
      onPrimary: c.textOnAccent,
      secondary: c.accent,
      onSecondary: c.textOnAccent,
      error: c.textDanger,
      onError: c.textOnAccent,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      outline: c.border,
      outlineVariant: c.separator,
      surfaceContainerHighest: c.surfaceRaised,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      platform: platform,
      scaffoldBackgroundColor: c.canvas,
      fontFamily: brand.fontFamily,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.accent,
        selectionColor: c.accent.withValues(alpha: 0.25),
        selectionHandleColor: c.accent,
      ),
      cupertinoOverrideTheme: toCupertinoTheme(),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  CupertinoThemeData toCupertinoTheme() => CupertinoThemeData(
    brightness: colors.brightness,
    primaryColor: colors.accent,
    scaffoldBackgroundColor: colors.canvas,
    barBackgroundColor: colors.glassTintStrong,
  );
}

import 'package:material_ui/material_ui.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import 'gallery_settings.dart';
import 'gallery_shell.dart';

void main() => runApp(const LiquidGalleryApp());

/// Hosts the design system preview. Brand, appearance and contrast live in
/// [GallerySettings] so the Theme tab can switch them live.
class LiquidGalleryApp extends StatefulWidget {
  const LiquidGalleryApp({super.key});

  @override
  State<LiquidGalleryApp> createState() => _LiquidGalleryAppState();
}

class _LiquidGalleryAppState extends State<LiquidGalleryApp> {
  final _settings = GallerySettingsController();

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        final platformDark =
            MediaQuery.platformBrightnessOf(context) == Brightness.dark;
        final brightness = switch (_settings.appearance) {
          GalleryAppearance.system => platformDark ? Brightness.dark : Brightness.light,
          GalleryAppearance.light => Brightness.light,
          GalleryAppearance.dark => Brightness.dark,
        };
        final lq = LqThemeData(
          brand: _settings.brand,
          brightness: brightness,
          highContrast: _settings.highContrast,
        );
        return GallerySettings(
          controller: _settings,
          child: MaterialApp(
            title: 'Liquid Gallery',
            debugShowCheckedModeBanner: false,
            theme: lq.toMaterialTheme(),
            builder: (context, child) => LqScope(data: lq, child: child!),
            home: const GalleryShell(),
          ),
        );
      },
    );
  }
}

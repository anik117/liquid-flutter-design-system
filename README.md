# Liquid Flutter Design System

A design system for Flutter apps on iOS and Android: brand tokens, light, dark
and high-contrast themes, Liquid Glass surfaces and 60 components with fluid,
spring-based motion that feel native on each platform.

- **Package:** `liquid_flutter_design_system`
- **Class prefix:** `Lq` (`LqButton`, `LqSheet`, `LqBarChart`)
- **Requires:** Flutter 3.50 or newer (it builds on the official `material_ui`
  and `cupertino_ui` packages)

## Run the gallery

```bash
cd example
flutter run
```

Liquid Gallery has three tabs: a sample app screen (a mileage tracker) built
from the system, the **Components** catalog (searchable, with "View all" per
category) and a **Theme** tab that switches brand, appearance and contrast
live.

## Use it in an app

Add it as a git dependency:

```yaml
dependencies:
  liquid_flutter_design_system:
    git:
      url: https://github.com/anik117/liquid-flutter-design-system.git
      ref: main
```

Wrap the app and read tokens with `context.lq`:

```dart
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

final lq = LqThemeData(brand: LqBrand.vaultMileage, brightness: Brightness.light);

MaterialApp(
  theme: lq.toMaterialTheme(),
  builder: (context, child) => LqScope(data: lq, child: child!),
  home: const MyHome(),
);
```

`context.lq.colors.accent`, `context.lq.type.headline`, `context.lq.radius.md`.

## Theme a new app

Add one `LqBrand`: an 11-step accent ramp and a corner scale (fonts are
optional; by default text uses the platform font, SF Pro on iOS and Roboto on
Android). Every component re-themes from it, in light, dark and high contrast.
`LqBrand.vaultMileage` (green) and `LqBrand.sampleIndigo` are examples.

## What's inside

| Folder | What |
|---|---|
| `lib/src/tokens` | Palette, brand, semantic colors, type, spacing, radius, icon sizes, shadows, motion |
| `lib/src/theme` | `LqTheme` / `LqScope`, and the bridge to Material and Cupertino themes |
| `lib/src/foundation` | Pressable (press motion, haptics), Liquid Glass, springs, licences |
| `lib/src/components` | Actions, inputs, navigation, feedback, overlays, data display, charts, motion, layout |

The full component list is in `ROADMAP.md`; how to add one is in
`CONVENTIONS.md`. Every source file stays at or under 200 lines.

## Credits and licences

Some component styling is adapted from the free, MIT-licensed BoardUI
components. This project is not affiliated with or endorsed by BoardUI. The
full notice is in `THIRD_PARTY_NOTICES.md`, and `LqScope` adds it to every
app's licence page automatically. Icons are Remix Icon (Apache 2.0).

Never copy BoardUI **Pro** components into this project: the Pro licence
forbids using them in a design system shared outside the licence holder's
organisation.

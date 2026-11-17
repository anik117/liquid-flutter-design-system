# Building a Liquid component

Rules every component follows, so the whole system feels like one thing.

## Files and names

- One component per file under `lib/src/components/<category>/`. Categories:
  `actions`, `inputs`, `navigation`, `feedback`, `overlays`, `data`, `charts`,
  `motion`, `layout`.
- **Every file stays at or under 200 lines**.
  Split helpers into `<name>_parts.dart` when needed.
- Public classes start with `Lq` (`LqSlider`, `LqDialog`). Functions that show
  overlays are `showLq<Name>` (`showLqDialog`).
- Export new files from the category barrel `lib/src/components/<category>/<category>.dart`.
  Do not edit `lib/liquid_flutter_design_system.dart`; it exports the barrels.
- Every public class and constructor parameter gets a one-line `///` doc
  saying what it is for, in plain words.

## Read tokens, never hard-code

- `final lq = context.lq;` then `lq.colors.*`, `lq.type.*`, `lq.radius.*`.
- Spacing: `LqSpace.x1…x16`, `LqSpace.gutter`. Sizes: `LqSize.*`. Icons:
  `LqIconSize.*`. Shadows: `LqShadows.*(lq.colors.shadow)`.
- No `Color(0x…)` literals in components except pure white/black overlays
  for highlights and sheens. No raw font sizes: use `lq.type.<style>` and
  `copyWith(color: …)`.
- Icons: `RemixIcons.*` (line icons for navigation and toolbars, fill icons
  for selected states and small glyphs).
- Use `lq.isIOS` only where the platform must differ (pickers, edit menu,
  keyboard). Otherwise the look is the same on both platforms.

## Motion and touch

- Anything tappable uses `LqPressable` (press scale, haptic, semantics). Rows
  pass `scale: 1` and show a pressed fill instead. Glass controls use
  `LqMotion.glassPressScale` (they swell).
- Durations come from `LqMotion.of(context, LqMotion.fast | standard | slow)`
  so Reduce Motion turns movement off. Curves: `LqMotion.springCurve` for
  things that settle, `LqMotion.emphasized` for things that must not
  overshoot, `LqMotion.release` for press release.
- Drag-driven motion (sliders, sheets, swipe rows) releases with a real
  spring carrying the finger's velocity: `LqSpring.animate(controller, target, velocity: …)`.
- Haptics: `LqHaptics.play(LqHaptic.selection)` for value ticks,
  `.light` for taps, `.medium` for commits, `.success` / `.warning` for
  outcomes. Never on every frame of a drag, only on discrete steps.
- Glass (`LqGlass`) is for the navigation and overlay layer only: bars,
  floating buttons, menus, toasts, dialogs. Content stays opaque.

## Accessibility

- Every interactive element has a semantic label or visible text.
- Toggles expose `toggled` / `checked` / `selected`; sliders expose value and
  increase/decrease actions.
- Minimum touch target 44 × 44.
- Text never clips at large Dynamic Type sizes: wrap, or `FittedBox` scale
  down for single big numbers.

## Light, dark, brand

- Check every component in light and dark and with the sample indigo brand.
  Nothing may hard-code the vault green; it comes from `lq.colors.accent*`.

## Gallery

- Each component gets a demo in `example/lib/demos/<category>/<name>_demo.dart`
  showing every variant and state, and an entry in
  `example/lib/catalog/catalog_<category>.dart`.
- Demos use realistic VaultMileage content (drives, miles, deductions,
  vehicles, receipts), never lorem ipsum.

## Tests

- Add widget tests to `test/<category>_test.dart`: it builds in light and
  dark under `LqScope`, the main interaction changes state, semantics are set.

## Third-party design sources

- BoardUI: adapt only the free, MIT-licensed components from
  https://github.com/BoardUI/boardui, and credit them in
  `THIRD_PARTY_NOTICES.md`. Never copy or port BoardUI **Pro** components
  (modal, drawer, toast, skeleton, popover, combobox and others not in the
  free repo), including from projects that have Pro installed: the Pro
  licence forbids using them in a design system shared outside the licence
  holder's organisation. Build those from platform patterns instead.
- Keep "BoardUI" out of names, descriptions and marketing copy; credits and
  code comments only.
- Text uses the platform system font (SF Pro on iOS, Roboto on Android).
  Do not bundle custom fonts unless the product owner asks; any bundled
  font must be OFL or similar, with its licence registered in `LqLicenses`.

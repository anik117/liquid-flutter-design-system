# Liquid roadmap

Component inventory, by category. Ticked items exist, have a gallery demo and
widget tests. Status as of 17 Nov 2026: 60 gallery entries, 46 tests passing.

## Foundations
- [x] Tokens: palette, brand, semantic colors (light, dark, high contrast), type, spacing, radius, icon sizes, shadows, motion
- [x] Theme scope (`LqScope`, `context.lq`) and Material / Cupertino bridge
- [x] Liquid Glass surface with lit rim, glass bubble and pressed tokens
- [x] Pressable (press motion, haptics, semantics, Reduce Motion)
- [x] Real spring physics for drag release (`LqSpring`), haptics (`LqHaptics`)
- [x] Progressive scroll edge, section layout

## Actions
- [x] Button (primary, secondary, ghost, danger, plain; sizes; loading)
- [x] Icon button (glass, primary, secondary, ghost, plain)
- [x] Chips (filter, choice, input) and chip group
- [x] Button group
- [x] Glass toolbar
- [x] Floating action button (extends, collapses on scroll)

## Inputs
- [x] Text field, text area, search field (iOS Cancel)
- [x] Switch, checkbox, radio and radio group, segmented control
- [x] Stepper (hold to repeat), slider (glass thumb, haptic steps, spring snap)
- [x] Select (iOS wheel / Android list), date and time fields (native pickers)
- [x] One-time code field

## Navigation
- [x] Floating glass tab bar (scrub, lift)
- [x] Page scaffold (large title, progressive edge, title hand-over, stretch)
- [x] In-page tabs with sliding indicator and swipeable pages
- [x] Page dots, back button

## Feedback
- [x] Toast, badge, count badge
- [x] Inline banner
- [x] Progress bar, progress ring, spinner
- [x] Skeleton shimmer
- [x] Empty state

## Overlays
- [x] Bottom sheet
- [x] Dialog (glass, spring in)
- [x] Action sheet
- [x] Menu that morphs out of its glass button
- [x] Tooltip

## Data display
- [x] Card, list group and row, amount
- [x] Swipe actions on rows
- [x] Avatar and avatar group
- [x] Stat tile
- [x] Disclosure (accordion) and group
- [x] Key–value summary list
- [x] Timeline
- [x] Carousel
- [x] Calendar strip

## Charts
- [x] Bar, stacked / grouped bar, horizontal ranking bars
- [x] Line, multi-line, area
- [x] Sparkline
- [x] Ring / donut, gauge
- [x] Calendar heatmap
- [x] Budget-vs-actual bars
- [x] Legend, value pill, chart card

## Motion
- [x] Staggered entrance
- [x] Pull to refresh (glass)
- [x] Rolling counter

## Next
- [ ] Ring chart: tap a segment to pick it
- [ ] Line chart: scrub past the end of the main series into the comparison
- [ ] Android pass on a real emulator (back gesture, Material pickers, haptics)
- [ ] Review every component on a physical iPhone (glass blur, haptics, keyboard)
- [ ] Tablet layouts (sidebar, two-pane)
- [ ] Move Liquid to its own repository so every app depends on one version

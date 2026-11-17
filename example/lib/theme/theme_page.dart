import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';
import 'package:material_ui/material_ui.dart' show showLicensePage;

import '../gallery_settings.dart';


/// Switch brand, appearance and contrast live, and see the tokens.
class ThemePage extends StatelessWidget {
  const ThemePage({super.key, required this.bottomInset});

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final settings = GallerySettings.of(context);
    final lq = context.lq;
    final c = lq.colors;
    final swatches = <(String, Color)>[
      ('canvas', c.canvas),
      ('surface', c.surface),
      ('text', c.textPrimary),
      ('text 2', c.textSecondary),
      ('border', c.border),
      ('accent', c.accent),
      ('accent soft', c.accentSoft),
      ('positive', c.positive),
      ('caution', c.caution),
      ('danger', c.textDanger),
      ('info', c.info),
      ('glass', c.glassTintStrong),
    ];

    return LqPageScaffold(
      title: 'Theme',
      subtitle: 'One brand file re-themes everything',
      bottomInset: bottomInset,
      children: [
        LqSection(
          title: 'Brand',
          children: [
            LqSegmentedControl<LqBrand>(
              value: settings.brand,
              onChanged: (b) => settings.brand = b,
              segments: const [
                LqSegment(value: LqBrand.vaultMileage, label: 'VaultMileage'),
                LqSegment(value: LqBrand.sampleIndigo, label: 'Sample app'),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'Appearance',
          children: [
            LqSegmentedControl<GalleryAppearance>(
              value: settings.appearance,
              onChanged: (a) => settings.appearance = a,
              segments: const [
                LqSegment(value: GalleryAppearance.system, label: 'System'),
                LqSegment(value: GalleryAppearance.light, label: 'Light'),
                LqSegment(value: GalleryAppearance.dark, label: 'Dark'),
              ],
            ),
            LqListGroup(
              leadingInset: false,
              children: [
                LqListRow(
                  title: 'High contrast',
                  trailing: LqSwitch(
                    value: settings.highContrast,
                    onChanged: (v) => settings.highContrast = v,
                  ),
                ),
              ],
            ),
          ],
        ),
        LqListGroup(
          header: 'About',
          leadingInset: false,
          children: [
            LqListRow(
              title: 'Licences',
              subtitle: 'Open-source notices, including BoardUI',
              onTap: () => showLicensePage(
                context: context,
                applicationName: 'Liquid Gallery',
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Colors',
          children: [
            Wrap(
              spacing: LqSpace.x3,
              runSpacing: LqSpace.x3,
              children: [for (final (name, color) in swatches) _Swatch(name: name, color: color)],
            ),
          ],
        ),
        LqSection(
          title: 'Type',
          children: [
            for (final (name, style) in <(String, TextStyle)>[
              ('Large title 34', lq.type.largeTitle),
              ('Title 1 · 28', lq.type.title1),
              ('Title 2 · 22', lq.type.title2),
              ('Headline 17', lq.type.headline),
              ('Body 17', lq.type.body),
              ('Subhead 15', lq.type.subhead),
              ('Footnote 13', lq.type.footnote),
              ('Caption 12', lq.type.caption),
            ])
              Text(name, style: style.copyWith(color: c.textPrimary)),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return SizedBox(
      width: 74,
      child: Column(
        children: [
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(lq.radius.md),
              border: Border.all(color: lq.colors.border, width: 0.5),
            ),
          ),
          const SizedBox(height: LqSpace.x1),
          Text(name, style: lq.type.caption.copyWith(color: lq.colors.textSecondary)),
        ],
      ),
    );
  }
}

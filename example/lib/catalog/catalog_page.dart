import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';
import 'package:material_ui/material_ui.dart' show MaterialPageRoute;

import 'catalog.dart';
import 'category_page.dart';
import 'component_page.dart';

/// The Components tab: every component, grouped by category, with a
/// search field that filters by name or summary.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, required this.bottomInset});

  final double bottomInset;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String _query = '';

  bool _matches(GalleryEntry e) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return e.name.toLowerCase().contains(q) || e.summary.toLowerCase().contains(q);
  }

  void _open(GalleryEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ComponentPage(entry: entry)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = galleryCategories.fold<int>(0, (n, c) => n + c.entries.length);
    final groups = [
      for (final category in galleryCategories)
        (category, category.entries.where(_matches).toList()),
    ].where((g) => g.$2.isNotEmpty).toList();

    return LqPageScaffold(
      title: 'Components',
      subtitle: '$count components · Liquid design system',
      bottomInset: widget.bottomInset,
      children: [
        LqTextField(
          placeholder: 'Search components',
          prefixIcon: RemixIcons.search_line,
          textInputAction: TextInputAction.search,
          textCapitalization: TextCapitalization.none,
          onChanged: (v) => setState(() => _query = v.trim()),
        ),
        for (final (category, entries) in groups)
          LqListGroup(
            header: category.name,
            trailingHeader: LqButton(
              label: 'View all',
              variant: LqButtonVariant.plain,
              size: LqButtonSize.small,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CategoryPage(category: category),
                ),
              ),
            ),
            children: [
              for (final e in entries)
                LqListRow(
                  leading: LqIconTile(icon: e.icon),
                  title: e.name,
                  subtitle: e.summary,
                  onTap: () => _open(e),
                ),
            ],
          ),
      ],
    );
  }
}

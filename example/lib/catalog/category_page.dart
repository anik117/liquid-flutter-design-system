import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import 'catalog.dart';

/// Every demo in one category, stacked on a single scrolling page, so a
/// whole category can be reviewed at once.
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.category});

  final GalleryCategory category;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    return LqPageScaffold(
      title: category.name,
      subtitle: '${category.entries.length} components',
      leading: LqIconButton(
        icon: RemixIcons.arrow_left_s_line,
        semanticLabel: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      bottomInset: MediaQuery.paddingOf(context).bottom,
      children: [
        for (final entry in category.entries)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(entry.name, style: lq.type.title2.copyWith(color: lq.colors.textPrimary)),
              const SizedBox(height: LqSpace.x1),
              Text(entry.summary, style: lq.type.subhead.copyWith(color: lq.colors.textSecondary)),
              const SizedBox(height: LqSpace.x5),
              entry.builder(context),
              const SizedBox(height: LqSpace.x6),
              Container(height: 0.5, color: lq.colors.separator),
            ],
          ),
      ],
    );
  }
}

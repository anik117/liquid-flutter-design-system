import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import 'catalog.dart';

/// One component's demo page: a glass back button, the component's name as
/// the large title, its summary, then the demo.
class ComponentPage extends StatelessWidget {
  const ComponentPage({super.key, required this.entry});

  final GalleryEntry entry;

  @override
  Widget build(BuildContext context) {
    return LqPageScaffold(
      title: entry.name,
      subtitle: entry.summary,
      leading: LqIconButton(
        icon: RemixIcons.arrow_left_s_line,
        semanticLabel: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      bottomInset: MediaQuery.paddingOf(context).bottom,
      children: [entry.builder(context)],
    );
  }
}

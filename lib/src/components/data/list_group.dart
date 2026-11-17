import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';

/// An inset grouped list: a sentence-case header, rows on one rounded white
/// surface, hairline separators that start at the text (never under the
/// icon), and an optional footer note.
class LqListGroup extends StatelessWidget {
  const LqListGroup({
    super.key,
    required this.children,
    this.header,
    this.footer,
    this.trailingHeader,
    this.leadingInset = true,
  });

  final List<Widget> children;
  final String? header;
  final String? footer;

  /// A small action on the header's right, e.g. "See all".
  final Widget? trailingHeader;

  /// Rows have a 32pt icon tile, so separators start after it.
  final bool leadingInset;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final indent = leadingInset
        ? LqSpace.x4 + LqSize.iconTile + LqSpace.x3
        : LqSpace.x4;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(Padding(
          padding: EdgeInsets.only(left: indent),
          child: Container(height: 0.5, color: c.separator),
        ));
      }
      rows.add(children[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null || trailingHeader != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(LqSpace.x1, 0, LqSpace.x1, LqSpace.x2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    header ?? '',
                    style: lq.type.subheadMedium.copyWith(color: c.textSecondary),
                  ),
                ),
                ?trailingHeader,
              ],
            ),
          ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(lq.radius.lg),
            border: Border.all(color: c.border, width: 0.5),
            boxShadow: LqShadows.card(c.shadow),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: rows),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(LqSpace.x1, LqSpace.x2, LqSpace.x1, 0),
            child: Text(
              footer!,
              style: lq.type.footnote.copyWith(color: c.textSecondary),
            ),
          ),
      ],
    );
  }
}

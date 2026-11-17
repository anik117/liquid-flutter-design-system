import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';

/// A titled block of content: a title, an optional quiet caption and an
/// optional action on the right, then its children stacked with an even
/// gap. Use it to group related controls on a page.
class LqSection extends StatelessWidget {
  const LqSection({
    super.key,
    required this.children,
    this.title,
    this.caption,
    this.trailing,
    this.gap = LqSpace.x3,
  });

  /// Section heading, sentence case.
  final String? title;

  /// One line under the title explaining the section.
  final String? caption;

  /// A small action on the title row, e.g. a plain "See all" button.
  final Widget? trailing;

  /// Space between children.
  final double gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || trailing != null) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  title ?? '',
                  style: lq.type.title3.copyWith(color: c.textPrimary),
                ),
              ),
              ?trailing,
            ],
          ),
          if (caption != null) ...[
            const SizedBox(height: LqSpace.x1),
            Text(caption!, style: lq.type.subhead.copyWith(color: c.textSecondary)),
          ],
          const SizedBox(height: LqSpace.x3),
        ],
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}

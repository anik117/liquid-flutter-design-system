import 'package:flutter/widgets.dart';

import '../../tokens/metrics.dart';

/// The page header's trailing actions, [LqSpace.x2] apart. They scale down
/// to fit on narrow phones or with large text rather than overflow the
/// header; at normal sizes they keep their size. Internal to
/// `LqPageScaffold`.
class LqPageActionsRow extends StatelessWidget {
  const LqPageActionsRow({super.key, required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    // Right-aligned in the space the header gives it; only the buttons take
    // touches, so content scrolled under the header stays tappable.
    return Align(
      alignment: Alignment.centerRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(width: LqSpace.x2),
              actions[i],
            ],
          ],
        ),
      ),
    );
  }
}

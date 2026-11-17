import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

/// Stacks a demo's sections with a generous, even gap. Every demo page
/// returns one of these, filled with [LqSection]s.
class DemoColumn extends StatelessWidget {
  const DemoColumn({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) const SizedBox(height: LqSpace.x8),
        children[i],
      ],
    ],
  );
}

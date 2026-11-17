import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class SegmentedDemo extends StatefulWidget {
  const SegmentedDemo({super.key});

  @override
  State<SegmentedDemo> createState() => _SegmentedDemoState();
}

class _SegmentedDemoState extends State<SegmentedDemo> {
  String _period = 'Month';
  String _kind = 'All';

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Period',
          caption: 'Tap a segment, or press and drag across.',
          children: [
            LqSegmentedControl<String>(
              value: _period,
              onChanged: (v) => setState(() => _period = v),
              segments: const [
                LqSegment(value: 'Week', label: 'Week'),
                LqSegment(value: 'Month', label: 'Month'),
                LqSegment(value: 'Quarter', label: 'Quarter'),
                LqSegment(value: 'Year', label: 'Year'),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'Two or three choices',
          children: [
            LqSegmentedControl<String>(
              value: _kind,
              onChanged: (v) => setState(() => _kind = v),
              segments: const [
                LqSegment(value: 'All', label: 'All'),
                LqSegment(value: 'Business', label: 'Business'),
                LqSegment(value: 'Personal', label: 'Personal'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

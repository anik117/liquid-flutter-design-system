import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class SliderDemo extends StatefulWidget {
  const SliderDemo({super.key});

  @override
  State<SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  double _business = 65;
  double _reminder = 0.4;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    // 2026 IRS standard rate (76¢), on a year of 18,240 driven miles.
    final deduction = 18240 * _business / 100 * 0.76;
    return DemoColumn(
      children: [
        LqSection(
          title: 'Stepped',
          caption: 'A tick per 5%. Fling and release: it springs to the nearest step.',
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Business use',
                    style: lq.type.bodyMedium.copyWith(color: lq.colors.textPrimary),
                  ),
                ),
                Text(
                  '${_business.round()}%',
                  style: LqTypography.numeric(lq.type.headline)
                      .copyWith(color: lq.colors.textAccent),
                ),
              ],
            ),
            LqSlider(
              value: _business,
              min: 0,
              max: 100,
              divisions: 20,
              showValueLabel: true,
              format: (v) => '${v.round()}%',
              semanticLabel: 'Business use',
              onChanged: (v) => setState(() => _business = v),
            ),
            Text(
              'About \$${deduction.toStringAsFixed(0)} deductible this year.',
              style: lq.type.subhead.copyWith(color: lq.colors.textSecondary),
            ),
          ],
        ),
        LqSection(
          title: 'Continuous',
          children: [
            Text(
              'Review reminder sensitivity',
              style: lq.type.bodyMedium.copyWith(color: lq.colors.textPrimary),
            ),
            LqSlider(
              value: _reminder,
              format: (v) => '${(v * 100).round()}%',
              semanticLabel: 'Review reminder sensitivity',
              onChanged: (v) => setState(() => _reminder = v),
            ),
          ],
        ),
        const LqSection(
          title: 'Disabled',
          children: [
            LqSlider(value: 0.3, onChanged: null, semanticLabel: 'Locked by fleet admin'),
          ],
        ),
      ],
    );
  }
}

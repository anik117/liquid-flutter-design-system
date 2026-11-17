import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class ButtonsDemo extends StatefulWidget {
  const ButtonsDemo({super.key});

  @override
  State<ButtonsDemo> createState() => _ButtonsDemoState();
}

class _ButtonsDemoState extends State<ButtonsDemo> {
  bool _saving = false;

  Future<void> _fakeSave() async {
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Variants',
          caption: 'One primary action per screen; the rest step back.',
          children: [
            LqButton(label: 'Save drive', expand: true, onPressed: () {}),
            LqButton(
              label: 'Export report',
              variant: LqButtonVariant.secondary,
              leadingIcon: RemixIcons.upload_2_line,
              expand: true,
              onPressed: () {},
            ),
            LqButton(
              label: 'Claim as business',
              variant: LqButtonVariant.ghost,
              expand: true,
              onPressed: () {},
            ),
            LqButton(
              label: 'Delete drive',
              variant: LqButtonVariant.danger,
              expand: true,
              onPressed: () {},
            ),
            LqButton(label: 'How deductions work', variant: LqButtonVariant.plain, onPressed: () {}),
          ],
        ),
        LqSection(
          title: 'Sizes',
          children: [
            Wrap(
              spacing: LqSpace.x3,
              runSpacing: LqSpace.x3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                LqButton(label: 'Large', size: LqButtonSize.large, onPressed: () {}),
                LqButton(label: 'Medium', onPressed: () {}),
                LqButton(label: 'Small', size: LqButtonSize.small, onPressed: () {}),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'States',
          caption: 'Loading keeps the width; disabled never takes taps.',
          children: [
            LqButton(label: 'Save trip', expand: true, loading: _saving, onPressed: _fakeSave),
            const LqButton(label: 'Disabled', expand: true, onPressed: null),
            LqButton(
              label: 'Next',
              trailingIcon: RemixIcons.arrow_right_line,
              variant: LqButtonVariant.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class OtpDemo extends StatefulWidget {
  const OtpDemo({super.key});

  @override
  State<OtpDemo> createState() => _OtpDemoState();
}

class _OtpDemoState extends State<OtpDemo> {
  String? _status;

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Sign-in code',
          caption: 'Number pad, "From Messages" autofill on iOS, and paste.',
          children: [
            LqOtpField(
              label: 'Enter the 6-digit code',
              helper: _status ?? 'We sent it to your email. It expires in 10 minutes.',
              onChanged: (_) => setState(() => _status = null),
              onCompleted: (code) => setState(() => _status = 'Checking $code…'),
            ),
          ],
        ),
        const LqSection(
          title: 'States',
          children: [
            LqOtpField(length: 4, label: 'Backup PIN', error: "That code didn't match. Try again."),
          ],
        ),
      ],
    );
  }
}

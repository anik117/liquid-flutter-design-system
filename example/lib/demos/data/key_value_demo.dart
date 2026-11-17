import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class KeyValueDemo extends StatelessWidget {
  const KeyValueDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoColumn(
      children: [
        LqKeyValueList(
          header: '2026 deduction',
          footer: 'Standard mileage method. Tolls and parking are listed '
              'separately on Schedule C.',
          items: [
            LqKeyValue('Business miles', '7,905.2 mi'),
            LqKeyValue('Rate', '76¢ / mi'),
            LqKeyValue('Drives', '412'),
          ],
          total: LqKeyValue('Deduction', r'$6,007.95'),
        ),
        LqKeyValueList(
          header: 'Trip summary',
          items: [
            LqKeyValue('Started', '6:12 PM · Mission District'),
            LqKeyValue('Ended', '6:41 PM · SoMa'),
            LqKeyValue('Distance', '6.4 mi'),
            LqKeyValue('Duration', '29 min'),
            LqKeyValue('Vehicle', 'Toyota Prius'),
          ],
        ),
      ],
    );
  }
}

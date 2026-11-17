import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class DisclosureDemo extends StatelessWidget {
  const DisclosureDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoColumn(
      children: [
        LqSection(
          title: 'FAQ',
          caption: 'Only one answer stays open at a time.',
          children: [
            LqDisclosureGroup(
              exclusive: true,
              header: 'Deductions',
              children: [
                LqDisclosure(
                  title: 'How is my deduction calculated?',
                  initiallyExpanded: true,
                  child: Text(
                    'Business miles × the IRS standard rate. In 2026 that is '
                    '76¢ per mile, so 7,905.2 mi comes to \$6,007.95. Tolls and '
                    'parking for business drives are added on top.',
                  ),
                ),
                LqDisclosure(
                  title: 'Does my commute count?',
                  child: Text(
                    'No. Driving from home to your first pickup is commuting. '
                    'Miles between pickups and back to a hot zone do count.',
                  ),
                ),
                LqDisclosure(
                  title: 'What if I drive for two apps at once?',
                  child: Text(
                    'Count each mile once. Tag the drive with every platform; '
                    'the deduction does not double.',
                  ),
                ),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'With subtitle and tile',
          children: [
            LqDisclosureGroup(
              children: [
                LqDisclosure(
                  leading: LqIconTile(icon: RemixIcons.car_line),
                  title: 'Toyota Prius',
                  subtitle: '2019 · 48,210 mi on the odometer',
                  child: Text(
                    'Primary vehicle. 6,412 business miles this year across '
                    '318 drives. Last fuel stop: Shell, Nov 14.',
                  ),
                ),
                LqDisclosure(
                  leading: LqIconTile(icon: RemixIcons.e_bike_line),
                  title: 'Rad Power e-bike',
                  subtitle: 'Deliveries downtown',
                  child: Text(
                    'Bikes are not covered by the standard mileage rate. Log '
                    'actual expenses for repairs and batteries instead.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

/// A logged drive in the motion demos.
typedef DemoDrive = ({String route, String when, double miles, String platform});

/// Recent drives for the motion demos.
const demoDrives = <DemoDrive>[
  (route: 'Home → MSY Airport', when: 'Today, 7:42 AM', miles: 18.2, platform: 'Uber'),
  (route: 'Airport → Warehouse District', when: 'Today, 8:31 AM', miles: 14.6, platform: 'Uber'),
  (route: 'Magazine St pickups', when: 'Yesterday, 6:05 PM', miles: 22.9, platform: 'DoorDash'),
  (route: 'Metairie → Uptown', when: 'Yesterday, 1:18 PM', miles: 11.3, platform: 'Lyft'),
  (route: 'Costco run, Elmwood', when: 'Sun, 10:40 AM', miles: 8.7, platform: 'Instacart'),
  (route: 'Mid-City dinner rush', when: 'Sat, 7:12 PM', miles: 31.4, platform: 'DoorDash'),
  (route: 'Kenner → French Quarter', when: 'Sat, 3:55 PM', miles: 16.8, platform: 'Uber'),
  (route: 'Gentilly short hops', when: 'Fri, 5:20 PM', miles: 12.1, platform: 'Lyft'),
];

/// One drive as a list row: route, time and platform, miles and the
/// deduction at 72.5¢ / mi on the right.
class DemoDriveRow extends StatelessWidget {
  const DemoDriveRow({super.key, required this.drive});

  final DemoDrive drive;

  @override
  Widget build(BuildContext context) {
    final deduction = (drive.miles * 0.725).toStringAsFixed(2);
    return LqListRow(
      leading: const LqIconTile(icon: RemixIcons.steering_2_line, tone: LqTone.accent),
      title: drive.route,
      subtitle: '${drive.when} · ${drive.platform}',
      value: '${drive.miles} mi · \$$deduction',
      onTap: () {},
      showChevron: false,
    );
  }
}

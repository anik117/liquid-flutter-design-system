import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class AvatarDemo extends StatelessWidget {
  const AvatarDemo({super.key});

  static const _team = [
    LqAvatar(name: 'Maya Chen', status: LqTone.positive),
    LqAvatar(name: 'Sam Rivera'),
    LqAvatar(name: 'Diego Alvarez'),
    LqAvatar(name: 'Priya Natarajan'),
    LqAvatar(name: 'Sam Okafor'),
    LqAvatar(name: 'Lena Fischer'),
    LqAvatar(name: 'Jordan Blake'),
  ];

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        const LqSection(
          title: 'Sizes',
          caption: 'Initials sit on a tint picked from the name, so the same '
              'driver always gets the same color.',
          children: [
            Wrap(
              spacing: LqSpace.x3,
              runSpacing: LqSpace.x3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                LqAvatar(name: 'Maya Chen', size: LqAvatarSize.xs),
                LqAvatar(name: 'Maya Chen', size: LqAvatarSize.small),
                LqAvatar(name: 'Maya Chen'),
                LqAvatar(name: 'Maya Chen', size: LqAvatarSize.large),
                LqAvatar(name: 'Maya Chen', size: LqAvatarSize.xl),
              ],
            ),
          ],
        ),
        const LqSection(
          title: 'Status and icons',
          children: [
            Wrap(
              spacing: LqSpace.x4,
              children: [
                LqAvatar(name: 'Diego Alvarez', status: LqTone.positive),
                LqAvatar(name: 'Priya Natarajan', status: LqTone.caution),
                LqAvatar(name: 'Sam Okafor', status: LqTone.neutral),
                LqAvatar(name: 'Toyota Prius', icon: RemixIcons.car_line),
                LqAvatar(name: 'Fleet', icon: RemixIcons.team_line),
              ],
            ),
          ],
        ),
        LqSection(
          title: 'Groups',
          children: [
            LqListGroup(
              header: 'Bay Area fleet',
              leadingInset: false,
              children: [
                const LqListRow(
                  title: 'Drivers this week',
                  subtitle: '7 drivers · 1,284.6 business mi',
                  trailing: LqAvatarGroup(avatars: _team),
                ),
                LqListRow(
                  title: 'Shared vehicle',
                  subtitle: 'Toyota Prius · 3 drivers',
                  trailing: LqAvatarGroup(
                    avatars: _team.sublist(0, 3),
                    size: LqAvatarSize.xs,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

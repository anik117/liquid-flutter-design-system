import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class BannerDemo extends StatefulWidget {
  const BannerDemo({super.key});

  @override
  State<BannerDemo> createState() => _BannerDemoState();
}

class _BannerDemoState extends State<BannerDemo> {
  int _round = 0;

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Tones',
          caption: 'Warnings are amber; red is only for real failures.',
          children: [
            const LqBanner(
              title: 'Sync paused while offline',
              message: 'Drives are saved on this phone and sync when you are back online.',
              tone: LqTone.caution,
              icon: RemixIcons.wifi_off_line,
            ),
            const LqBanner(
              title: 'IRS rate updated for 2026',
              message: 'New drives use 72.5¢ per mile.',
            ),
            const LqBanner(title: 'Q3 report exported', tone: LqTone.positive),
            LqBanner(
              title: 'Receipt upload failed',
              message: 'Shell, Oct 14 · \$48.20',
              tone: LqTone.danger,
              actionLabel: 'Retry upload',
              onAction: () => LqToast.show(
                context,
                'Uploading receipt…',
                icon: RemixIcons.upload_cloud_2_line,
                clearance: 0,
              ),
            ),
          ],
        ),
        LqSection(
          title: 'Dismissible',
          caption: 'Collapses out of the page when closed.',
          trailing: LqButton(
            label: 'Reset',
            variant: LqButtonVariant.plain,
            size: LqButtonSize.small,
            onPressed: () => setState(() => _round++),
          ),
          children: [
            LqBanner(
              key: ValueKey('a$_round'),
              title: '3 drives need a purpose',
              message:
                  'Add a business purpose so they count toward Schedule C.',
              tone: LqTone.caution,
              actionLabel: 'Review drives',
              onAction: () {},
              onDismiss: () {},
            ),
            LqBanner(
              key: ValueKey('b$_round'),
              title: 'Auto-detect is on',
              message: 'Drives over 0.5 mi are logged for you.',
              tone: LqTone.accent,
              onDismiss: () {},
            ),
          ],
        ),
      ],
    );
  }
}

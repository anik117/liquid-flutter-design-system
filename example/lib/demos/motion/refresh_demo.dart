import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';
import 'drive_data.dart';

class RefreshDemo extends StatefulWidget {
  const RefreshDemo({super.key});

  @override
  State<RefreshDemo> createState() => _RefreshDemoState();
}

class _RefreshDemoState extends State<RefreshDemo> {
  // Each refresh "syncs" one newer drive onto the top of the list.
  int _synced = 4;
  String _status = 'Synced 2 min ago';

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() {
      _synced = _synced >= demoDrives.length ? 4 : _synced + 1;
      _status = 'Synced just now';
    });
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final drives = demoDrives.sublist(demoDrives.length - _synced);
    return DemoColumn(
      children: [
        LqSection(
          title: 'Pull to sync drives',
          caption: 'Pull the list down past the ring and let go. iOS bouncing physics.',
          children: [
            Container(
              height: 360,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(lq.radius.lg),
                border: Border.all(color: c.border, width: 0.5),
              ),
              child: LqRefresh(
                onRefresh: _refresh,
                semanticLabel: 'Sync drives',
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemCount: drives.length + 1,
                  separatorBuilder: (_, i) => Container(
                    height: 0.5,
                    margin: const EdgeInsets.only(left: LqSpace.x4),
                    color: c.separator,
                  ),
                  itemBuilder: (context, i) => i == 0
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(LqSpace.x4, LqSpace.x3, LqSpace.x4, LqSpace.x2),
                          child: Text(_status,
                              style: lq.type.footnote.copyWith(color: c.textSecondary)),
                        )
                      : DemoDriveRow(drive: drives[i - 1]),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

enum _DriveAction { edit, duplicate, personal, delete }

class ActionSheetDemo extends StatelessWidget {
  const ActionSheetDemo({super.key});

  Future<void> _open(BuildContext context) async {
    final action = await showLqActionSheet<_DriveAction>(
      context,
      title: 'Downtown → Airport',
      message: r'Oct 14 · 18.4 mi · $13.34 deduction',
      actions: const [
        LqSheetAction(
          label: 'Edit drive',
          value: _DriveAction.edit,
          icon: RemixIcons.edit_line,
        ),
        LqSheetAction(
          label: 'Duplicate',
          value: _DriveAction.duplicate,
          icon: RemixIcons.file_copy_line,
        ),
        LqSheetAction(
          label: 'Mark as personal',
          value: _DriveAction.personal,
          icon: RemixIcons.user_line,
        ),
        LqSheetAction(
          label: 'Delete drive',
          value: _DriveAction.delete,
          icon: RemixIcons.delete_bin_line,
          destructive: true,
        ),
      ],
    );
    if (action == null || !context.mounted) return;
    final text = switch (action) {
      _DriveAction.edit => 'Opening editor',
      _DriveAction.duplicate => 'Drive duplicated',
      _DriveAction.personal => 'Marked as personal',
      _DriveAction.delete => 'Drive deleted',
    };
    LqToast.show(context, text, icon: RemixIcons.check_line, clearance: 0);
  }

  @override
  Widget build(BuildContext context) {
    return DemoColumn(
      children: [
        LqSection(
          title: 'Drive actions',
          caption: 'Rises on a spring; Cancel sits apart near the thumb.',
          children: [
            LqListGroup(
              children: [
                LqListRow(
                  title: 'Downtown → Airport',
                  subtitle: 'Uber · 8:42 AM · 18.4 mi',
                  leading: const LqIconTile(icon: RemixIcons.car_line),
                  trailing: const LqBadge(
                    label: 'Business',
                    tone: LqTone.accent,
                  ),
                  onTap: () => _open(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

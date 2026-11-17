import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

import '../demo_column.dart';

class DialogDemo extends StatelessWidget {
  const DialogDemo({super.key});

  Future<void> _delete(BuildContext context) async {
    final choice = await showLqDialog<bool>(
      context,
      title: 'Delete this drive?',
      message: r'Downtown → Airport, 18.4 mi. Its $13.34 deduction comes off your Q3 total.',
      actions: const [
        LqDialogAction(label: 'Cancel', value: false),
        LqDialogAction(label: 'Delete', value: true, destructive: true),
      ],
    );
    if (choice == true && context.mounted) {
      LqToast.show(
        context,
        'Drive deleted',
        icon: RemixIcons.delete_bin_line,
        clearance: 0,
      );
    }
  }

  Future<void> _classify(BuildContext context) async {
    final choice = await showLqDialog<String>(
      context,
      title: 'Was this drive for work?',
      message: 'Market St → Oakland, 12.7 mi on Tuesday at 6:10 PM.',
      actions: const [
        LqDialogAction(
          label: 'Business · Uber',
          value: 'Business',
          primary: true,
        ),
        LqDialogAction(label: 'Personal', value: 'Personal'),
        LqDialogAction(label: 'Decide later', value: 'Later'),
      ],
    );
    if (choice != null && context.mounted) {
      LqToast.show(
        context,
        'Marked as $choice',
        icon: RemixIcons.check_line,
        clearance: 0,
      );
    }
  }

  Future<void> _export(BuildContext context) => showLqDialog<void>(
    context,
    title: 'Report ready',
    message: 'Your 2026 Schedule C mileage log is in Files.',
    actions: const [LqDialogAction(label: 'Done', value: null, primary: true)],
  );

  @override
  Widget build(BuildContext context) {
    Widget open(String label, Future<void> Function(BuildContext) show) =>
        LqButton(
          label: label,
          variant: LqButtonVariant.secondary,
          expand: true,
          onPressed: () => show(context),
        );
    return DemoColumn(
      children: [
        LqSection(
          title: 'Alerts',
          caption: 'Thick glass; springs in, leaves quicker. Tap the scrim to cancel.',
          children: [
            open('Destructive · side by side', _delete),
            open('Three choices · stacked', _classify),
            open('One action', _export),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp;

Widget _app(Widget child, {Brightness b = .light, TargetPlatform? p}) {
  final lq = LqThemeData(brand: .vaultMileage, brightness: b, platform: p);
  return MaterialApp(
    home: LqScope(
      data: lq,
      child: ColoredBox(color: lq.colors.canvas, child: child),
    ),
  );
}

/// A page with one "Open" button that runs [open].
Widget _opener(void Function(BuildContext) open, {Brightness b = .light}) =>
    _app(
      b: b,
      Builder(
        builder: (c) => LqButton(label: 'Open', onPressed: () => open(c)),
      ),
    );

void main() {
  testWidgets('feedback components build in light and dark', (tester) async {
    for (final b in Brightness.values) {
      for (final p in [TargetPlatform.iOS, TargetPlatform.android]) {
        await tester.pumpWidget(
          _app(
            b: b,
            p: p,
            ListView(
              children: [
                const LqBanner(title: 'Sync paused', tone: .caution),
                const LqProgressBar(value: 0.4),
                const LqProgressBar(),
                const LqProgressRing(value: 0.72, child: Text('72%')),
                const LqSpinner(),
                const LqSkeleton.row(),
                const LqSkeleton.line(width: 120),
                const LqSkeleton.circle(),
                LqEmptyState(
                  icon: RemixIcons.steering_2_line,
                  title: 'No drives yet',
                  actionLabel: 'Start your first drive',
                  onAction: () {},
                ),
                LqCountBadge(count: 3, child: const SizedBox(height: 44)),
                const LqTooltip(message: 'Export', child: Text('Icon')),
              ],
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));
        expect(find.text('Sync paused'), findsOneWidget);
        expect(find.text('72%'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('banner collapses and reports dismissal', (tester) async {
    var dismissed = false;
    await tester.pumpWidget(
      _app(
        Column(
          children: [
            LqBanner(
              title: 'Sync paused while offline',
              onDismiss: () => dismissed = true,
            ),
          ],
        ),
      ),
    );
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Dismiss'), findsOneWidget);
    semantics.dispose();
    await tester.tap(find.byIcon(RemixIcons.close_line));
    await tester.pumpAndSettle();
    expect(find.text('Sync paused while offline'), findsNothing);
    expect(dismissed, isTrue);
  });

  testWidgets('count badge hides at 0', (tester) async {
    Widget badge(int n) => _app(
      LqCountBadge(count: n, child: const SizedBox.square(dimension: 44)),
    );
    await tester.pumpWidget(badge(0));
    expect(find.text('0'), findsNothing);
    await tester.pumpWidget(badge(5));
    await tester.pumpAndSettle();
    expect(find.text('5'), findsOneWidget);
    await tester.pumpWidget(badge(0));
    await tester.pumpAndSettle();
    expect(find.text('5'), findsNothing);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('dialog returns the tapped action', (tester) async {
    for (final b in Brightness.values) {
      String? result;
      await tester.pumpWidget(
        _opener(b: b, (context) async {
          result = await showLqDialog<String>(
            context,
            title: 'Delete this drive?',
            message: r'Its 18.4 mi and $12.97 deduction will be removed.',
            actions: const [
              LqDialogAction(label: 'Cancel', value: 'cancel'),
              LqDialogAction(
                label: 'Delete',
                value: 'delete',
                destructive: true,
              ),
            ],
          );
        }),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Delete this drive?'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(result, 'delete');
      expect(find.text('Delete this drive?'), findsNothing);
    }
  });

  testWidgets('action sheet returns the tapped action', (tester) async {
    String? result;
    await tester.pumpWidget(
      _opener((context) async {
        result = await showLqActionSheet<String>(
          context,
          actions: const [
            LqSheetAction(label: 'Duplicate', value: 'dup'),
            LqSheetAction(label: 'Delete', value: 'del', destructive: true),
          ],
        );
      }),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicate'));
    await tester.pumpAndSettle();
    expect(result, 'dup');
  });

  testWidgets('menu morphs open, picks and closes', (tester) async {
    for (final b in Brightness.values) {
      String? picked;
      await tester.pumpWidget(
        _app(
          b: b,
          Align(
            alignment: Alignment.topRight,
            child: LqMenuButton<String>(
              semanticLabel: 'Sort drives',
              onSelected: (v) => picked = v,
              entries: const [
                LqMenuHeader('Sort by'),
                LqMenuItem(label: 'Date', value: 'date', checked: true),
                LqMenuItem(label: 'Distance', value: 'distance'),
                LqMenuDivider(),
                LqMenuItem(label: 'Delete', value: 'd', destructive: true),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.bySemanticsLabel('Sort drives'));
      await tester.pumpAndSettle();
      expect(find.text('Distance'), findsOneWidget);
      await tester.tap(find.text('Distance'));
      await tester.pumpAndSettle();
      expect(picked, 'distance');
      expect(find.text('Distance'), findsNothing);

      // Tapping outside folds it back without picking.
      picked = null;
      await tester.tap(find.bySemanticsLabel('Sort drives'));
      await tester.pumpAndSettle();
      expect(find.text('Date'), findsOneWidget);
      await tester.tapAt(const Offset(20, 500));
      await tester.pumpAndSettle();
      expect(find.text('Date'), findsNothing);
      expect(picked, isNull);
      expect(tester.takeException(), isNull);
    }
  });
}

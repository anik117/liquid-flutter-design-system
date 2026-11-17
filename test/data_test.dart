import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
}) {
  final lq = LqThemeData(brand: LqBrand.vaultMileage, brightness: brightness);
  return tester.pumpWidget(
    MaterialApp(
      home: LqScope(
        data: lq,
        child: ColoredBox(
          color: lq.colors.canvas,
          child: ListView(
            padding: const EdgeInsets.all(LqSpace.gutter),
            children: [child],
          ),
        ),
      ),
    ),
  );
}

Widget _driveRow({VoidCallback? onDelete, VoidCallback? onPersonal, VoidCallback? onBusiness}) =>
    LqSwipeRow(
      leadingActions: [
        LqSwipeAction(
          label: 'Business',
          icon: RemixIcons.briefcase_4_fill,
          tone: LqTone.accent,
          onTap: onBusiness ?? () {},
        ),
      ],
      trailingActions: [
        LqSwipeAction(
          label: 'Delete',
          icon: RemixIcons.delete_bin_fill,
          tone: LqTone.danger,
          onTap: onDelete ?? () {},
        ),
        LqSwipeAction(
          label: 'Personal',
          icon: RemixIcons.user_3_fill,
          onTap: onPersonal ?? () {},
        ),
      ],
      child: const LqListRow(title: 'Mission District → SoMa', value: '6.4 mi'),
    );

void main() {
  testWidgets('data components build in light and dark', (tester) async {
    for (final b in Brightness.values) {
      await _pump(
        tester,
        brightness: b,
        Column(
          children: [
            LqSwipeGroup(child: _driveRow()),
            const LqAvatarGroup(avatars: [
              LqAvatar(name: 'Maya Chen', status: LqTone.positive),
              LqAvatar(name: 'Diego Alvarez'),
              LqAvatar(name: 'Priya Natarajan'),
              LqAvatar(name: 'Sam Okafor'),
              LqAvatar(name: 'Lena Fischer'),
            ]),
            const LqAvatar(name: 'Toyota Prius', icon: RemixIcons.car_line),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: LqStatTile(label: 'Deductions', value: 1639.85, prefix: r'$', decimals: 2, delta: 12.4, onTap: () {})),
                  const Expanded(child: LqStatTile(label: 'Drives', value: 86, delta: -4, deltaSuffix: '')),
                ],
              ),
            ),
            const LqDisclosure(title: 'How is my deduction calculated?', child: Text('Miles × rate')),
            const LqKeyValueList(
              items: [LqKeyValue('Business miles', '7,905.2 mi'), LqKeyValue('Rate', '76¢/mi')],
              total: LqKeyValue('Deduction', r'$6,007.95'),
            ),
            const LqTimeline(current: 1, events: [
              LqTimelineEvent(title: 'Started', time: '6:12 PM', body: 'Mission District'),
              LqTimelineEvent(title: 'Stop', body: 'DoorDash pickup', icon: RemixIcons.takeaway_line),
              LqTimelineEvent(title: 'Ended', time: '6:41 PM'),
            ]),
            LqCarousel(itemCount: 3, height: 120, itemBuilder: (_, i) => LqCard(child: Text('Vehicle $i'))),
            LqCalendarStrip(selected: DateTime(2026, 11, 17), onChanged: (_) {}),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Business miles'), findsOneWidget);
      expect(find.text('+2'), findsOneWidget);
      expect(find.text('Vehicle 0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('swipe row reveals actions and runs the tapped one', (tester) async {
    var personal = 0;
    await _pump(tester, _driveRow(onPersonal: () => personal++));
    expect(find.text('Personal'), findsNothing);

    await tester.drag(find.text('Mission District → SoMa'), const Offset(-140, 0));
    await tester.pumpAndSettle();
    expect(find.text('Personal'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Personal'));
    await tester.pumpAndSettle();
    expect(personal, 1);
    expect(find.text('Personal'), findsNothing);

    await tester.drag(find.text('Mission District → SoMa'), const Offset(140, 0));
    await tester.pumpAndSettle();
    expect(find.text('Business'), findsOneWidget);
  });

  testWidgets('a full swipe runs the first action with a firm haptic', (tester) async {
    final haptics = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') haptics.add('${call.arguments}');
        return null;
      },
    );
    var deleted = 0;
    await _pump(tester, _driveRow(onDelete: () => deleted++));
    await tester.drag(find.text('Mission District → SoMa'), const Offset(-700, 0));
    await tester.pumpAndSettle();
    expect(deleted, 1);
    expect(haptics, contains('HapticFeedbackType.mediumImpact'));
  });

  testWidgets('disclosure expands, and an exclusive group keeps one open', (tester) async {
    await _pump(
      tester,
      const LqDisclosureGroup(exclusive: true, children: [
        LqDisclosure(title: 'How is my deduction calculated?', child: Text('Business miles × 76¢')),
        LqDisclosure(title: 'Does my commute count?', child: Text('No, commuting is personal')),
      ]),
    );
    expect(find.text('Business miles × 76¢'), findsNothing);

    await tester.tap(find.text('How is my deduction calculated?'));
    await tester.pumpAndSettle();
    expect(find.text('Business miles × 76¢'), findsOneWidget);

    await tester.tap(find.text('Does my commute count?'));
    await tester.pumpAndSettle();
    expect(find.text('No, commuting is personal'), findsOneWidget);
    expect(find.text('Business miles × 76¢'), findsNothing);
  });

  testWidgets('calendar strip selects a tapped day', (tester) async {
    DateTime? picked;
    await _pump(
      tester,
      LqCalendarStrip(
        selected: DateTime(2026, 11, 17),
        today: DateTime(2026, 11, 17),
        hasDrives: (d) => d.day.isOdd,
        onChanged: (d) => picked = d,
      ),
    );
    await tester.tap(find.text('19'));
    await tester.pumpAndSettle();
    expect(picked, DateTime(2026, 11, 19));
    expect(find.text('16'), findsOneWidget); // week starts Monday the 16th
  });

  testWidgets('avatar shows initials from the name', (tester) async {
    await _pump(tester, const LqAvatar(name: 'Maya Chen'));
    expect(find.text('MC'), findsOneWidget);
    expect(LqAvatar.initials('sam'), 'S');
    expect(LqAvatar.initials('  Diego  de la Vega '), 'DV');
    final c = LqColors.resolve(LqBrand.vaultMileage, Brightness.light);
    expect(LqAvatar.tintFor(c, 'Maya Chen'), LqAvatar.tintFor(c, 'Maya Chen'));
  });
}

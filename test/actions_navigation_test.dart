import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';
import 'package:material_ui/material_ui.dart';

Widget _app(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      home: LqScope(
        data: LqThemeData(brand: LqBrand.vaultMileage, brightness: brightness),
        child: Center(child: child),
      ),
    );

void main() {
  testWidgets('every component builds in light and dark', (tester) async {
    for (final b in Brightness.values) {
      final pages = PageController();
      await tester.pumpWidget(_app(
        brightness: b,
        SingleChildScrollView(
          child: Column(
            children: [
              LqChip.filter(label: 'Uber', selected: true, onSelected: (_) {}),
              LqChip.input(label: 'Airport run', onRemoved: () {}),
              LqChipGroup<String>(
                options: const [
                  LqChipOption(value: 'a', label: 'DoorDash'),
                  LqChipOption(value: 'b', label: 'Lyft'),
                ],
                selected: const {'a'},
                onChanged: (_) {},
              ),
              LqButtonGroup(items: [
                LqButtonGroupItem(label: 'Day', onPressed: () {}),
                LqButtonGroupItem(label: 'Week', onPressed: () {}),
              ], selectedIndex: 0),
              LqToolbar(
                actions: [
                  LqToolbarAction(icon: RemixIcons.share_line, semanticLabel: 'Share', onPressed: () {}),
                  LqToolbarAction(icon: RemixIcons.delete_bin_line, semanticLabel: 'Delete', destructive: true, onPressed: () {}),
                ],
                textAction: 'Done',
                onTextAction: () {},
              ),
              LqFab(icon: RemixIcons.steering_2_fill, label: 'Start drive', onPressed: () {}),
              LqFab(icon: RemixIcons.add_line, semanticLabel: 'Add', glass: true, onPressed: () {}),
              LqTabs(tabs: const ['Drives', 'Fuel'], index: 0, onChanged: (_) {}, style: LqTabsStyle.underline),
              SizedBox(
                height: 120,
                child: PageView(controller: pages, children: const [Text('1'), Text('2')]),
              ),
              LqPageDots(count: 2, controller: pages),
              const LqBackButton(),
              const LqBackButton(title: 'Drives'),
            ],
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Uber'), findsOneWidget);
      expect(find.text('Start drive'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('filter chip toggles', (tester) async {
    var on = false;
    await tester.pumpWidget(_app(StatefulBuilder(
      builder: (context, setState) => LqChip.filter(
        label: 'Instacart',
        selected: on,
        onSelected: (v) => setState(() => on = v),
      ),
    )));
    await tester.tap(find.text('Instacart'));
    await tester.pumpAndSettle();
    expect(on, isTrue);
    await tester.tap(find.text('Instacart'));
    await tester.pumpAndSettle();
    expect(on, isFalse);
  });

  testWidgets('input chip collapses then reports removal', (tester) async {
    var removed = false;
    await tester.pumpWidget(_app(
      LqChip.input(label: 'Airport run', onRemoved: () => removed = true),
    ));
    await tester.tap(find.bySemanticsLabel('Remove Airport run'));
    await tester.pumpAndSettle();
    expect(removed, isTrue);
  });

  testWidgets('chip group single select keeps exactly one', (tester) async {
    var picked = {'uber'};
    await tester.pumpWidget(_app(StatefulBuilder(
      builder: (context, setState) => LqChipGroup<String>(
        options: const [
          LqChipOption(value: 'uber', label: 'Uber'),
          LqChipOption(value: 'lyft', label: 'Lyft'),
        ],
        selected: picked,
        onChanged: (v) => setState(() => picked = v),
      ),
    )));
    await tester.tap(find.text('Lyft'));
    await tester.pumpAndSettle();
    expect(picked, {'lyft'});
    await tester.tap(find.text('Lyft'));
    await tester.pumpAndSettle();
    expect(picked, {'lyft'});
  });

  testWidgets('tabs switch on tap and move the page', (tester) async {
    var index = 0;
    await tester.pumpWidget(_app(StatefulBuilder(
      builder: (context, setState) => SizedBox(
        height: 300,
        child: LqTabs(
          tabs: const ['Drives', 'Fuel', 'Service', 'Compliance'],
          index: index,
          onChanged: (i) => setState(() => index = i),
          pages: const [Text('drives page'), Text('fuel page'), Text('service page'), Text('compliance page')],
        ),
      ),
    )));
    expect(find.text('drives page'), findsOneWidget);
    await tester.tap(find.text('Fuel'));
    await tester.pumpAndSettle();
    expect(index, 1);
    expect(find.text('fuel page'), findsOneWidget);
  });

  testWidgets('page dots follow the controller', (tester) async {
    final pages = PageController();
    await tester.pumpWidget(_app(Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView(controller: pages, children: const [Text('a'), Text('b'), Text('c')]),
        ),
        LqPageDots(count: 3, controller: pages),
      ],
    )));
    expect(find.bySemanticsLabel('Page 1 of 3'), findsOneWidget);
    pages.jumpToPage(2);
    await tester.pump();
    expect(find.bySemanticsLabel('Page 3 of 3'), findsOneWidget);
  });

  testWidgets('FAB folds to a circle when not extended', (tester) async {
    Widget fab(bool extended) => _app(LqFab(
      icon: RemixIcons.steering_2_fill,
      label: 'Start drive',
      extended: extended,
      onPressed: () {},
    ));
    await tester.pumpWidget(fab(true));
    final wide = tester.getSize(find.byType(LqFab)).width;
    await tester.pumpWidget(fab(false));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(LqFab)).width, 56);
    expect(wide, greaterThan(56));
  });

  testWidgets('back button pops the nearest navigator', (tester) async {
    await tester.pumpWidget(_app(Builder(
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).push(PageRouteBuilder<void>(
          pageBuilder: (_, _, _) => LqScope(
            data: LqThemeData(brand: LqBrand.vaultMileage, brightness: Brightness.light),
            child: const Center(child: LqBackButton(title: 'Drives')),
          ),
        )),
        child: const Text('Open'),
      ),
    )));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Back to Drives'), findsOneWidget);
    await tester.tap(find.byType(LqBackButton));
    await tester.pumpAndSettle();
    expect(find.text('Open'), findsOneWidget);
    expect(find.byType(LqBackButton), findsNothing);
  });
}

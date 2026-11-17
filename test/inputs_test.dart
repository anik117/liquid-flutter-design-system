import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoDatePicker, CupertinoPicker;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp;

Widget _host(
  Widget child, {
  Brightness brightness = Brightness.light,
  TargetPlatform platform = TargetPlatform.android,
}) {
  final lq = LqThemeData(
    brand: LqBrand.vaultMileage,
    brightness: brightness,
    platform: platform,
  );
  return MaterialApp(
    theme: lq.toMaterialTheme(),
    home: LqScope(
      data: lq,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(LqSpace.gutter),
        child: child,
      ),
    ),
  );
}

/// Hosts a controlled component whose value lives in the test.
Widget _live(Widget Function(StateSetter set) build) =>
    _host(StatefulBuilder(builder: (_, set) => build(set)));

const _methods = [
  LqRadioOption(value: 'standard', label: 'Standard mileage'),
  LqRadioOption(value: 'actual', label: 'Actual expenses', description: 'Gas, repairs'),
];
const _vehicles = [
  LqSelectOption(value: 'prius', label: '2022 Toyota Prius'),
  LqSelectOption(value: 'civic', label: '2019 Honda Civic'),
];

void main() {
  testWidgets('every input builds in light and dark', (tester) async {
    for (final b in Brightness.values) {
      await tester.pumpWidget(_host(
        brightness: b,
        Column(children: [
          const LqTextArea(label: 'Trip notes', maxLength: 280),
          const LqSearchField(placeholder: 'Search drives'),
          LqStepper(value: 1, onChanged: (_) {}, semanticLabel: 'Passengers'),
          LqSlider(value: 0.5, onChanged: (_) {}, divisions: 20, showValueLabel: true),
          LqRadioGroup<String>(value: 'standard', onChanged: (_) {}, options: _methods),
          LqRadio(selected: false, onSelected: () {}, label: 'Personal'),
          LqSelect<String>(value: 'prius', onChanged: (_) {}, options: _vehicles),
          LqDateField(value: DateTime(2026, 11, 17), onChanged: (_) {}),
          LqTimeField(value: DateTime(2026, 11, 17, 18, 41), onChanged: (_) {}),
          const LqOtpField(label: 'Sign-in code'),
        ]),
      ));
      expect(find.text('2022 Toyota Prius'), findsOneWidget);
      expect(find.text('Tue, Nov 17, 2026'), findsOneWidget);
      expect(find.text('6:41 PM'), findsOneWidget);
      expect(find.text('0 / 280'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  test('LqDateFormat formats without intl', () {
    expect(LqDateFormat.date(DateTime(2026, 11, 16)), 'Mon, Nov 16, 2026');
    expect(LqDateFormat.time(DateTime(2026, 1, 1, 0, 5)), '12:05 AM');
    expect(LqDateFormat.time(DateTime(2026, 1, 1, 18, 41), use24h: true), '18:41');
  });

  testWidgets('stepper steps and stops at its bounds', (tester) async {
    double value = 3;
    await tester.pumpWidget(_live((set) =>
        LqStepper(value: value, max: 4, onChanged: (v) => set(() => value = v))));
    Future<void> tap(IconData icon) async {
      await tester.tap(find.byIcon(icon));
      await tester.pumpAndSettle();
    }

    await tap(RemixIcons.add_line);
    expect(value, 4);
    await tap(RemixIcons.add_line);
    expect(value, 4);
    await tap(RemixIcons.subtract_line);
    expect(value, 3);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('stepper repeats while held', (tester) async {
    double value = 0;
    await tester.pumpWidget(_live((set) =>
        LqStepper(value: value, onChanged: (v) => set(() => value = v))));
    final g = await tester.startGesture(tester.getCenter(find.byIcon(RemixIcons.add_line)));
    await tester.pump(const Duration(milliseconds: 600));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await g.up();
    await tester.pumpAndSettle();
    expect(value, greaterThan(5));
  });

  testWidgets('radio group selects the tapped option', (tester) async {
    String value = 'standard';
    await tester.pumpWidget(_live((set) => LqRadioGroup<String>(
          value: value,
          options: _methods,
          onChanged: (v) => set(() => value = v),
        )));
    await tester.tap(find.text('Actual expenses'));
    await tester.pumpAndSettle();
    expect(value, 'actual');
  });

  testWidgets('slider drag changes the value and snaps to a division', (tester) async {
    double value = 50;
    await tester.pumpWidget(_live((set) => LqSlider(
          value: value,
          max: 100,
          divisions: 20,
          onChanged: (v) => set(() => value = v),
        )));
    await tester.drag(find.byType(LqSlider), const Offset(120, 0));
    await tester.pumpAndSettle();
    expect(value, greaterThan(50));
    expect(value % 5, 0);
  });

  testWidgets('select picks from the Android list sheet', (tester) async {
    String? value;
    await tester.pumpWidget(_live((set) => LqSelect<String>(
          value: value,
          options: _vehicles,
          onChanged: (v) => set(() => value = v),
        )));
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2019 Honda Civic'));
    await tester.pumpAndSettle();
    expect(value, 'civic');
  });

  testWidgets('select and date field open wheels on iOS', (tester) async {
    String? vehicle;
    DateTime? date;
    await tester.pumpWidget(_host(
      platform: TargetPlatform.iOS,
      Column(children: [
        LqSelect<String>(value: null, onChanged: (v) => vehicle = v, options: _vehicles),
        LqDateField(value: null, placeholder: 'Trip date', onChanged: (d) => date = d),
      ]),
    ));
    await tester.tap(find.text('Select'));
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoPicker), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(vehicle, 'prius');

    await tester.tap(find.text('Trip date'));
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoDatePicker), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(date, isNotNull);
  });

  testWidgets('OTP field filters to digits and completes', (tester) async {
    String? code;
    await tester.pumpWidget(_host(LqOtpField(onCompleted: (c) => code = c)));
    await tester.enterText(find.byType(EditableText), '12a3456789');
    // The caret blinks while focused, so the tree never settles.
    await tester.pump(const Duration(milliseconds: 400));
    expect(code, '123456');
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('search field shows Cancel while searching', (tester) async {
    String? query;
    await tester.pumpWidget(_host(LqSearchField(onChanged: (q) => query = q)));
    expect(find.text('Cancel'), findsNothing);
    await tester.enterText(find.byType(EditableText), 'airport');
    await tester.pumpAndSettle();
    expect((query, find.text('Cancel').evaluate().length), ('airport', 1));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(query, '');
    expect(find.text('Cancel'), findsNothing);
  });

  testWidgets('text area counts characters', (tester) async {
    await tester.pumpWidget(_host(const LqTextArea(maxLength: 20)));
    await tester.enterText(find.byType(EditableText), 'Airport run, SFO');
    await tester.pump();
    expect(find.text('16 / 20'), findsOneWidget);
  });
}

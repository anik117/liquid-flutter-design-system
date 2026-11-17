import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';
import 'package:material_ui/material_ui.dart';

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
const _deductions = <double>[512, 486, 603, 571, 644, 702, 689, 731, 598, 655, 421];

Widget _host(Widget child, {Brightness brightness = Brightness.light}) => MaterialApp(
  home: LqScope(
    data: LqThemeData(brand: LqBrand.vaultMileage, brightness: brightness),
    child: child,
  ),
);

Widget _scroll(List<Widget> children) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final c in children) ...[c, const SizedBox(height: 24)],
    ],
  ),
);

List<Widget> _charts() => [
  LqChartCard(
    title: 'Deductions',
    value: 6612,
    prefix: r'$',
    delta: '6% vs 2025',
    periods: const ['Week', 'Month', 'Year'],
    period: 'Year',
    onPeriodChanged: (_) {},
    chart: const LqBarChart(values: _deductions, labels: _months, highlighted: 10),
  ),
  const LqStackedBarChart(labels: _months, series: [
    LqChartSeries(label: 'Business', values: _deductions),
    LqChartSeries(label: 'Personal', values: _deductions, tone: LqTone.neutral),
  ]),
  const LqStackedBarChart(grouped: true, labels: _months, series: [
    LqChartSeries(label: '2026', values: _deductions),
    LqChartSeries(label: '2025', values: _deductions, tone: LqTone.neutral),
  ]),
  const LqLineChart(values: _deductions, comparison: _deductions, labels: [..._months, 'Dec']),
  const LqAreaChart(labels: _months, series: [
    LqChartSeries(label: 'Business', values: _deductions),
    LqChartSeries(label: 'Personal', values: _deductions, tone: LqTone.info),
  ]),
  const LqMultiLineChart(labels: _months, series: [
    LqChartSeries(label: 'DoorDash', values: _deductions),
    LqChartSeries(label: 'Uber', values: _deductions, tone: LqTone.info, dashed: true),
  ]),
  const LqSparkline(values: [3, 5, 4, 8, 6, 9]),
  const LqRingChart(center: Text('9,755'), segments: [
    LqRingSegment(label: 'Business', value: 7905),
    LqRingSegment(label: 'Personal', value: 1210, tone: LqTone.neutral),
    LqRingSegment(label: 'Commute', value: 640, tone: LqTone.caution),
  ]),
  const LqHorizontalBarChart(items: [
    LqBarItem(label: 'DoorDash', value: 1.32),
    LqBarItem(label: 'Uber', value: 0.71),
  ]),
  const LqGaugeChart(value: 1240, target: 1800, prefix: r'$', cautionAbove: 1500),
  LqHeatmap(values: List.filled(79, 3), end: DateTime(2026, 11, 17)),
  const LqProgressBarList(items: [
    LqProgressItem(label: 'Fuel', value: 342, target: 320),
    LqProgressItem(label: 'Miles', value: 7905, target: 8500, overIsGood: true),
  ]),
  LqChartLegend(entries: const [LqLegendEntry(label: 'Business', color: Color(0xFF1B8A64))]),
];

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('charts and motion build and settle in ${brightness.name}', (tester) async {
      await tester.pumpWidget(_host(
        _scroll([
          ..._charts(),
          const LqStagger(children: [Text('Airport run'), Text('Uptown')]),
          const LqCounter(value: 48981.6, decimals: 1, suffix: 'mi'),
          SizedBox(
            height: 200,
            child: LqRefresh(
              onRefresh: () async {},
              child: ListView(children: const [Text('Drive 1'), Text('Drive 2')]),
            ),
          ),
        ]),
        brightness: brightness,
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Airport run'), findsOneWidget);
    });
  }

  testWidgets('tapping a bar picks it and shows its value', (tester) async {
    int? picked;
    await tester.pumpWidget(_host(Center(
      child: SizedBox(
        width: 330,
        child: LqBarChart(
          values: _deductions,
          labels: _months,
          valueLabel: (v) => '\$${v.round()}',
          onSelected: (i) => picked = i,
        ),
      ),
    )));
    await tester.pumpAndSettle();
    // Slot 2 of 11 is March.
    final box = tester.getRect(find.byType(LqBarChart));
    await tester.tapAt(Offset(box.left + 330 / 11 * 2.5, box.center.dy));
    await tester.pumpAndSettle();
    expect(picked, 2);
    expect(find.byType(LqChartPill), findsOneWidget);
    // Tapping it again clears the pick.
    await tester.tapAt(Offset(box.left + 330 / 11 * 2.5, box.center.dy));
    await tester.pumpAndSettle();
    expect(picked, isNull);
  });

  testWidgets('line chart scrubs and clears on release', (tester) async {
    final seen = <int?>[];
    await tester.pumpWidget(_host(Center(
      child: SizedBox(
        width: 330,
        child: LqLineChart(values: _deductions, labels: _months, onSelected: seen.add),
      ),
    )));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(LqLineChart), const Offset(120, 0));
    await tester.pumpAndSettle();
    expect(seen.whereType<int>(), isNotEmpty);
    expect(seen.last, isNull);
  });

  testWidgets('counter shows the new value after an update', (tester) async {
    final semantics = tester.ensureSemantics();
    var miles = 48981.6;
    late StateSetter set;
    await tester.pumpWidget(_host(StatefulBuilder(builder: (context, setState) {
      set = setState;
      return Center(child: LqCounter(value: miles, decimals: 1, suffix: 'mi'));
    })));
    expect(find.bySemanticsLabel('48,981.6 mi'), findsOneWidget);
    set(() => miles += 18.2);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('48,999.8 mi'), findsOneWidget);
    semantics.dispose();
  });

  for (final physics in const [ClampingScrollPhysics(), BouncingScrollPhysics()]) {
    testWidgets('pulling past the threshold refreshes (${physics.runtimeType})', (tester) async {
      var refreshed = 0;
      await tester.pumpWidget(_host(LqRefresh(
        onRefresh: () async => refreshed++,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(parent: physics),
          children: [for (var i = 0; i < 30; i++) Text('Drive $i')],
        ),
      )));
      await tester.drag(find.byType(ListView), const Offset(0, 40));
      await tester.pumpAndSettle();
      expect(refreshed, 0, reason: 'a short pull does not refresh');
      await tester.drag(find.byType(ListView), const Offset(0, 320));
      await tester.pumpAndSettle();
      expect(refreshed, 1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Reduce Motion shows final states and summarizes bars', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_host(MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: _scroll(_charts()),
    )));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && (w.properties.value ?? '').contains('Highest Aug'),
      ),
      findsWidgets,
    );
    semantics.dispose();
  });
}

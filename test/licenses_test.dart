import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

void main() {
  testWidgets('LqScope adds the BoardUI notice to the licence page', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: LqScope(
          data: LqThemeData(
            brand: LqBrand.vaultMileage,
            brightness: Brightness.light,
          ),
          child: const SizedBox(),
        ),
      ),
    );

    final entries = await tester.runAsync(
      () => LicenseRegistry.licenses.toList(),
    );
    final mine = {
      for (final e in entries!)
        for (final p in e.packages) p: e,
    };

    final boardUi = mine['BoardUI (adapted in Liquid Flutter Design System)'];
    expect(boardUi, isNotNull);

    String text(LicenseEntry e) => e.paragraphs.map((p) => p.text).join('\n');
    expect(text(boardUi!), contains('Mertcan Dundar Esmergul (BoardUI)'));
    expect(text(boardUi), contains('MIT License'));
    expect(mine.keys.where((k) => k.contains('Allo')), isEmpty);
  });
}

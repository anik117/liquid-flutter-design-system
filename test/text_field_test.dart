import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp;

void main() {
  testWidgets('clear button clears the text and keeps focus', (tester) async {
    final controller = TextEditingController(text: 'Mission District');
    String? changed;
    await tester.pumpWidget(
      MaterialApp(
        home: LqScope(
          data: LqThemeData(
            brand: LqBrand.vaultMileage,
            brightness: Brightness.light,
          ),
          child: Center(
            child: LqTextField(
              controller: controller,
              placeholder: 'Start address',
              onChanged: (v) => changed = v,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();
    final clear = find.bySemanticsLabel('Clear text');
    expect(clear, findsOneWidget);

    // Before the fix, the tap landed "outside" the text, unfocused the field
    // and removed the clear button before it could fire.
    await tester.tap(clear);
    await tester.pumpAndSettle();
    expect(controller.text, isEmpty);
    expect(changed, '');
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.focusNode.hasFocus, isTrue);
  });
}

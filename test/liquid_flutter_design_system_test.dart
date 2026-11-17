import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

void main() {
  group('LqAmount.split', () {
    test('groups thousands and keeps the requested decimals', () {
      expect(LqAmount.split(5944.11, 2), ('5,944', '.11'));
      expect(LqAmount.split(1234567.5, 1), ('1,234,567', '.5'));
      expect(LqAmount.split(59, 0), ('59', ''));
    });

    test('marks negatives with a real minus sign', () {
      expect(LqAmount.split(-12.3, 2), ('−12', '.30'));
    });
  });

  group('LqColors', () {
    test('a brand change re-tints the accent but not the neutrals', () {
      final vault = LqColors.resolve(LqBrand.vaultMileage, Brightness.light);
      final indigo = LqColors.resolve(LqBrand.sampleIndigo, Brightness.light);
      expect(vault.accent, isNot(indigo.accent));
      expect(vault.canvas, indigo.canvas);
      expect(vault.textPrimary, indigo.textPrimary);
    });

    test('vault green is the light-mode primary', () {
      final c = LqColors.resolve(LqBrand.vaultMileage, Brightness.light);
      expect(c.accent, const Color(0xFF0D684D));
    });

    test('high contrast strengthens secondary text and borders', () {
      final normal = LqColors.resolve(LqBrand.vaultMileage, Brightness.light);
      final high = LqColors.resolve(
        LqBrand.vaultMileage,
        Brightness.light,
        highContrast: true,
      );
      expect(high.textSecondary, isNot(normal.textSecondary));
      expect(high.border, isNot(normal.border));
    });
  });

  testWidgets('components render under LqScope in both brightnesses', (
    tester,
  ) async {
    for (final brightness in Brightness.values) {
      final lq = LqThemeData(brand: LqBrand.vaultMileage, brightness: brightness);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LqScope(
            data: lq,
            child: Column(
              children: [
                LqButton(label: 'Save trip', onPressed: () {}),
                const LqBadge(label: 'To review', tone: LqTone.caution),
                LqSwitch(value: true, onChanged: (_) {}),
                const LqAmount(value: 5944.11, prefix: r'$'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Save trip'), findsOneWidget);
      expect(find.text('To review'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}

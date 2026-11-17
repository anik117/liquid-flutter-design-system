import 'package:flutter/widgets.dart';
import 'package:liquid_flutter_design_system/liquid_flutter_design_system.dart';

enum GalleryAppearance { system, light, dark }

/// Live theme choices for the preview: brand, appearance and contrast.
class GallerySettingsController extends ChangeNotifier {
  LqBrand _brand = LqBrand.vaultMileage;
  GalleryAppearance _appearance = GalleryAppearance.system;
  bool _highContrast = false;

  LqBrand get brand => _brand;
  GalleryAppearance get appearance => _appearance;
  bool get highContrast => _highContrast;

  set brand(LqBrand value) {
    _brand = value;
    notifyListeners();
  }

  set appearance(GalleryAppearance value) {
    _appearance = value;
    notifyListeners();
  }

  set highContrast(bool value) {
    _highContrast = value;
    notifyListeners();
  }
}

class GallerySettings extends InheritedNotifier<GallerySettingsController> {
  const GallerySettings({
    super.key,
    required GallerySettingsController controller,
    required super.child,
  }) : super(notifier: controller);

  static GallerySettingsController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<GallerySettings>()!
      .notifier!;
}

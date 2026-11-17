import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Adds the notices for third-party work bundled in Liquid to the app's
/// licence page (`showLicensePage`, or the "Licenses" row in Settings):
/// the free BoardUI components Liquid adapts (MIT), whose licence asks for
/// its notice to ship with the app.
///
/// [LqScope] calls [ensureRegistered] for you, so apps need no setup. The
/// texts are read only when the licence page is opened.
abstract final class LqLicenses {
  static bool _registered = false;

  static const _boardUi = 'packages/liquid_flutter_design_system/licenses/BOARDUI_LICENSE.txt';

  /// Registers the notices once per app run. Safe to call repeatedly.
  static void ensureRegistered() {
    if (_registered) return;
    _registered = true;
    LicenseRegistry.addLicense(_entries);
  }

  static Stream<LicenseEntry> _entries() async* {
    yield LicenseEntryWithLineBreaks(
      const ['BoardUI (adapted in Liquid Flutter Design System)'],
      await rootBundle.loadString(_boardUi),
    );
  }
}

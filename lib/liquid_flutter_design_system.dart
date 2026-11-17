/// Liquid Flutter Design System.
///
/// Brand tokens, light, dark and high-contrast themes, Liquid Glass surfaces
/// and components with fluid, spring-based motion that feel native on iOS
/// and Android.
///
/// Wrap the app in [LqScope] and read tokens with `context.lq`. A new app
/// changes only its [LqBrand]. See CONVENTIONS.md before adding components.
library;

export 'package:remixicon/remixicon.dart' show RemixIcons;

// Foundations
export 'src/foundation/glass.dart';
export 'src/foundation/haptics.dart';
export 'src/foundation/licenses.dart';
export 'src/foundation/pressable.dart';
export 'src/foundation/spring.dart';
export 'src/theme/lq_theme.dart';
export 'src/theme/platform_theme.dart';
export 'src/tokens/brand.dart';
export 'src/tokens/colors.dart';
export 'src/tokens/metrics.dart';
export 'src/tokens/motion.dart';
export 'src/tokens/palette.dart';
export 'src/tokens/typography.dart';

// Components, one barrel per category.
export 'src/components/actions/actions.dart';
export 'src/components/charts/charts.dart';
export 'src/components/data/data.dart';
export 'src/components/feedback/feedback.dart';
export 'src/components/inputs/inputs.dart';
export 'src/components/layout/layout.dart';
export 'src/components/motion/motion.dart';
export 'src/components/navigation/navigation.dart';
export 'src/components/overlays/overlays.dart';

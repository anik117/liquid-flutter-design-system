import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/glass.dart';
import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// A Liquid Glass back button that pops the nearest Navigator. Round with a
/// chevron by default; pass [title] for the iOS-style "‹ Drives" capsule
/// naming the page you return to. Swells under the finger like all glass.
class LqBackButton extends StatelessWidget {
  const LqBackButton({super.key, this.title, this.onPressed});

  /// The previous page's name, e.g. "Drives". Null shows the chevron only.
  final String? title;

  /// Replaces the default pop, e.g. to confirm discarding edits first.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final chevron = Transform.flip(
      flipX: rtl,
      child: Icon(
        RemixIcons.arrow_left_s_line,
        size: LqIconSize.xxl,
        color: c.iconPrimary,
      ),
    );
    return LqPressable(
      onTap: onPressed ?? () => Navigator.maybePop(context),
      semanticLabel: title == null ? 'Back' : 'Back to $title',
      scale: LqMotion.glassPressScale,
      builder: (context, pressed) {
        if (title == null) {
          return SizedBox.square(
            dimension: LqSize.control,
            child: LqGlass(lit: pressed, child: Center(child: chevron)),
          );
        }
        return SizedBox(
          height: LqSize.control,
          child: LqGlass(
            lit: pressed,
            padding: const EdgeInsetsDirectional.only(
              start: LqSpace.x2,
              end: LqSpace.x4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                chevron,
                const SizedBox(width: 2),
                Flexible(
                  child: ExcludeSemantics(
                    child: Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: lq.type.bodyMedium.copyWith(color: c.textPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

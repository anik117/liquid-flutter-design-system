import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/typography.dart';
import 'avatar.dart';

/// A row of overlapping avatars, each ringed in the surface color, ending in
/// a "+N" chip when there are more people than [max].
class LqAvatarGroup extends StatelessWidget {
  const LqAvatarGroup({
    super.key,
    required this.avatars,
    this.max = 4,
    this.size = LqAvatarSize.small,
    this.overlap = 0.3,
  });

  /// Everyone in the group, in display order. Their own sizes are ignored.
  final List<LqAvatar> avatars;

  /// Most avatars to draw before collapsing the rest into "+N".
  final int max;

  /// Diameter of every avatar in the group.
  final LqAvatarSize size;

  /// Fraction of each avatar hidden under the next one.
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final shown = avatars.length > max ? max - 1 : avatars.length;
    final extra = avatars.length - shown;
    final d = size.diameter + 4; // ring included
    final step = d * (1 - overlap);
    final count = shown + (extra > 0 ? 1 : 0);
    final names = avatars.take(shown).map((a) => a.name).toList();
    final label = extra > 0
        ? '${names.join(', ')} and $extra more'
        : names.length > 1
        ? '${names.take(names.length - 1).join(', ')} and ${names.last}'
        : names.join();

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: SizedBox(
        width: count == 0 ? 0 : step * (count - 1) + d,
        height: d,
        child: Stack(
          children: [
            for (var i = 0; i < shown; i++)
              Positioned(
                left: step * i,
                child: LqAvatar(
                  name: avatars[i].name,
                  image: avatars[i].image,
                  icon: avatars[i].icon,
                  status: avatars[i].status,
                  size: size,
                  ring: true,
                ),
              ),
            if (extra > 0)
              Positioned(
                left: step * shown,
                child: Container(
                  width: d,
                  height: d,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: c.surface, shape: BoxShape.circle),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: c.surfaceSunken,
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text(
                          '+$extra',
                          style: LqTypography.numeric(lq.type.caption)
                              .copyWith(color: c.textSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

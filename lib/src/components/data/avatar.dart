import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/colors.dart';
import '../feedback/badge.dart';

/// Avatar diameters.
enum LqAvatarSize {
  /// 24pt, inline with text.
  xs(24),

  /// 32pt, in list rows.
  small(32),

  /// 40pt, the default.
  medium(40),

  /// 56pt, profile headers.
  large(56),

  /// 72pt, a profile page hero.
  xl(72);

  const LqAvatarSize(this.diameter);

  /// Width and height in points.
  final double diameter;
}

/// A round picture of a person or account: an [image], or the name's
/// initials on a soft tint picked from the name (the same name always gets
/// the same tint), or an [icon]. An optional [status] dot sits bottom-right.
class LqAvatar extends StatelessWidget {
  const LqAvatar({
    super.key,
    required this.name,
    this.image,
    this.icon,
    this.size = LqAvatarSize.medium,
    this.status,
    this.ring = false,
  });

  /// Whose avatar this is. Used for initials, tint and the screen reader.
  final String name;

  /// Photo; falls back to initials if it fails to load.
  final ImageProvider? image;

  /// Glyph shown instead of initials, e.g. for a fleet or a vehicle.
  final IconData? icon;

  /// Diameter.
  final LqAvatarSize size;

  /// Status dot tone: positive for online or driving, neutral for offline.
  final LqTone? status;

  /// A surface-colored ring, used when avatars overlap in a group.
  final bool ring;

  /// "Maya Chen" → "MC", "Sam" → "S".
  static String initials(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.isEmpty) return '';
    final first = words.first.characters.first;
    final last = words.length > 1 ? words.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  /// The soft tint and ink a name always maps to.
  static (Color bg, Color fg) tintFor(LqColors c, String name) {
    const tones = [LqTone.accent, LqTone.info, LqTone.caution, LqTone.neutral];
    var hash = 0;
    for (final unit in name.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return LqBadge.colorsFor(c, tones[hash % tones.length]);
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final d = size.diameter;
    final (bg, fg) = tintFor(c, name);
    final fallback = Center(
      child: icon != null
          ? Icon(icon, size: d * 0.5, color: fg)
          : Text(
              initials(name),
              maxLines: 1,
              textScaler: TextScaler.noScaling,
              style: lq.type.subheadMedium.copyWith(
                color: fg,
                fontSize: d * 0.4,
                height: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
    final face = Container(
      width: d,
      height: d,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: image == null
          ? fallback
          : Image(
              image: image!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
    final dot = (d * 0.28).clamp(8.0, 16.0);
    return Semantics(
      label: name,
      image: true,
      excludeSemantics: true,
      child: Container(
        padding: ring ? const EdgeInsets.all(2) : EdgeInsets.zero,
        decoration: ring
            ? BoxDecoration(color: c.surface, shape: BoxShape.circle)
            : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            face,
            if (status != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: dot,
                  height: dot,
                  decoration: BoxDecoration(
                    color: _statusColor(c, status!),
                    shape: BoxShape.circle,
                    border: Border.all(color: c.surface, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Color _statusColor(LqColors c, LqTone tone) => switch (tone) {
    LqTone.neutral => c.iconTertiary,
    LqTone.accent || LqTone.positive => c.positive,
    LqTone.caution => c.caution,
    LqTone.danger => c.textDanger,
    LqTone.info => c.info,
  };
}

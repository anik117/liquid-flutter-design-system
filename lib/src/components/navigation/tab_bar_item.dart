import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/motion.dart';

class LqTabItem {
  const LqTabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.id,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;

  /// Stable id for UI tests and Maestro (`id: "nav_drives"`): set as the
  /// tab's semantics identifier and widget key.
  final String? id;
}

/// One tab's icon and label. Taps and drags are handled by the bar, so
/// this cell only draws and exposes itself to screen readers.
class LqTabCell extends StatelessWidget {
  const LqTabCell({
    super.key,
    required this.item,
    required this.selected,
    required this.onSelect,
  });

  final LqTabItem item;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final color = selected ? c.accent : c.textSecondary;
    // One accessibility element per tab, with its own tap action:
    // excludeSemantics would otherwise leave VoiceOver unable to switch.
    return Semantics(
      key: item.id == null ? null : ValueKey<String>(item.id!),
      identifier: item.id,
      button: true,
      selected: selected,
      label: item.label,
      onTap: onSelect,
      excludeSemantics: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: selected ? 1.06 : 1,
            duration: LqMotion.of(context, LqMotion.slow),
            curve: LqMotion.springCurve,
            child: Icon(
              selected ? item.activeIcon : item.icon,
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: lq.type.caption.copyWith(color: color, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

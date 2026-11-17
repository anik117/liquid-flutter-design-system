import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'menu_layout.dart';

/// Something listed in an [LqMenuButton]'s menu: an item, a header or a
/// divider.
sealed class LqMenuEntry<T> {
  const LqMenuEntry();
}

/// A choice in a menu. Pass [checked] for options in a set (sort order,
/// filters) so the current one shows a checkmark.
class LqMenuItem<T> extends LqMenuEntry<T> {
  const LqMenuItem({
    required this.label,
    required this.value,
    this.icon,
    this.checked = false,
    this.destructive = false,
  });

  /// Item text, sentence case.
  final String label;

  /// Passed to `onSelected` when tapped.
  final T value;

  /// Optional trailing glyph, as on iOS menus.
  final IconData? icon;

  /// Shows a leading checkmark: this is the current choice.
  final bool checked;

  /// Draws the item in the danger color.
  final bool destructive;
}

/// A small quiet title over a group of items, e.g. "Sort by".
class LqMenuHeader<T> extends LqMenuEntry<T> {
  const LqMenuHeader(this.label);

  /// Header text.
  final String label;
}

/// A thicker gap line between groups of items.
class LqMenuDivider<T> extends LqMenuEntry<T> {
  const LqMenuDivider();
}

/// The menu's rows, laid out at the panel's full size.
class LqMenuBody<T> extends StatelessWidget {
  const LqMenuBody({super.key, required this.entries, required this.onPick});

  /// What to list.
  final List<LqMenuEntry<T>> entries;

  /// Called with the tapped item.
  final ValueChanged<LqMenuItem<T>> onPick;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final scaler = MediaQuery.textScalerOf(context);
    final anyChecked = entries.any((e) => e is LqMenuItem<T> && e.checked);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: LqMenuMetrics.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final e in entries)
            switch (e) {
              LqMenuDivider<T>() => SizedBox(
                height: LqMenuMetrics.divider,
                child: Center(child: Container(height: 1, color: c.separator)),
              ),
              LqMenuHeader<T>(:final label) => SizedBox(
                height: LqMenuMetrics.headerHeight(scaler),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    LqSpace.x4,
                    LqSpace.x2,
                    LqSpace.x4,
                    0,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    style: lq.type.footnote.copyWith(color: c.textSecondary),
                  ),
                ),
              ),
              LqMenuItem<T>() => _ItemRow(
                item: e,
                height: LqMenuMetrics.itemHeight(scaler),
                reserveCheck: anyChecked,
                onTap: () => onPick(e),
              ),
            },
        ],
      ),
    );
  }
}

class _ItemRow<T> extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.height,
    required this.reserveCheck,
    required this.onTap,
  });

  final LqMenuItem<T> item;
  final double height;
  final bool reserveCheck;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final fg = item.destructive ? c.textDanger : c.textPrimary;
    return Semantics(
      selected: item.checked,
      child: LqPressable(
        onTap: onTap,
        scale: 1,
        haptic: LqHaptic.selection,
        semanticLabel: item.label,
        builder: (context, pressed) => AnimatedContainer(
          duration: LqMotion.fast,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: LqMenuMetrics.padding),
          padding: const EdgeInsets.symmetric(horizontal: LqSpace.x3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(lq.radius.md),
            color: c.textPrimary.withValues(alpha: pressed ? 0.08 : 0),
          ),
          child: Row(
            children: [
              if (reserveCheck)
                SizedBox(
                  width: LqSpace.x6,
                  child: item.checked
                      ? Icon(
                          RemixIcons.check_line,
                          size: LqIconSize.md,
                          color: fg,
                        )
                      : null,
                ),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: lq.type.body.copyWith(color: fg),
                ),
              ),
              if (item.icon != null)
                Icon(item.icon, size: LqIconSize.lg, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import '../../tokens/hues.dart';
import 'badge.dart';

/// An inline alert that sits in the page: "Sync paused while offline".
/// A soft tint carries the tone; warnings are amber ([LqTone.caution]),
/// never alarm red. Dismissing it collapses the space it took.
class LqBanner extends StatefulWidget {
  const LqBanner({
    super.key,
    required this.title,
    this.message,
    this.tone = LqTone.info,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.raised = false,
    this.hue,
  });

  /// A card-shaped notice: a light tint of the tone with the glyph on a
  /// white tile, so it reads as a notice among a page's white cards.
  final bool raised;

  /// The glyph tile's hue when [raised]; defaults to the tone's tint.
  final LqHue? hue;

  /// One short sentence saying what happened.
  final String title;

  /// Optional second line saying what it means or what to do.
  final String? message;

  /// What the banner means: info, positive, caution or danger.
  final LqTone tone;

  /// Overrides the tone's default glyph.
  final IconData? icon;

  /// Label of the optional inline action, e.g. "Retry".
  final String? actionLabel;

  /// Called when the action is tapped.
  final VoidCallback? onAction;

  /// Shows a close button; called once the banner has collapsed.
  final VoidCallback? onDismiss;

  /// The default glyph for each tone.
  static IconData iconFor(LqTone tone) => switch (tone) {
    LqTone.positive => RemixIcons.checkbox_circle_fill,
    LqTone.caution => RemixIcons.error_warning_fill,
    LqTone.danger => RemixIcons.close_circle_fill,
    LqTone.accent => RemixIcons.sparkling_fill,
    _ => RemixIcons.information_fill,
  };

  @override
  State<LqBanner> createState() => _LqBannerState();
}

class _LqBannerState extends State<LqBanner> {
  bool _visible = true;

  void _dismiss() {
    if (!_visible) return;
    setState(() => _visible = false);
    // Report once the collapse has played, whether or not the size moved.
    Future<void>.delayed(LqMotion.of(context, LqMotion.standard), () {
      if (mounted) widget.onDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = LqMotion.of(context, LqMotion.standard);
    return AnimatedSize(
      duration: duration,
      curve: LqMotion.emphasized,
      alignment: Alignment.topCenter,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: LqMotion.of(context, LqMotion.fast),
        child: _visible
            ? _Body(banner: widget, onDismiss: _dismiss)
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.banner, required this.onDismiss});

  final LqBanner banner;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final (bg, fg) = LqBadge.colorsFor(c, banner.tone);
    final dismissible = banner.onDismiss != null;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      liveRegion: true,
      child: Container(
        decoration: banner.raised
            ? BoxDecoration(
                color: Color.alphaBlend(bg.withValues(alpha: c.isDark ? (bg.a < 1 ? bg.a : 0.5) : bg.a * 0.6), c.surface),
                borderRadius: BorderRadius.circular(lq.radius.xl),
                border: Border.all(color: fg.withValues(alpha: 0.12), width: 0.5),
              )
            : BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(lq.radius.lg),
                border: Border.all(color: fg.withValues(alpha: 0.14)),
              ),
        // The action's 44pt tap area supplies the bottom space when present.
        padding: EdgeInsets.fromLTRB(banner.raised ? LqSpace.x4 : LqSpace.x3, LqSpace.x3,
            dismissible ? 0 : LqSpace.x4, banner.actionLabel == null ? LqSpace.x3 : 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (banner.raised)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(lq.radius.sm)),
                child: Icon(banner.icon ?? LqBanner.iconFor(banner.tone), size: 20, color: banner.hue?.onSoft(c) ?? fg),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(banner.icon ?? LqBanner.iconFor(banner.tone), size: LqIconSize.lg, color: fg),
              ),
            const SizedBox(width: LqSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(banner.title, style: lq.type.subheadMedium.copyWith(color: c.textPrimary)),
                  if (banner.message != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      banner.message!,
                      style: lq.type.footnote.copyWith(color: c.textSecondary),
                    ),
                  ],
                  if (banner.actionLabel != null)
                    LqPressable(
                      onTap: banner.onAction,
                      semanticLabel: banner.actionLabel,
                      builder: (context, pressed) => AnimatedOpacity(
                        opacity: pressed ? 0.6 : 1,
                        duration: LqMotion.fast,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            banner.actionLabel!,
                            style: lq.type.subheadMedium.copyWith(color: banner.hue?.onSoft(c) ?? fg),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (dismissible)
              Transform.translate(
                offset: const Offset(0, -LqSpace.x2 - 2),
                child: LqPressable(
                  onTap: onDismiss,
                  semanticLabel: 'Dismiss',
                  scale: 0.9,
                  builder: (context, pressed) => SizedBox.square(
                    dimension: LqSize.control,
                    child: Icon(
                      RemixIcons.close_line,
                      size: LqIconSize.md,
                      color: pressed ? c.iconPrimary : c.iconSecondary,
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

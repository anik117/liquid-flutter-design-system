import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../actions/button.dart';

/// What a screen shows before it has anything: a glyph in a soft tile, one
/// calm sentence, an optional line of help and at most one action.
/// "No drives yet" with "Start your first drive".
class LqEmptyState extends StatelessWidget {
  const LqEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  /// The glyph in the soft tile, naming what is missing.
  final IconData icon;

  /// One sentence, e.g. "No drives yet".
  final String title;

  /// Optional help line saying what will appear here and how.
  final String? message;

  /// Label of the single action, e.g. "Start your first drive".
  final String? actionLabel;

  /// Optional leading glyph for the action button.
  final IconData? actionIcon;

  /// Called when the action is tapped. The button hides when null.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: LqSpace.x8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(lq.radius.xl),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      c.accentSoft,
                      Color.lerp(c.accentSoft, c.accentSoftPressed, 0.6)!,
                    ],
                  ),
                ),
                child: Icon(icon, size: LqIconSize.hero, color: c.accentOnSoft),
              ),
              const SizedBox(height: LqSpace.x4),
              Semantics(
                header: true,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: lq.type.headline.copyWith(color: c.textPrimary),
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: LqSpace.x1 + 2),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: lq.type.subhead.copyWith(color: c.textSecondary),
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: LqSpace.x5),
                LqButton(
                  label: actionLabel!,
                  leadingIcon: actionIcon,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'action_sheet_row.dart';

/// One row in an action sheet. Tapping it returns [value].
class LqSheetAction<T> {
  const LqSheetAction({
    required this.label,
    required this.value,
    this.icon,
    this.destructive = false,
  });

  /// Row text: a verb ("Duplicate", "Mark as personal").
  final String label;

  /// Returned from [showLqActionSheet] when tapped.
  final T value;

  /// Optional leading glyph.
  final IconData? icon;

  /// Draws the row in the danger color, e.g. "Delete".
  final bool destructive;
}

/// Shows an iOS-style action sheet: a glass panel of actions above a
/// separate Cancel capsule, rising from the bottom on a spring. Returns
/// the tapped action's value, or null for Cancel or a scrim tap.
Future<T?> showLqActionSheet<T>(
  BuildContext context, {
  required List<LqSheetAction<T>> actions,
  String? title,
  String? message,
  String cancelLabel = 'Cancel',
}) {
  final lq = context.lq;
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: cancelLabel,
    barrierColor: lq.colors.scrim,
    transitionDuration: LqMotion.of(context, LqMotion.slow),
    pageBuilder: (sheetContext, _, _) => LqScope(
      data: lq,
      child: _ActionSheet<T>(
        actions: actions,
        title: title,
        message: message,
        cancelLabel: cancelLabel,
      ),
    ),
    transitionBuilder: (context, animation, _, child) => SlideTransition(
      position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: animation,
          curve: LqMotion.springCurve,
          reverseCurve: const Interval(0.4, 1, curve: Curves.easeIn),
        ),
      ),
      child: child,
    ),
  );
}

class _ActionSheet<T> extends StatelessWidget {
  const _ActionSheet({
    required this.actions,
    required this.cancelLabel,
    this.title,
    this.message,
  });

  final List<LqSheetAction<T>> actions;
  final String? title, message;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final navigator = Navigator.of(context);
    final radius = lq.radius.xxl;
    final rows = <Widget>[
      if (title != null || message != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LqSpace.x4,
            LqSpace.x4,
            LqSpace.x4,
            LqSpace.x3,
          ),
          child: Column(
            children: [
              if (title != null)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: lq.type.footnoteMedium.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              if (message != null)
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: lq.type.footnote.copyWith(color: c.textTertiary),
                ),
            ],
          ),
        ),
      for (final a in actions)
        LqActionSheetRow(
          label: a.label,
          icon: a.icon,
          color: a.destructive ? c.textDanger : c.textPrimary,
          onTap: () => navigator.pop(a.value),
        ),
    ];
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            LqSpace.x2,
            0,
            LqSpace.x2,
            MediaQuery.paddingOf(context).bottom + LqSpace.x2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LqGlass(
                weight: LqGlassWeight.thick,
                radius: radius,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < rows.length; i++) ...[
                      if (i > 0) Container(height: 0.5, color: c.separator),
                      rows[i],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: LqSpace.x2),
              LqGlass(
                weight: LqGlassWeight.thick,
                child: LqActionSheetRow(
                  label: cancelLabel,
                  color: c.textAccent,
                  bold: true,
                  onTap: navigator.pop,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../foundation/glass.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import '../actions/button.dart';

/// One button in an [LqDialog]. Tapping it closes the dialog and returns
/// [value] from [showLqDialog].
class LqDialogAction<T> {
  const LqDialogAction({
    required this.label,
    required this.value,
    this.primary = false,
    this.destructive = false,
  });

  /// Button text: a verb naming the outcome ("Delete drive"), never "OK".
  final String label;

  /// Returned from [showLqDialog] when tapped.
  final T value;

  /// The recommended choice: filled with the accent.
  final bool primary;

  /// Loses data: filled red. Use instead of [primary], not with it.
  final bool destructive;
}

/// Shows a centered alert on thick Liquid Glass and returns the tapped
/// action's value, or null if the person tapped the scrim. It springs in
/// from a slightly larger scale and leaves quicker than it came.
Future<T?> showLqDialog<T>(
  BuildContext context, {
  required String title,
  String? message,
  required List<LqDialogAction<T>> actions,
  bool barrierDismissible = true,
}) {
  final lq = context.lq;
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    barrierColor: lq.colors.scrim,
    transitionDuration: LqMotion.of(context, LqMotion.slow),
    pageBuilder: (dialogContext, _, _) => LqScope(
      data: lq,
      child: LqDialog(title: title, message: message, actions: actions),
    ),
    transitionBuilder: (context, animation, _, child) {
      // Exit runs on the last 55% of the reverse ramp, so it is faster.
      final t = CurvedAnimation(
        parent: animation,
        curve: LqMotion.springCurve,
        reverseCurve: const Interval(0.45, 1, curve: Curves.easeIn),
      );
      final fade = CurvedAnimation(
        parent: animation,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
        reverseCurve: const Interval(0.45, 1, curve: Curves.easeIn),
      );
      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.08, end: 1).animate(t),
          child: child,
        ),
      );
    },
  );
}

/// The alert panel: title, optional message and up to three actions. Two
/// short actions sit side by side; otherwise they stack, primary first.
class LqDialog<T> extends StatelessWidget {
  const LqDialog({
    super.key,
    required this.title,
    this.message,
    required this.actions,
  });

  /// A short question or statement: "Delete this drive?".
  final String title;

  /// What happens next, in one or two sentences.
  final String? message;

  /// One to three actions; side by side, list them cancel first.
  final List<LqDialogAction<T>> actions;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final sideBySide =
        actions.length == 2 && actions.every((a) => a.label.length <= 12);
    Widget button(LqDialogAction<T> a) => LqButton(
      label: a.label,
      expand: true,
      variant: a.destructive
          ? LqButtonVariant.danger
          : a.primary
          ? LqButtonVariant.primary
          : LqButtonVariant.secondary,
      onPressed: () => Navigator.of(context).pop(a.value),
    );
    // Stacked: the emphasized action goes on top, nearest the message.
    final ordered = sideBySide
        ? actions
        : [
            ...actions.where((a) => a.primary || a.destructive),
            ...actions.where((a) => !a.primary && !a.destructive),
          ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LqSpace.x8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Semantics(
            scopesRoute: true,
            namesRoute: true,
            explicitChildNodes: true,
            label: title,
            child: LqGlass(
              weight: LqGlassWeight.thick,
              radius: lq.radius.xxl,
              padding: const EdgeInsets.fromLTRB(
                LqSpace.x5,
                LqSpace.x6,
                LqSpace.x5,
                LqSpace.x5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: lq.type.headline.copyWith(color: c.textPrimary),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: LqSpace.x2),
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: lq.type.subhead.copyWith(color: c.textSecondary),
                    ),
                  ],
                  const SizedBox(height: LqSpace.x5),
                  if (sideBySide)
                    Row(
                      children: [
                        Expanded(child: button(ordered[0])),
                        const SizedBox(width: LqSpace.x3),
                        Expanded(child: button(ordered[1])),
                      ],
                    )
                  else
                    for (var i = 0; i < ordered.length; i++) ...[
                      if (i > 0) const SizedBox(height: LqSpace.x2),
                      button(ordered[i]),
                    ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

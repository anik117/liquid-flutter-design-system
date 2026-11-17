import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show AdaptiveTextSelectionToolbar;

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';

/// The edit menu for every Liquid text input: the native iOS menu where the
/// system offers it, Flutter's adaptive toolbar elsewhere.
Widget lqEditMenu(BuildContext context, EditableTextState state) {
  if (context.lq.isIOS && SystemContextMenu.isSupported(context)) {
    return SystemContextMenu.editableText(editableTextState: state);
  }
  return AdaptiveTextSelectionToolbar.editableText(editableTextState: state);
}

/// The bordered white box behind BoardUI fields: a hairline border and a
/// contact shadow at rest, a brand border with a soft ring while focused,
/// red when there is an error. Shared by the text area and picker fields so
/// they match [LqTextField].
class FieldBox extends StatelessWidget {
  const FieldBox({
    super.key,
    required this.child,
    this.focused = false,
    this.hasError = false,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: LqSpace.x3),
    this.minHeight = LqSize.control + 4,
  });

  /// The field's content.
  final Widget child;

  /// Draws the brand border and focus ring.
  final bool focused;

  /// Draws the danger border.
  final bool hasError;

  /// False greys the box out.
  final bool enabled;

  /// Space between the border and the content.
  final EdgeInsetsGeometry padding;

  /// Height the box never shrinks below.
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final borderColor = hasError
        ? c.textDanger
        : focused
        ? c.accent
        : c.border;
    return AnimatedContainer(
      duration: LqMotion.fast,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding,
      decoration: BoxDecoration(
        color: enabled ? c.surface : c.disabledFill,
        borderRadius: BorderRadius.circular(lq.radius.md),
        border: Border.all(color: borderColor, width: focused ? 1.5 : 1),
        boxShadow: focused
            ? [BoxShadow(color: borderColor.withValues(alpha: 0.18), spreadRadius: 3)]
            : LqShadows.card(c.shadow),
      ),
      child: child,
    );
  }
}

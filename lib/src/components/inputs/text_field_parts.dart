import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';

/// The ⓧ that clears a field while editing, like UITextField's clear button.
class FieldClearButton extends StatelessWidget {
  const FieldClearButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => LqPressable(
    semanticLabel: 'Clear text',
    haptic: LqHaptic.selection,
    onTap: onTap,
    builder: (_, _) => Padding(
      padding: const EdgeInsets.only(left: LqSpace.x2),
      child: Icon(
        RemixIcons.close_circle_fill,
        size: 18,
        color: context.lq.colors.iconTertiary,
      ),
    ),
  );
}

/// Label above, helper or error below. Shared by every form control so
/// they line up in a stack.
class FieldFrame extends StatelessWidget {
  const FieldFrame({
    super.key,
    required this.child,
    this.label,
    this.message,
    this.isError = false,
    this.onLabelTap,
  });

  final Widget child;
  final String? label;
  final String? message;
  final bool isError;
  final VoidCallback? onLabelTap;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          GestureDetector(
            onTap: onLabelTap,
            child: Padding(
              padding: const EdgeInsets.only(left: LqSpace.x1, bottom: LqSpace.x2),
              child: Text(
                label!,
                style: lq.type.subheadMedium.copyWith(color: c.textPrimary),
              ),
            ),
          ),
        child,
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(left: LqSpace.x1, top: LqSpace.x2),
            child: Text(
              message!,
              style: lq.type.footnote.copyWith(
                color: isError ? c.textDanger : c.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Fixed text inside a field, such as a currency sign or a unit.
class FieldAffix extends StatelessWidget {
  const FieldAffix(this.text, {super.key, required this.style, required this.color});

  final String text;
  final TextStyle style;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: LqSpace.x1),
    child: Text(text, style: style.copyWith(color: color)),
  );
}

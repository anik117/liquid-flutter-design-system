import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoTextThemeData, CupertinoTheme;
import 'package:flutter/widgets.dart';

import '../../foundation/pressable.dart';
import '../../theme/lq_theme.dart';
import '../../theme/platform_theme.dart';
import '../../tokens/metrics.dart';
import '../actions/button.dart';
import '../overlays/sheet.dart';
import 'field_kit.dart';
import 'text_field_parts.dart';

/// A read-only field that opens a picker: it looks exactly like
/// [LqTextField] (label, bordered box, helper) and shows the chosen value
/// or a grey placeholder, with a trailing glyph. The border turns brand
/// while its picker is open.
class PickerFieldShell extends StatelessWidget {
  const PickerFieldShell({
    super.key,
    required this.text,
    required this.trailingIcon,
    required this.onTap,
    this.label,
    this.placeholder,
    this.helper,
    this.error,
    this.prefixIcon,
    this.open = false,
  });

  /// The chosen value as text, or null to show [placeholder].
  final String? text;

  /// Chevron, calendar or clock glyph on the right.
  final IconData trailingIcon;

  /// Opens the picker; null disables the field.
  final VoidCallback? onTap;

  /// Text above the box.
  final String? label;

  /// Grey text while nothing is chosen.
  final String? placeholder;

  /// Quiet note under the box.
  final String? helper;

  /// Replaces [helper] and turns the border red.
  final String? error;

  /// Optional glyph before the value.
  final IconData? prefixIcon;

  /// True while the picker is showing.
  final bool open;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final enabled = onTap != null;
    final shown = text ?? placeholder ?? '';
    final color = !enabled
        ? c.disabledText
        : text == null
        ? c.textPlaceholder
        : c.textPrimary;
    final field = LqPressable(
      onTap: onTap,
      scale: 1,
      haptic: LqHaptic.light,
      semanticLabel: [?label, text ?? placeholder ?? ''].join(', '),
      builder: (context, pressed) => FieldBox(
        focused: open || pressed,
        hasError: error != null,
        enabled: enabled,
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: LqIconSize.lg, color: c.iconSecondary),
              const SizedBox(width: LqSpace.x2),
            ],
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: LqSpace.x3),
                child: Text(shown, style: lq.type.body.copyWith(color: color)),
              ),
            ),
            const SizedBox(width: LqSpace.x2),
            Icon(trailingIcon, size: LqIconSize.lg, color: c.iconTertiary),
          ],
        ),
      ),
    );
    return FieldFrame(
      label: label,
      message: error ?? helper,
      isError: error != null,
      onLabelTap: onTap,
      child: field,
    );
  }
}

/// Opens an [LqSheet] holding an iOS wheel ([picker]) under a title with a
/// Done button. Done returns [result]'s value; dragging the sheet away
/// returns null so nothing changes. The wheel is themed with the brand's
/// colors and type.
Future<T?> showLqWheelSheet<T>(
  BuildContext context, {
  required WidgetBuilder picker,
  required T Function() result,
  String? title,
  String doneLabel = 'Done',
}) {
  final lq = context.lq;
  final c = lq.colors;
  final wheelText = lq.type.title3.copyWith(
    fontWeight: FontWeight.w400,
    color: c.textPrimary,
  );
  final theme = lq.toCupertinoTheme().copyWith(
    textTheme: CupertinoTextThemeData(
      primaryColor: c.accent,
      pickerTextStyle: wheelText,
      dateTimePickerTextStyle: wheelText,
    ),
  );
  return showLqSheet<T>(
    context,
    title: title,
    trailing: Builder(
      builder: (sheetContext) => LqButton(
        label: doneLabel,
        variant: LqButtonVariant.plain,
        size: LqButtonSize.small,
        onPressed: () => Navigator.of(sheetContext).pop(result()),
      ),
    ),
    builder: (sheetContext) => SizedBox(
      height: 216,
      child: CupertinoTheme(data: theme, child: Builder(builder: picker)),
    ),
  );
}

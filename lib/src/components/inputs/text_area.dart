import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show InputDecoration, Material, MaterialType, TextField;

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import '../../tokens/typography.dart';
import 'field_kit.dart';
import 'text_field_parts.dart';

/// A multi-line [LqTextField]: the same bordered box, label and helper, on
/// the native keyboard and edit menu. It grows from [minLines] to
/// [maxLines] as the person types, then scrolls. With [maxLength] a quiet
/// "112 / 280" counter sits in the corner and turns red at the limit.
class LqTextArea extends StatefulWidget {
  const LqTextArea({
    super.key,
    this.controller,
    this.label,
    this.placeholder,
    this.helper,
    this.error,
    this.minLines = 3,
    this.maxLines = 8,
    this.maxLength,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.enabled = true,
    this.onChanged,
  });

  /// Owns the text; one is created when omitted.
  final TextEditingController? controller;

  /// Text above the box.
  final String? label;

  /// Grey hint shown while empty.
  final String? placeholder;

  /// Quiet note under the box.
  final String? helper;

  /// Replaces [helper] and turns the border red.
  final String? error;

  /// Height of the empty box, in lines.
  final int minLines;

  /// Lines the box grows to before it scrolls.
  final int maxLines;

  /// Caps the text and shows a character counter.
  final int? maxLength;

  /// Keyboard capitalization; sentences by default for notes.
  final TextCapitalization textCapitalization;

  /// Focuses the field when it first appears.
  final bool autofocus;

  /// False greys the field out and blocks editing.
  final bool enabled;

  /// Called on every edit.
  final ValueChanged<String>? onChanged;

  @override
  State<LqTextArea> createState() => _LqTextAreaState();
}

class _LqTextAreaState extends State<LqTextArea> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_rebuild);
    _controller.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focus.removeListener(_rebuild);
    _controller.removeListener(_rebuild);
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final max = widget.maxLength;
    final count = _controller.text.characters.length;

    final field = TextField(
      controller: _controller,
      focusNode: _focus,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: max,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      // The counter is drawn in the box's corner instead.
      buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
          null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textCapitalization: widget.textCapitalization,
      keyboardAppearance: c.brightness,
      onTapOutside: (_) => _focus.unfocus(),
      onChanged: widget.onChanged,
      style: lq.type.body.copyWith(
        color: widget.enabled ? c.textPrimary : c.disabledText,
      ),
      cursorColor: c.accent,
      decoration: InputDecoration.collapsed(
        hintText: widget.placeholder,
        hintStyle: lq.type.body.copyWith(color: c.textPlaceholder),
      ),
      contextMenuBuilder: lqEditMenu,
    );

    final atLimit = max != null && count >= max;
    final box = FieldBox(
      focused: _focus.hasFocus,
      hasError: widget.error != null,
      enabled: widget.enabled,
      padding: const EdgeInsets.fromLTRB(
        LqSpace.x3,
        LqSpace.x3,
        LqSpace.x3,
        LqSpace.x2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Growth between minLines and maxLines eases instead of jumping.
          AnimatedSize(
            duration: LqMotion.of(context, LqMotion.fast),
            curve: LqMotion.emphasized,
            alignment: Alignment.topCenter,
            child: Material(type: MaterialType.transparency, child: field),
          ),
          if (max != null)
            Align(
              alignment: Alignment.centerRight,
              child: Semantics(
                label: '$count of $max characters',
                excludeSemantics: true,
                child: Text(
                  '$count / $max',
                  style: LqTypography.numeric(lq.type.footnote).copyWith(
                    color: atLimit ? c.textDanger : c.textTertiary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return FieldFrame(
      label: widget.label,
      message: widget.error ?? widget.helper,
      isError: widget.error != null,
      onLabelTap: () => _focus.requestFocus(),
      // The whole box (clear button, prefix, counter) counts as part of the
      // field, so tapping them does not trigger onTapOutside and unfocus.
      child: TextFieldTapRegion(child: box),
    );
  }
}


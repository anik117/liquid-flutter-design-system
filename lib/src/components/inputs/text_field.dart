import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show
        AdaptiveTextSelectionToolbar,
        InputDecoration,
        Material,
        MaterialType,
        TextField;
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'text_field_parts.dart';

/// BoardUI's input, on the platform's own text engine. The keyboard is the
/// real system keyboard (matching light or dark), iOS gets the native edit
/// menu, and a clear button appears while editing, like UITextField.
class LqTextField extends StatefulWidget {
  const LqTextField({
    super.key,
    this.controller,
    this.label,
    this.placeholder,
    this.helper,
    this.error,
    this.prefixIcon,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
    this.showClearButton = true,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String? label;
  final String? placeholder;
  final String? helper;

  /// Replaces [helper] and turns the border red.
  final String? error;
  final IconData? prefixIcon;

  /// Fixed text before or after the value, like "$" or "mi".
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;
  final bool showClearButton;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<LqTextField> createState() => _LqTextFieldState();
}

class _LqTextFieldState extends State<LqTextField> {
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
    final focused = _focus.hasFocus;
    final hasError = widget.error != null;
    final showClear = widget.showClearButton &&
        focused &&
        _controller.text.isNotEmpty &&
        widget.enabled;
    final valueStyle = lq.type.body.copyWith(
      color: widget.enabled ? c.textPrimary : c.disabledText,
    );

    final field = TextField(
      controller: _controller,
      focusNode: _focus,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      keyboardAppearance: c.brightness,
      // Tapping anywhere else closes the keyboard, as iOS users expect.
      onTapOutside: (_) => _focus.unfocus(),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: valueStyle,
      cursorColor: c.accent,
      decoration: InputDecoration.collapsed(
        hintText: widget.placeholder,
        hintStyle: lq.type.body.copyWith(color: c.textPlaceholder),
      ),
      contextMenuBuilder: (context, state) {
        if (lq.isIOS && SystemContextMenu.isSupported(context)) {
          return SystemContextMenu.editableText(editableTextState: state);
        }
        return AdaptiveTextSelectionToolbar.editableText(
          editableTextState: state,
        );
      },
    );

    final borderColor = hasError
        ? c.textDanger
        : focused
        ? c.accent
        : c.border;

    final box = AnimatedContainer(
      duration: LqMotion.fast,
      constraints: const BoxConstraints(minHeight: LqSize.control + 4),
      padding: const EdgeInsets.symmetric(horizontal: LqSpace.x3),
      decoration: BoxDecoration(
        color: widget.enabled ? c.surface : c.disabledFill,
        borderRadius: BorderRadius.circular(lq.radius.md),
        border: Border.all(color: borderColor, width: focused ? 1.5 : 1),
        boxShadow: focused
            ? [BoxShadow(color: borderColor.withValues(alpha: 0.18), spreadRadius: 3)]
            : LqShadows.card(c.shadow),
      ),
      child: Row(
        children: [
          if (widget.prefixIcon != null) ...[
            Icon(widget.prefixIcon, size: 20, color: c.iconSecondary),
            const SizedBox(width: LqSpace.x2),
          ],
          if (widget.prefixText != null)
            FieldAffix(widget.prefixText!, style: valueStyle, color: c.textSecondary),
          // TextField needs a Material ancestor; a transparent one keeps the
          // field working in apps that never use Material surfaces.
          Expanded(
            child: Material(type: MaterialType.transparency, child: field),
          ),
          if (widget.suffixText != null)
            FieldAffix(widget.suffixText!, style: valueStyle, color: c.textSecondary),
          if (showClear)
            FieldClearButton(
              onTap: () {
                _controller.clear();
                widget.onChanged?.call('');
              },
            ),
        ],
      ),
    );

    return FieldFrame(
      label: widget.label,
      message: widget.error ?? widget.helper,
      isError: hasError,
      onLabelTap: () => _focus.requestFocus(),
      // The whole box (clear button, prefix, counter) counts as part of the
      // field, so tapping them does not trigger onTapOutside and unfocus.
      child: TextFieldTapRegion(child: box),
    );
  }
}

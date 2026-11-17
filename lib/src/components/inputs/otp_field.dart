import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show InputDecoration, Material, MaterialType, TextField;

import '../../foundation/haptics.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import 'field_kit.dart';
import 'otp_parts.dart';
import 'text_field_parts.dart';

/// One-time code entry: [length] bordered boxes over a single invisible
/// text input, so the number pad, iOS "From Messages" autofill and paste
/// all work natively. The active box blinks a caret; each digit pops in.
class LqOtpField extends StatefulWidget {
  const LqOtpField({
    super.key,
    this.length = 6,
    this.controller,
    this.label,
    this.helper,
    this.error,
    this.autofocus = false,
    this.onChanged,
    this.onCompleted,
    this.semanticLabel = 'One-time code',
  });

  /// Number of digits, usually 6.
  final int length;

  /// Owns the code; one is created when omitted.
  final TextEditingController? controller;

  /// Text above the boxes.
  final String? label;

  /// Quiet note under the boxes.
  final String? helper;

  /// Replaces [helper] and turns every box red.
  final String? error;

  /// Focuses the field and opens the keypad when it first appears.
  final bool autofocus;

  /// Called on every edit with the digits so far.
  final ValueChanged<String>? onChanged;

  /// Called once all [length] digits are in.
  final ValueChanged<String>? onCompleted;

  /// Read by screen readers for the hidden input.
  final String semanticLabel;

  @override
  State<LqOtpField> createState() => _LqOtpFieldState();
}

class _LqOtpFieldState extends State<LqOtpField>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  final FocusNode _focus = FocusNode();
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  String _last = '';

  @override
  void initState() {
    super.initState();
    _last = _controller.text;
    _focus.addListener(_onFocus);
    _controller.addListener(_onText);
  }

  void _onFocus() {
    if (!mounted) return;
    _restartBlink();
    setState(() {});
  }

  void _restartBlink() {
    if (_focus.hasFocus && !LqMotion.reduced(context)) {
      _blink.repeat();
    } else {
      _blink
        ..stop()
        ..value = 0;
    }
  }

  void _onText() {
    final text = _controller.text;
    // The caret always sits after the last digit, whatever was tapped.
    final end = TextSelection.collapsed(offset: text.length);
    if (_controller.selection != end) _controller.selection = end;
    if (text == _last) return;
    _last = text;
    _restartBlink();
    setState(() {});
    widget.onChanged?.call(text);
    if (text.length == widget.length) {
      LqHaptics.play(LqHaptic.light);
      widget.onCompleted?.call(text);
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _controller.removeListener(_onText);
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.lq.colors;
    final text = _controller.text;
    final focused = _focus.hasFocus;
    final blink = _blink.drive(const OtpBlink());

    final boxes = Row(
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: LqSpace.x2),
          Expanded(
            child: OtpBox(
              char: i < text.length ? text[i] : '',
              active: focused &&
                  (i == text.length || (i == widget.length - 1 && text.length == widget.length)),
              hasError: widget.error != null,
              blink: blink,
            ),
          ),
        ],
      ],
    );

    // The real input lies on top, fully transparent: taps focus it, a long
    // press brings up the native Paste menu, and autofill targets it.
    final input = Opacity(
      opacity: 0,
      child: Material(
        type: MaterialType.transparency,
        child: Semantics(
          label: widget.semanticLabel,
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            autofocus: widget.autofocus,
            showCursor: false,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.oneTimeCode],
            keyboardAppearance: c.brightness,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(widget.length),
            ],
            onTapOutside: (_) => _focus.unfocus(),
            contextMenuBuilder: lqEditMenu,
            style: const TextStyle(fontSize: 1, height: 1),
            decoration: const InputDecoration.collapsed(hintText: null),
          ),
        ),
      ),
    );

    return FieldFrame(
      label: widget.label,
      message: widget.error ?? widget.helper,
      isError: widget.error != null,
      onLabelTap: () => _focus.requestFocus(),
      child: SizedBox(
        height: 56,
        child: Stack(
          fit: StackFit.expand,
          children: [ExcludeSemantics(child: boxes), input],
        ),
      ),
    );
  }
}

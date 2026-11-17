import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show InputDecoration, Material, MaterialType, TextField;
import 'package:remixicon/remixicon.dart';

import '../../foundation/pressable.dart';
import '../../foundation/spring.dart';
import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import 'field_kit.dart';
import 'text_field_parts.dart';

/// iOS search: a sunken capsule with a magnifier and a clear button. While
/// searching, a "Cancel" button springs in from the right and the field
/// narrows to make room; Cancel clears the query and closes the keyboard.
class LqSearchField extends StatefulWidget {
  const LqSearchField({
    super.key,
    this.controller,
    this.placeholder = 'Search',
    this.cancelLabel = 'Cancel',
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onCancel,
  });

  /// Owns the query; one is created when omitted.
  final TextEditingController? controller;

  /// Grey hint inside the capsule, e.g. "Search drives".
  final String placeholder;

  /// Text of the button that ends the search.
  final String cancelLabel;

  /// Focuses the field when it first appears.
  final bool autofocus;

  /// Called on every edit, and with '' when cleared or cancelled.
  final ValueChanged<String>? onChanged;

  /// Called when the keyboard's Search key is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Called after Cancel clears and closes the search.
  final VoidCallback? onCancel;

  @override
  State<LqSearchField> createState() => _LqSearchFieldState();
}

class _LqSearchFieldState extends State<LqSearchField>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  final FocusNode _focus = FocusNode();
  // Unbounded so the spring can overshoot a touch, as UIKit's does.
  late final AnimationController _reveal = AnimationController.unbounded(vsync: this);
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_sync);
    _controller.addListener(_sync);
  }

  void _sync() {
    if (!mounted) return;
    // Searching while focused or holding a query; Cancel stays until then.
    final active = _focus.hasFocus || _controller.text.isNotEmpty;
    if (active != _active) {
      _active = active;
      LqSpring.animate(_reveal, active ? 1 : 0, context: context);
    }
    setState(() {});
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  void _cancel() {
    _clear();
    _focus.unfocus();
    widget.onCancel?.call();
  }

  @override
  void dispose() {
    _focus.removeListener(_sync);
    _controller.removeListener(_sync);
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final field = TextField(
      controller: _controller,
      focusNode: _focus,
      autofocus: widget.autofocus,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      keyboardAppearance: c.brightness,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: lq.type.body.copyWith(color: c.textPrimary),
      cursorColor: c.accent,
      decoration: InputDecoration.collapsed(
        hintText: widget.placeholder,
        hintStyle: lq.type.body.copyWith(color: c.textPlaceholder),
      ),
      contextMenuBuilder: lqEditMenu,
    );

    final capsule = Container(
      height: LqSize.controlSmall + 2,
      padding: const EdgeInsets.symmetric(horizontal: LqSpace.x3),
      decoration: BoxDecoration(
        color: c.segmentedTrack,
        borderRadius: BorderRadius.circular(LqRadius.full),
      ),
      child: Row(
        children: [
          Icon(RemixIcons.search_line, size: LqIconSize.md, color: c.iconSecondary),
          const SizedBox(width: LqSpace.x2),
          Expanded(
            child: Semantics(
              label: widget.placeholder,
              child: Material(type: MaterialType.transparency, child: field),
            ),
          ),
          if (_controller.text.isNotEmpty) FieldClearButton(onTap: _clear),
        ],
      ),
    );

    final cancel = LqPressable(
      semanticLabel: widget.cancelLabel,
      haptic: LqHaptic.light,
      onTap: _cancel,
      builder: (_, pressed) => Container(
        height: LqSize.control,
        padding: const EdgeInsets.only(left: LqSpace.x3),
        alignment: Alignment.center,
        child: Text(
          widget.cancelLabel,
          maxLines: 1,
          style: lq.type.body.copyWith(
            color: pressed ? c.accentOnSoft : c.textAccent,
          ),
        ),
      ),
    );

    return SizedBox(
      height: LqSize.control,
      child: Row(
        children: [
          Expanded(child: capsule),
          AnimatedBuilder(
            animation: _reveal,
            builder: (context, child) {
              final t = _reveal.value;
              if (t <= 0.001 && !_active) return const SizedBox.shrink();
              // Width grows with the spring; the label slides in from the edge.
              return ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: t.clamp(0.0, 1.2),
                  child: FractionalTranslation(
                    translation: Offset((1 - t).clamp(0.0, 1.0), 0),
                    child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
                  ),
                ),
              );
            },
            child: ExcludeSemantics(excluding: !_active, child: cancel),
          ),
        ],
      ),
    );
  }
}

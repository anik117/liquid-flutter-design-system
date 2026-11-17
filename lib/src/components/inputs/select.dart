import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoPicker, FixedExtentScrollController;
import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../data/list_group.dart';
import '../data/list_row.dart';
import '../overlays/sheet.dart';
import 'picker_parts.dart';

/// One choice in an [LqSelect].
class LqSelectOption<T> {
  const LqSelectOption({required this.value, required this.label, this.description});

  /// What [LqSelect.onChanged] reports when this is picked.
  final T value;

  /// Shown in the field and the picker, e.g. "2022 Toyota Prius".
  final String label;

  /// A quieter second line in the Android list.
  final String? description;
}

/// A field that looks like [LqTextField] and opens a native-feeling picker:
/// on iOS a sheet with a wheel and a Done button, on Android a sheet with a
/// list of rows and a check on the current one. Wheel and rows tick
/// selection haptics.
class LqSelect<T> extends StatefulWidget {
  const LqSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.label,
    this.placeholder = 'Select',
    this.helper,
    this.error,
    this.prefixIcon,
    this.sheetTitle,
  });

  /// The choices, in order.
  final List<LqSelectOption<T>> options;

  /// The selected value, or null to show [placeholder].
  final T? value;

  /// Called with the newly picked value; null disables the field.
  final ValueChanged<T>? onChanged;

  /// Text above the field.
  final String? label;

  /// Grey text while nothing is chosen.
  final String placeholder;

  /// Quiet note under the field.
  final String? helper;

  /// Replaces [helper] and turns the border red.
  final String? error;

  /// Optional glyph before the value.
  final IconData? prefixIcon;

  /// Title of the picker sheet; defaults to [label].
  final String? sheetTitle;

  @override
  State<LqSelect<T>> createState() => _LqSelectState<T>();
}

class _LqSelectState<T> extends State<LqSelect<T>> {
  bool _open = false;

  int get _index => widget.options.indexWhere((o) => o.value == widget.value);

  Future<void> _pick() async {
    if (widget.options.isEmpty) return;
    setState(() => _open = true);
    final title = widget.sheetTitle ?? widget.label;
    // A one-field record, so a dismissed sheet (null) differs from a null value.
    final (T,)? picked = context.lq.isIOS
        ? await _wheel(title)
        : await showLqSheet<(T,)>(context, title: title, builder: _list);
    if (!mounted) return;
    setState(() => _open = false);
    if (picked != null && picked.$1 != widget.value) widget.onChanged?.call(picked.$1);
  }

  Future<(T,)?> _wheel(String? title) async {
    final start = _index < 0 ? 0 : _index;
    var current = start;
    final scroll = FixedExtentScrollController(initialItem: start);
    final lq = context.lq;
    final result = await showLqWheelSheet<(T,)>(
      context,
      title: title,
      result: () => (widget.options[current].value,),
      picker: (_) => CupertinoPicker(
        scrollController: scroll,
        itemExtent: 40,
        onSelectedItemChanged: (i) => current = i,
        children: [
          for (final o in widget.options)
            Center(
              child: Text(
                o.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: lq.type.title3.copyWith(
                  fontWeight: FontWeight.w400,
                  color: lq.colors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
    scroll.dispose();
    return result;
  }

  Widget _list(BuildContext sheetContext) {
    final c = sheetContext.lq.colors;
    return LqListGroup(
      leadingInset: false,
      children: [
        for (final o in widget.options)
          Semantics(
            selected: o.value == widget.value,
            child: LqListRow(
              title: o.label,
              subtitle: o.description,
              showChevron: false,
              trailing: o.value == widget.value
                  ? Icon(RemixIcons.check_line, size: LqIconSize.lg, color: c.textAccent)
                  : null,
              onTap: () => Navigator.of(sheetContext).pop((o.value,)),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final i = _index;
    return PickerFieldShell(
      label: widget.label,
      text: i < 0 ? null : widget.options[i].label,
      placeholder: widget.placeholder,
      helper: widget.helper,
      error: widget.error,
      prefixIcon: widget.prefixIcon,
      trailingIcon: RemixIcons.expand_up_down_line,
      open: _open,
      onTap: widget.onChanged == null ? null : _pick,
    );
  }
}

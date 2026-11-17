import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoDatePicker, CupertinoDatePickerMode;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show showDatePicker;
import 'package:remixicon/remixicon.dart';

import '../../theme/lq_theme.dart';
import 'date_format.dart';
import 'picker_parts.dart';

/// A field that shows a date ("Tue, Nov 17, 2026") and opens the platform's
/// own picker: on iOS a sheet with the date wheel and a Done button, on
/// Android Material's calendar dialog, both in brand colors. The time of
/// day already in [value] is kept.
class LqDateField extends StatefulWidget {
  const LqDateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.placeholder = 'Select a date',
    this.helper,
    this.error,
    this.firstDate,
    this.lastDate,
    this.sheetTitle,
  });

  /// The chosen date, or null to show [placeholder].
  final DateTime? value;

  /// Called with the new date; null disables the field.
  final ValueChanged<DateTime>? onChanged;

  /// Text above the field.
  final String? label;

  /// Grey text while no date is chosen.
  final String placeholder;

  /// Quiet note under the field.
  final String? helper;

  /// Replaces [helper] and turns the border red.
  final String? error;

  /// Earliest pickable date; defaults to ten years back.
  final DateTime? firstDate;

  /// Latest pickable date; defaults to the end of next year.
  final DateTime? lastDate;

  /// Title of the iOS picker sheet; defaults to [label].
  final String? sheetTitle;

  @override
  State<LqDateField> createState() => _LqDateFieldState();
}

class _LqDateFieldState extends State<LqDateField> {
  bool _open = false;

  Future<void> _pick() async {
    final now = DateTime.now();
    final first = widget.firstDate ?? DateTime(now.year - 10);
    final last = widget.lastDate ?? DateTime(now.year + 1, 12, 31);
    var initial = widget.value ?? now;
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;

    setState(() => _open = true);
    DateTime? picked;
    if (context.lq.isIOS) {
      var current = initial;
      picked = await showLqWheelSheet<DateTime>(
        context,
        title: widget.sheetTitle ?? widget.label,
        result: () => current,
        picker: (_) => CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: initial,
          minimumDate: first,
          maximumDate: last,
          showDayOfWeek: true,
          onDateTimeChanged: (d) => current = d,
        ),
      );
    } else {
      picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: first,
        lastDate: last,
      );
    }
    if (!mounted) return;
    setState(() => _open = false);
    if (picked == null) return;
    final keep = widget.value ?? initial;
    final next = DateTime(
      picked.year,
      picked.month,
      picked.day,
      keep.hour,
      keep.minute,
    );
    if (next != widget.value) widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.value;
    return PickerFieldShell(
      label: widget.label,
      text: v == null ? null : LqDateFormat.date(v),
      placeholder: widget.placeholder,
      helper: widget.helper,
      error: widget.error,
      trailingIcon: RemixIcons.calendar_line,
      open: _open,
      onTap: widget.onChanged == null ? null : _pick,
    );
  }
}

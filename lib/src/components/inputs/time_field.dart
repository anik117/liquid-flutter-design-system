import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoDatePicker, CupertinoDatePickerMode;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay, showTimePicker;
import 'package:remixicon/remixicon.dart';

import '../../theme/lq_theme.dart';
import 'date_format.dart';
import 'picker_parts.dart';

/// A field that shows a time of day ("6:41 PM", or "18:41" when the device
/// uses a 24-hour clock) and opens the platform's own picker: on iOS a
/// sheet with the time wheel and a Done button, on Android Material's
/// clock dialog. Only the hour and minute change; the date in [value] is
/// kept.
class LqTimeField extends StatefulWidget {
  const LqTimeField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.placeholder = 'Select a time',
    this.helper,
    this.error,
    this.minuteInterval = 1,
    this.sheetTitle,
  });

  /// The chosen time (its date is carried along), or null for [placeholder].
  final DateTime? value;

  /// Called with the new date-time; null disables the field.
  final ValueChanged<DateTime>? onChanged;

  /// Text above the field.
  final String? label;

  /// Grey text while no time is chosen.
  final String placeholder;

  /// Quiet note under the field.
  final String? helper;

  /// Replaces [helper] and turns the border red.
  final String? error;

  /// Minute steps on the iOS wheel, e.g. 5; must divide 60.
  final int minuteInterval;

  /// Title of the iOS picker sheet; defaults to [label].
  final String? sheetTitle;

  @override
  State<LqTimeField> createState() => _LqTimeFieldState();
}

class _LqTimeFieldState extends State<LqTimeField> {
  bool _open = false;

  Future<void> _pick() async {
    final base = widget.value ?? DateTime.now();
    // The iOS wheel needs a start time on its minute grid.
    final step = widget.minuteInterval;
    final initial = DateTime(
      base.year,
      base.month,
      base.day,
      base.hour,
      base.minute - base.minute % step,
    );
    final use24h = MediaQuery.alwaysUse24HourFormatOf(context);

    setState(() => _open = true);
    DateTime? picked;
    if (context.lq.isIOS) {
      var current = initial;
      picked = await showLqWheelSheet<DateTime>(
        context,
        title: widget.sheetTitle ?? widget.label,
        result: () => current,
        picker: (_) => CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: initial,
          minuteInterval: step,
          use24hFormat: use24h,
          onDateTimeChanged: (d) => current = d,
        ),
      );
    } else {
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(base),
      );
      if (t != null) picked = DateTime(base.year, base.month, base.day, t.hour, t.minute);
    }
    if (!mounted) return;
    setState(() => _open = false);
    if (picked == null) return;
    final next = DateTime(base.year, base.month, base.day, picked.hour, picked.minute);
    if (next != widget.value) widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.value;
    return PickerFieldShell(
      label: widget.label,
      text: v == null
          ? null
          : LqDateFormat.time(v, use24h: MediaQuery.alwaysUse24HourFormatOf(context)),
      placeholder: widget.placeholder,
      helper: widget.helper,
      error: widget.error,
      trailingIcon: RemixIcons.time_line,
      open: _open,
      onTap: widget.onChanged == null ? null : _pick,
    );
  }
}

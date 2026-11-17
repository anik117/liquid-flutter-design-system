import 'package:flutter/widgets.dart';

import '../../foundation/haptics.dart';
import '../../tokens/motion.dart';
import 'calendar_strip_parts.dart';

/// A week of days in a row (weekday letter over the date), for picking a
/// day. The selected day sits in an accent pill that slides between days;
/// days with drives get a dot. Swipe sideways for the previous or next
/// week.
class LqCalendarStrip extends StatefulWidget {
  const LqCalendarStrip({
    super.key,
    required this.selected,
    required this.onChanged,
    this.hasDrives,
    this.today,
    this.firstWeekday = DateTime.monday,
    this.onWeekChanged,
    this.height = 68,
  });

  /// The selected day (time of day is ignored).
  final DateTime selected;

  /// Called with the tapped day.
  final ValueChanged<DateTime> onChanged;

  /// Whether a day has drives and gets a dot.
  final bool Function(DateTime day)? hasDrives;

  /// Today; defaults to the device date.
  final DateTime? today;

  /// First column, as a [DateTime] weekday (Monday = 1, Sunday = 7).
  final int firstWeekday;

  /// Called with the first day of a week after swiping to it.
  final ValueChanged<DateTime>? onWeekChanged;

  /// Height of the strip.
  final double height;

  @override
  State<LqCalendarStrip> createState() => _LqCalendarStripState();
}

class _LqCalendarStripState extends State<LqCalendarStrip> {
  static const _origin = 5000;
  late final DateTime _anchor =
      CalendarDays.weekStart(widget.selected, widget.firstWeekday);
  final _pages = PageController(initialPage: _origin);

  DateTime _weekAt(int page) => CalendarDays.add(_anchor, (page - _origin) * 7);

  int _pageFor(DateTime d) {
    final start = CalendarDays.weekStart(d, widget.firstWeekday);
    return _origin + (CalendarDays.between(_anchor, start) / 7).round();
  }

  @override
  void didUpdateWidget(LqCalendarStrip old) {
    super.didUpdateWidget(old);
    if (CalendarDays.same(old.selected, widget.selected) || !_pages.hasClients) {
      return;
    }
    // A day picked elsewhere (e.g. a date picker) brings its week into view.
    final page = _pageFor(widget.selected);
    if (page == _pages.page?.round()) return;
    if (LqMotion.reduced(context)) {
      _pages.jumpToPage(page);
    } else {
      _pages.animateToPage(
        page,
        duration: LqMotion.slow,
        curve: LqMotion.emphasized,
      );
    }
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _select(DateTime d) {
    if (CalendarDays.same(d, widget.selected)) return;
    LqHaptics.play(LqHaptic.selection);
    widget.onChanged(d);
  }

  @override
  Widget build(BuildContext context) {
    final today = CalendarDays.day(widget.today ?? DateTime.now());
    final selected = CalendarDays.day(widget.selected);
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pages,
        onPageChanged: (p) => widget.onWeekChanged?.call(_weekAt(p)),
        itemBuilder: (context, p) => CalendarWeek(
          start: _weekAt(p),
          selected: selected,
          today: today,
          hasDrives: widget.hasDrives,
          onTap: _select,
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../theme/lq_theme.dart';
import '../../tokens/metrics.dart';
import '../../tokens/motion.dart';
import '../../tokens/typography.dart';

/// Calendar day arithmetic that ignores the clock and daylight saving.
abstract final class CalendarDays {
  static DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime add(DateTime d, int days) =>
      DateTime(d.year, d.month, d.day + days);

  static int between(DateTime a, DateTime b) =>
      (day(b).difference(day(a)).inHours / 24).round();

  static DateTime weekStart(DateTime d, int firstWeekday) =>
      add(day(d), -((d.weekday - firstWeekday) % 7));

  static bool same(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static const weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
  static const months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December',
  ];
}

/// One week of a calendar strip: seven day cells and the accent pill that
/// slides to the selected day when it falls in this week.
class CalendarWeek extends StatelessWidget {
  const CalendarWeek({
    super.key,
    required this.start,
    required this.selected,
    required this.today,
    required this.hasDrives,
    required this.onTap,
  });

  /// First day of the week.
  final DateTime start;

  /// The selected day.
  final DateTime selected;

  /// Today, drawn in the accent when not selected.
  final DateTime today;

  /// Whether a day gets a dot.
  final bool Function(DateTime day)? hasDrives;

  /// Called with the tapped day.
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final lq = context.lq;
    final c = lq.colors;
    final index = CalendarDays.between(start, selected);
    final inWeek = index >= 0 && index < 7;
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth / 7;
        return Stack(
          children: [
            AnimatedPositioned(
              duration: LqMotion.of(context, LqMotion.slow),
              curve: LqMotion.springCurve,
              left: w * (inWeek ? index : 3) + 3,
              width: w - 6,
              top: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: inWeek ? 1 : 0,
                duration: LqMotion.of(context, LqMotion.fast),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [c.accentTop, c.accentBottom],
                    ),
                    borderRadius: BorderRadius.circular(lq.radius.md),
                    boxShadow: LqShadows.xs(c.shadow),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(child: _cell(context, CalendarDays.add(start, i))),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _cell(BuildContext context, DateTime d) {
    final lq = context.lq;
    final c = lq.colors;
    final isSelected = CalendarDays.same(d, selected);
    final isToday = CalendarDays.same(d, today);
    final dot = hasDrives?.call(d) ?? false;
    final ink = isSelected
        ? c.textOnAccent
        : (isToday ? c.textAccent : c.textPrimary);
    final quiet = isSelected ? c.textOnAccent.withValues(alpha: 0.8) : c.textSecondary;
    final name = CalendarDays.weekdays[d.weekday - 1];
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$name, ${CalendarDays.months[d.month - 1]} ${d.day}'
          '${isToday ? ', today' : ''}${dot ? ', has drives' : ''}',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(d),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: LqMotion.fast,
              style: lq.type.caption.copyWith(color: quiet),
              child: Text(name.substring(0, 1)),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: LqMotion.fast,
              style: LqTypography.numeric(lq.type.headline).copyWith(color: ink),
              child: Text('${d.day}'),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: LqMotion.fast,
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: !dot
                    ? c.textOnAccent.withValues(alpha: 0)
                    : (isSelected ? c.textOnAccent : c.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

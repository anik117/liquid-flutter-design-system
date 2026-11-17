/// Formats dates and times the way the system shows them in US English
/// ("Tue, Nov 17, 2026", "6:41 PM") without pulling in `intl`.
abstract final class LqDateFormat {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Weekday, month, day and year: "Tue, Nov 17, 2026".
  static String date(DateTime d) =>
      '${_days[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}, ${d.year}';

  /// Hour and minute: "6:41 PM", or "18:41" with [use24h].
  static String time(DateTime t, {bool use24h = false}) {
    final mm = t.minute.toString().padLeft(2, '0');
    if (use24h) return '${t.hour.toString().padLeft(2, '0')}:$mm';
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    return '$h:$mm ${t.hour < 12 ? 'AM' : 'PM'}';
  }
}

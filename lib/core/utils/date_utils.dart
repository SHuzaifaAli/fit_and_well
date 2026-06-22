import 'package:intl/intl.dart';

/// Date and time utility functions
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayDateFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _shortDateFormat = DateFormat('MMM d');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dayFormat = DateFormat('EEEE');
  static final DateFormat _shortDayFormat = DateFormat('EEE');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');

  /// Format date to ISO string (yyyy-MM-dd)
  static String toIsoDate(DateTime date) => _dateFormat.format(date);

  /// Format date for display (Jan 1, 2024)
  static String toDisplayDate(DateTime date) =>
      _displayDateFormat.format(date);

  /// Format date short (Jan 1)
  static String toShortDate(DateTime date) => _shortDateFormat.format(date);

  /// Format time (3:30 PM)
  static String toTime(DateTime date) => _timeFormat.format(date);

  /// Format day name (Monday)
  static String toDayName(DateTime date) => _dayFormat.format(date);

  /// Format short day name (Mon)
  static String toShortDayName(DateTime date) => _shortDayFormat.format(date);

  /// Format month and year (January 2024)
  static String toMonthYear(DateTime date) => _monthYearFormat.format(date);

  /// Parse ISO date string
  static DateTime? fromIsoDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return _dateFormat.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  /// Get today's date at midnight
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get start of week (Monday)
  static DateTime get startOfWeek {
    final now = today;
    return now.subtract(Duration(days: now.weekday - 1));
  }

  /// Get start of month
  static DateTime get startOfMonth {
    final now = today;
    return DateTime(now.year, now.month, 1);
  }

  /// Get start of year
  static DateTime get startOfYear {
    final now = today;
    return DateTime(now.year, 1, 1);
  }

  /// Get last 7 days
  static List<DateTime> getLast7Days() {
    return List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
  }

  /// Get last 30 days
  static List<DateTime> getLast30Days() {
    return List.generate(30, (i) => today.subtract(Duration(days: 29 - i)));
  }

  /// Get last 12 months
  static List<DateTime> getLast12Months() {
    final now = today;
    return List.generate(12, (i) {
      final month = now.month - (11 - i);
      final year = now.year + (month <= 0 ? -1 : 0);
      final adjustedMonth = month <= 0 ? month + 12 : month;
      return DateTime(year, adjustedMonth, 1);
    });
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = today;
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = today.subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Get relative date string (Today, Yesterday, or date)
  static String toRelativeDate(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isYesterday(date)) return 'Yesterday';
    return toDisplayDate(date);
  }

  /// Calculate age from birthdate
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Format duration in minutes to readable string
  static String formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }
}

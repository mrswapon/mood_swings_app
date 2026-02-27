import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDate(DateTime dt) => DateFormat.yMMMd().format(dt);

  static String formatTime(DateTime dt) => DateFormat.jm().format(dt);

  static String formatFull(DateTime dt) =>
      DateFormat.yMMMEd().add_jm().format(dt);

  static String formatDayMonth(DateTime dt) => DateFormat.MMMd().format(dt);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  static DateTime startOfWeek(DateTime dt) =>
      stripTime(dt.subtract(Duration(days: dt.weekday - 1)));

  static DateTime endOfWeek(DateTime dt) =>
      stripTime(dt.add(Duration(days: 7 - dt.weekday)));

  static DateTime startOfMonth(DateTime dt) =>
      DateTime(dt.year, dt.month, 1);

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

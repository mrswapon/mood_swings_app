import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mood_swings_app/constants/mood_constants.dart';
import 'package:mood_swings_app/utils/date_utils.dart';

class MoodCalendarWidget extends StatelessWidget {
  final Map<DateTime, MoodType> dailyMoodMap;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  const MoodCalendarWidget({
    super.key,
    required this.dailyMoodMap,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) =>
          selectedDay != null && AppDateUtils.isSameDay(day, selectedDay!),
      onDaySelected: (selected, focused) => onDaySelected(selected),
      onPageChanged: onPageChanged,
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        todayTextStyle: TextStyle(color: Colors.black87),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF7C4DFF),
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final stripped = AppDateUtils.stripTime(day);
          final mood = dailyMoodMap[stripped];
          if (mood != null) {
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mood.color.withValues(alpha: 0.4),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            );
          }
          return null;
        },
        todayBuilder: (context, day, focusedDay) {
          final stripped = AppDateUtils.stripTime(day);
          final mood = dailyMoodMap[stripped];
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mood?.color.withValues(alpha: 0.4),
              border: Border.all(
                color: const Color(0xFF7C4DFF),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}

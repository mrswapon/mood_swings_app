import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mood_swings_app/providers/mood_provider.dart';
import 'package:mood_swings_app/screens/entry/mood_entry_screen.dart';
import 'package:mood_swings_app/utils/date_utils.dart';
import 'package:mood_swings_app/widgets/calendar_widget.dart';
import 'package:mood_swings_app/widgets/empty_state.dart';
import 'package:mood_swings_app/widgets/mood_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();
    final selectedEntries = moodProvider.entriesForDate(_selectedDay);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          MoodCalendarWidget(
            dailyMoodMap: moodProvider.dailyMoodMap,
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: (day) => setState(() {
              _selectedDay = day;
              _focusedDay = day;
            }),
            onPageChanged: (day) => setState(() => _focusedDay = day),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  AppDateUtils.formatDate(_selectedDay),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '${selectedEntries.length} ${selectedEntries.length == 1 ? 'entry' : 'entries'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: selectedEntries.isEmpty
                ? const EmptyState(
                    emoji: '\u{1F4C5}',
                    title: 'No entries for this day',
                    subtitle: 'Tap + to log a mood',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: selectedEntries.length,
                    itemBuilder: (context, index) {
                      final entry = selectedEntries[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: MoodCard(
                          entry: entry,
                          onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MoodEntryScreen(existingEntry: entry),
                            ),
                          ),
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Entry'),
                                content: const Text(
                                    'Are you sure you want to delete this entry?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      moodProvider.deleteEntry(entry.id);
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

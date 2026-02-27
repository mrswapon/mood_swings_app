import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mood_swings_app/constants/mood_constants.dart';
import 'package:mood_swings_app/models/mood_entry.dart';
import 'package:mood_swings_app/providers/mood_provider.dart';
import 'package:mood_swings_app/screens/entry/mood_entry_screen.dart';
import 'package:mood_swings_app/utils/date_utils.dart';
import 'package:mood_swings_app/widgets/empty_state.dart';
import 'package:mood_swings_app/widgets/mood_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              '${AppDateUtils.greeting()} \u{1F44B}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),

            // Today's mood
            if (moodProvider.todayEntry != null) ...[
              Text(
                "Today's Mood",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _TodayMoodBanner(entry: moodProvider.todayEntry!),
            ] else ...[
              _LogMoodPrompt(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MoodEntryScreen(),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Recent entries
            if (moodProvider.recentEntries.isNotEmpty) ...[
              Text(
                'Recent Entries',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...moodProvider.recentEntries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MoodCard(
                    entry: entry,
                    onEdit: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MoodEntryScreen(existingEntry: entry),
                      ),
                    ),
                    onDelete: () => _confirmDelete(context, moodProvider, entry.id),
                  ),
                ),
              ),
            ] else ...[
              const EmptyState(),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, MoodProvider provider, String entryId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this mood entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteEntry(entryId);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _TodayMoodBanner extends StatelessWidget {
  final MoodEntry entry;

  const _TodayMoodBanner({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              entry.moodType.color.withValues(alpha: 0.3),
              entry.moodType.color.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(
              entry.moodType.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            Text(
              entry.moodType.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (entry.note != null && entry.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                entry.note!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LogMoodPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const _LogMoodPrompt({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                '\u{1F31F}',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 12),
              Text(
                'Log your mood',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap here to record how you feel right now',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

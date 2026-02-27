import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mood_swings_app/constants/mood_constants.dart';
import 'package:mood_swings_app/providers/mood_provider.dart';
import 'package:mood_swings_app/theme/app_colors.dart';
import 'package:mood_swings_app/widgets/empty_state.dart';
import 'package:mood_swings_app/widgets/mood_chart.dart';
import 'package:mood_swings_app/widgets/mood_pie_chart.dart';
import 'package:mood_swings_app/widgets/stat_summary_card.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _selectedPeriod = 0;

  int get _periodDays => switch (_selectedPeriod) {
        0 => 7,
        1 => 30,
        _ => 365,
      };

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();

    if (moodProvider.entries.isEmpty) {
      return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Statistics',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            const Expanded(
              child: EmptyState(
                emoji: '\u{1F4CA}',
                title: 'No data yet',
                subtitle: 'Start logging moods to see your trends',
              ),
            ),
          ],
        ),
      );
    }

    final chartData = moodProvider.dailyAverages(_periodDays);
    final distribution = moodProvider.moodDistribution;
    final mostCommon = moodProvider.mostCommonMood;
    final streak = moodProvider.currentStreak;
    final totalEntries = moodProvider.entries.length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            //=======================> Period selector <=============
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Week')),
                ButtonSegment(value: 1, label: Text('Month')),
                ButtonSegment(value: 2, label: Text('All Time')),
              ],
              selected: {_selectedPeriod},
              onSelectionChanged: (selection) {
                setState(() => _selectedPeriod = selection.first);
              },
            ),
            const SizedBox(height: 24),

            //=======================> Mood trend chart <=============
            Text(
              'Mood Trends',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (chartData.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: MoodChart(data: chartData),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No data for this period',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            //=======================> Summary cards <=============
            Text(
              'Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatSummaryCard(
                    title: 'Current\nStreak',
                    value: '$streak ${streak == 1 ? 'day' : 'days'}',
                    icon: Icons.local_fire_department,
                    color: AppColors.accent,
                    delay: 0,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatSummaryCard(
                    title: 'Most\nCommon',
                    value: mostCommon != null
                        ? '${mostCommon.emoji} ${mostCommon.label}'
                        : '-',
                    icon: Icons.emoji_emotions,
                    color: mostCommon?.color ?? Colors.grey,
                    delay: 120,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatSummaryCard(
                    title: 'Total\nEntries',
                    value: '$totalEntries',
                    icon: Icons.edit_note,
                    color: AppColors.primary,
                    delay: 240,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            //=======================> Distribution <=============
            Text(
              'Mood Distribution',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MoodPieChart(distribution: distribution),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
